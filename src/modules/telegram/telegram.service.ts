import {
  Injectable,
  HttpException,
  HttpStatus,
  OnModuleInit,
  Inject,
  forwardRef,
} from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { TelegramSettings } from "../../entities/telegram-settings.entity";
import { User } from "../../entities/user.entity";
import { SubscriptionsService } from "../subscriptions/subscriptions.service";
import { UsersService } from "../users/users.service";

@Injectable()
export class TelegramService implements OnModuleInit {
  private lastUpdateId = 0;
  private isPolling = false;
  private isWebhookActive = false;

  constructor(
    @InjectRepository(TelegramSettings)
    private telegramSettingsRepo: Repository<TelegramSettings>,
    @Inject(forwardRef(() => SubscriptionsService))
    private subscriptionsService: SubscriptionsService,
    private usersService: UsersService,
  ) {}

  async onModuleInit() {
    // Start intelligent polling (will only run if Webhook is not active/available)
    this.startIntelligentPolling();
  }

  /**
   * Get current Telegram settings
   */
  async getSettings(): Promise<TelegramSettings | null> {
    return await this.telegramSettingsRepo.findOne({ where: {} });
  }

  /**
   * Save/Update settings and manage polling/webhook state
   */
  async saveSettings(dto: any): Promise<TelegramSettings> {
    let settings = await this.telegramSettingsRepo.findOne({ where: {} });

    if (!settings) {
      settings = this.telegramSettingsRepo.create(
        dto as Partial<TelegramSettings>,
      );
    } else {
      Object.assign(settings, dto);
    }

    const saved = await this.telegramSettingsRepo.save(settings);

    // Re-evaluate polling state
    if (saved.isEnabled) {
      this.startIntelligentPolling();
    } else {
      this.isPolling = false;
    }

    return saved;
  }

  /**
   * Setup Webhook (for Production)
   */
  async setupWebhook(
    url: string,
  ): Promise<{ success: boolean; message: string }> {
    const settings = await this.getSettings();
    if (!settings || !settings.botToken)
      throw new HttpException("Bot token required", 400);

    try {
      const webhookUrl = `${url}/api/telegram/webhook`;
      const response = await fetch(
        `https://api.telegram.org/bot${settings.botToken}/setWebhook?url=${webhookUrl}`,
      );
      const data = await response.json();

      if (data.ok) {
        this.isWebhookActive = true;
        this.isPolling = false; // Stop polling if webhook is successful
        return { success: true, message: "تم تفعيل الـ Webhook بنجاح" };
      }
      return { success: false, message: data.description };
    } catch (error) {
      return { success: false, message: error.message };
    }
  }

  /**
   * Intelligent Polling - Only runs when Webhook is not an option (like localhost)
   */
  async startIntelligentPolling() {
    if (this.isPolling || this.isWebhookActive) return;

    const settings = await this.getSettings();
    if (!settings || !settings.isEnabled || !settings.botToken) return;

    // Check if we already have a webhook set up on Telegram side
    try {
      const infoRes = await fetch(
        `https://api.telegram.org/bot${settings.botToken}/getWebhookInfo`,
      );
      const info = await infoRes.json();
      if (info.ok && info.result.url) {
        // Validate the webhook is actually working
        const pendingCount = info.result.pending_update_count || 0;
        const lastErrorDate = info.result.last_error_date;
        const lastErrorMessage = info.result.last_error_message;

        // If webhook has recent errors or many pending updates, it's likely broken
        const now = Math.floor(Date.now() / 1000);
        const errorIsRecent = lastErrorDate && (now - lastErrorDate) < 300; // Error in last 5 minutes

        if (errorIsRecent || pendingCount > 5) {
          console.warn(
            `[Telegram] Webhook appears broken (pending=${pendingCount}, lastError="${lastErrorMessage}"). Removing webhook and switching to polling...`,
          );
          // Delete the broken webhook so we can poll instead
          try {
            await fetch(
              `https://api.telegram.org/bot${settings.botToken}/deleteWebhook`,
            );
            console.log("[Telegram] Broken webhook removed successfully.");
          } catch (delErr) {
            console.error("[Telegram] Failed to delete broken webhook:", delErr.message);
          }
        } else {
          console.log("[Telegram] Webhook is active:", info.result.url);
          this.isWebhookActive = true;
          return; // Don't poll if webhook is healthy
        }
      }
    } catch (e) {
      console.error("[Telegram] Failed to check webhook status");
    }

    this.isPolling = true;
    console.log("[Telegram] Starting Polling (Dev Mode)...");

    const poll = async () => {
      if (!this.isPolling) return;

      try {
        const s = await this.getSettings();
        if (!s || !s.isEnabled) {
          this.isPolling = false;
          return;
        }

        const res = await fetch(
          `https://api.telegram.org/bot${s.botToken}/getUpdates?offset=${this.lastUpdateId + 1}&timeout=20`,
        );
        const data = await res.json();

        if (data.ok && data.result.length > 0) {
          for (const update of data.result) {
            this.lastUpdateId = update.update_id;
            await this.handleUpdate(update);
          }
        }
      } catch (err) {
        await new Promise((r) => setTimeout(r, 5000));
      }

      if (this.isPolling) setTimeout(poll, 500);
    };

    poll();
  }

  /**
   * Process incoming Telegram updates (Used by both Webhook and Polling)
   */
  async handleUpdate(update: any) {
    console.log(`[Telegram] handleUpdate called. Has callback_query: ${!!update?.callback_query}, update_id: ${update?.update_id}`);
    if (update.callback_query) {
      return await this.handleCallbackQuery(update.callback_query);
    }
    return { ok: true };
  }

  private async handleCallbackQuery(callback: any) {
    const { id, data, message, from } = callback;
    console.log(`[Telegram] handleCallbackQuery: data="${data}", from=${from?.first_name}, callback_id=${id}`);
    const settings = await this.getSettings();
    if (!settings || !settings.botToken) {
      console.error("[Telegram] handleCallbackQuery: No settings or bot token found!");
      return;
    }

    if (data.startsWith("approve_") || data.startsWith("reject_")) {
      const action = data.split("_")[0];
      const requestId = parseInt(data.split("_")[1]);

      // Answer Callback
      await fetch(
        `https://api.telegram.org/bot${settings.botToken}/answerCallbackQuery`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            callback_query_id: id,
            text: "جاري التنفيذ...",
          }),
        },
      );

      // Process System Action - find Super Admin dynamically
      let admin = await this.usersService.findByEmail("admin@q1key.com");
      if (!admin) {
        // Fallback: find any Super Admin user (roleId 1)
        console.warn("[Telegram] admin@q1key.com not found, searching for any Super Admin...");
        try {
          admin = await this.telegramSettingsRepo.manager.findOne(User, {
            where: { roleId: 1 },
            relations: ["role", "institution", "branch"],
          });
        } catch (e) {
          console.error("[Telegram] Failed to find Super Admin:", e.message);
        }
      }

      if (!admin) {
        console.error("[Telegram] No Super Admin found! Cannot process request from Telegram.");
        // Update Telegram message to show failure
        await fetch(
          `https://api.telegram.org/bot${settings.botToken}/editMessageText`,
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              chat_id: message.chat.id,
              message_id: message.message_id,
              text:
                message.text +
                `\n\n<b>⚠️ خطأ: لم يتم العثور على مسؤول النظام</b>`,
              parse_mode: "HTML",
              reply_markup: { inline_keyboard: [] },
            }),
          },
        );
        return;
      }

      try {
        await this.subscriptionsService.processRequest(
          requestId,
          {
            status: action === "approve" ? "Approved" : "Rejected",
            adminNotes: `Telegram action by ${from.first_name}`,
          },
          admin,
        );

        // Update Telegram UI
        const statusText =
          action === "approve" ? "✅ تمت الموافقة" : "❌ تم الرفض";
        await fetch(
          `https://api.telegram.org/bot${settings.botToken}/editMessageText`,
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              chat_id: message.chat.id,
              message_id: message.message_id,
              text:
                message.text +
                `\n\n<b>${statusText}</b>\n👤 بواسطة: ${from.first_name}`,
              parse_mode: "HTML",
              reply_markup: { inline_keyboard: [] },
            }),
          },
        );
      } catch (e) {
        console.error("[Telegram] Process Error:", e.message);
        // Update Telegram message to show the error
        const errorMsg = e.message || "خطأ غير معروف";
        await fetch(
          `https://api.telegram.org/bot${settings.botToken}/editMessageText`,
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              chat_id: message.chat.id,
              message_id: message.message_id,
              text:
                message.text +
                `\n\n<b>⚠️ فشل التنفيذ:</b> ${errorMsg}`,
              parse_mode: "HTML",
              reply_markup: { inline_keyboard: [] },
            }),
          },
        );
      }
    }
  }

  /**
   * Send formatted notification
   */
  async sendNewRequestNotification(requestData: any): Promise<boolean> {
    const settings = await this.getSettings();
    if (
      !settings ||
      !settings.isEnabled ||
      !settings.botToken ||
      !settings.chatId
    )
      return false;

    if (requestData.requestType === "renewal" && !settings.notifyRenewals) {
      console.log(
        `[Telegram] Skipped renewal notification (notifyRenewals is disabled). requestId=${requestData.requestId}`,
      );
      return false;
    }
    if (
      (requestData.requestType === "new_institution" ||
        requestData.requestType === "new_branch") &&
      !settings.notifyNewRequests
    ) {
      console.log(
        `[Telegram] Skipped new request notification (notifyNewRequests is disabled). requestId=${requestData.requestId}`,
      );
      return false;
    }

    const escape = (t: any) =>
      String(t || "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
    const emoji = requestData.requestType === "renewal" ? "🔄" : "🆕";
    const title =
      requestData.requestType === "renewal"
        ? "طلب تجديد اشتراك"
        : requestData.requestType === "new_institution"
          ? "طلب تسجيل مؤسسة"
          : "طلب فرع جديد";

    let message = `<b>${emoji} ${title}</b>\n`;
    message += `━━━━━━━━━━━━━━━━━\n`;
    message += `📋 <b>رقم الطلب:</b> #${requestData.requestId}\n`;
    message += `🏢 <b>الجهة:</b> ${escape(requestData.entityName)}\n`;

    if (requestData.parentInstitution) {
      message += `🏠 <b>المؤسسة الأم:</b> ${escape(requestData.parentInstitution)}\n`;
    }

    if (requestData.taxId) {
      message += `🆔 <b>السجل التجاري:</b> <code>${escape(requestData.taxId)}</code>\n`;
    }
    if (requestData.entityEmail) {
      message += `📧 <b>بريد الجهة:</b> ${escape(requestData.entityEmail)}\n`;
    }
    if (requestData.entityPhone) {
      message += `📞 <b>هاتف الجهة:</b> <code>${escape(requestData.entityPhone)}</code>\n`;
    }

    message += `━━━━━━━━━━━━━━━━━\n`;

    // Manager/Contact Info
    if (
      requestData.adminName ||
      requestData.email ||
      requestData.phoneNumber ||
      requestData.adminEmail ||
      requestData.adminPhone
    ) {
      const aName = requestData.adminName;
      const aEmail = requestData.adminEmail || requestData.email;
      const aPhone = requestData.adminPhone || requestData.phoneNumber;

      message += `👤 <b>بيانات المسؤول:</b>\n`;
      if (aName) message += `   ▫️ الاسم: ${escape(aName)}\n`;
      if (aPhone) message += `   ▫️ الجوال: <code>${escape(aPhone)}</code>\n`;
      if (aEmail) message += `   ▫️ البريد: ${escape(aEmail)}\n`;
      message += `━━━━━━━━━━━━━━━━━\n`;
    }

    // Subscription Info
    message += `💎 <b>تفاصيل الاشتراك:</b>\n`;
    if (requestData.planName)
      message += `   ▫️ الباقة: ${escape(requestData.planName)}\n`;
    if (requestData.duration)
      message += `   ▫️ المدة: ${requestData.duration} شهر\n`;
    if (requestData.maxUsers)
      message += `   ▫️ المستخدمين: ${requestData.maxUsers}\n`;
    message += `   ▫️ المبلغ: <b>${requestData.amount ? requestData.amount.toLocaleString("ar-SA") : "0"}</b> ريال\n`;

    if (requestData.newExpiration) {
      message += `   ▫️ الانتهاء الجديد: ${escape(requestData.newExpiration)}\n`;
    }

    message += `━━━━━━━━━━━━━━━━━\n`;

    if (requestData.customerNotes) {
      message += `📝 <b>ملاحظات العميل:</b>\n${escape(requestData.customerNotes)}\n`;
      message += `━━━━━━━━━━━━━━━━━\n`;
    }

    const inlineKeyboard: any[][] = [];

    // Add action buttons only if enabled in settings
    if (settings.allowActionButtons) {
      inlineKeyboard.push([
        {
          text: "✅ موافقة",
          callback_data: `approve_${requestData.requestId}`,
        },
        { text: "❌ رفض", callback_data: `reject_${requestData.requestId}` },
      ]);
    }

    const frontendUrl = process.env.FRONTEND_URL || "http://localhost:8081";
    if (
      frontendUrl &&
      !frontendUrl.includes("localhost") &&
      !frontendUrl.includes("127.0.0.1")
    ) {
      inlineKeyboard.push([
        {
          text: "📋 عرض التفاصيل",
          url: `${frontendUrl}/pages/requests.html?id=${requestData.requestId}`,
        },
      ]);
    }

    const result = await this.sendTelegramMessage(
      settings.botToken,
      settings.chatId,
      message,
      inlineKeyboard.length > 0 ? inlineKeyboard : undefined,
    );
    return result.success;
  }

  async sendTelegramMessage(
    botToken: string,
    chatId: string,
    message: string,
    inlineKeyboard?: any[][],
  ): Promise<{ success: boolean; error?: string }> {
    try {
      const res = await fetch(
        `https://api.telegram.org/bot${botToken}/sendMessage`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            chat_id: chatId,
            text: message,
            parse_mode: "HTML",
            reply_markup: inlineKeyboard
              ? { inline_keyboard: inlineKeyboard }
              : undefined,
          }),
        },
      );
      const data = await res.json();
      return { success: data.ok, error: data.description };
    } catch (e) {
      return { success: false, error: e.message };
    }
  }

  async testConnection(): Promise<{ success: boolean; message: string }> {
    const settings = await this.getSettings();
    if (!settings || !settings.botToken || !settings.chatId)
      throw new HttpException("Settings missing", 400);

    const res = await this.sendTelegramMessage(
      settings.botToken,
      settings.chatId,
      "🔔 اختبار الاتصال بنظام Q1KEY",
    );

    // Update settings with test result
    settings.lastTestAt = new Date();
    settings.lastTestSuccess = res.success;
    settings.lastTestError = res.success ? null : res.error || "Unknown error";

    await this.telegramSettingsRepo.save(settings);

    return {
      success: res.success,
      message: res.success ? "تم بنجاح" : res.error || "فشل",
    };
  }

  /**
   * Force delete webhook and restart polling
   * Useful when webhook URL is stale/broken
   */
  async forcePolling(): Promise<{ success: boolean; message: string }> {
    const settings = await this.getSettings();
    if (!settings || !settings.botToken) {
      throw new HttpException("Bot token required", 400);
    }

    try {
      // Delete any existing webhook
      const res = await fetch(
        `https://api.telegram.org/bot${settings.botToken}/deleteWebhook`,
      );
      const data = await res.json();
      console.log("[Telegram] deleteWebhook result:", data);

      // Reset state and start polling
      this.isWebhookActive = false;
      this.isPolling = false;
      await this.startIntelligentPolling();

      return {
        success: true,
        message: "تم حذف الـ Webhook وتشغيل الاستقصاء (Polling) بنجاح",
      };
    } catch (e) {
      return { success: false, message: e.message };
    }
  }

  /**
   * Get diagnostic info about webhook/polling state
   */
  async getDiagnostics(): Promise<any> {
    const settings = await this.getSettings();
    if (!settings || !settings.botToken) {
      return { error: "No bot token configured" };
    }

    let webhookInfo: any = null;
    try {
      const res = await fetch(
        `https://api.telegram.org/bot${settings.botToken}/getWebhookInfo`,
      );
      webhookInfo = await res.json();
    } catch (e) {
      webhookInfo = { error: e.message };
    }

    // Check admin user existence
    let adminExists = false;
    let adminEmail: string | null = null;
    try {
      const admin = await this.usersService.findByEmail("admin@q1key.com");
      if (admin) {
        adminExists = true;
        adminEmail = "admin@q1key.com";
      } else {
        const fallback = await this.telegramSettingsRepo.manager.findOne(User, {
          where: { roleId: 1 },
        });
        adminExists = !!fallback;
        adminEmail = fallback?.email || null;
      }
    } catch (e) {
      // ignore
    }

    return {
      isPolling: this.isPolling,
      isWebhookActive: this.isWebhookActive,
      lastUpdateId: this.lastUpdateId,
      webhookInfo: webhookInfo?.result || webhookInfo,
      adminUser: { exists: adminExists, email: adminEmail },
      settings: {
        isEnabled: settings.isEnabled,
        hasBotToken: !!settings.botToken,
        hasChatId: !!settings.chatId,
        allowActionButtons: settings.allowActionButtons,
        notifyNewRequests: settings.notifyNewRequests,
        notifyRenewals: settings.notifyRenewals,
      },
    };
  }
}
