-- Seed the production homepage with the current Q1KEY landing-page content.
-- Safe to run more than once: homepage settings and public plans are upserted.

INSERT INTO homepage_settings (
  id,
  hero_title_ar,
  hero_title_en,
  hero_subtitle_ar,
  hero_subtitle_en,
  hero_image_url,
  hero_video_url,
  hero_background_type,
  login_button_text_ar,
  login_button_text_en,
  login_button_visible,
  register_button_text_ar,
  register_button_text_en,
  register_button_visible,
  features_section_visible,
  features_title_ar,
  features_title_en,
  features_data,
  plans_section_visible,
  plans_title_ar,
  plans_title_en,
  about_section_visible,
  about_title_ar,
  about_title_en,
  about_content_ar,
  about_content_en,
  about_image_url,
  contact_section_visible,
  contact_title_ar,
  contact_title_en,
  sections_order,
  footer_text_ar,
  footer_text_en,
  social_links,
  support_email,
  quick_links,
  whatsapp_number,
  created_at,
  updated_at
)
VALUES (
  1,
  'لن تنسى أي قسط بعد اليوم، ووداعاً للتعثرات',
  'Never miss an installment again — say goodbye to defaults',
  'منصة متخصصة لمتابعة البيع والأنشطة والأجل والتحصيل للمؤسسات والمنشآت الصغيرة بطريقة سهلة وذكية وآمنة وسرية عالية لمعلومات العملاء.',
  'A specialized platform for tracking sales, activities, credit, and collections for institutions and small businesses — simple, smart, secure, and confidential.',
  NULL,
  NULL,
  'gradient',
  'تسجيل الدخول',
  'Login',
  true,
  'اشترك الآن',
  'Subscribe Now',
  true,
  true,
  'لماذا تختار Q1KEY؟',
  'Why choose Q1KEY?',
  $$[
    {
      "icon": "🔔",
      "iconAr": "🔔",
      "iconEn": "🔔",
      "titleAr": "تنبيهات ذكية",
      "titleEn": "Smart Alerts",
      "descAr": "تذكير بالأقساط ومواعيدها عبر إشعارات تلقائية.",
      "descEn": "Automatic reminders for installments and due dates."
    },
    {
      "icon": "📊",
      "iconAr": "📊",
      "iconEn": "📊",
      "titleAr": "تقارير شاملة",
      "titleEn": "Comprehensive Reports",
      "descAr": "تقارير تفصيلية تساعدك على اتخاذ قرارات ذكية.",
      "descEn": "Detailed reports that help you make smarter decisions."
    },
    {
      "icon": "📄",
      "iconAr": "📄",
      "iconEn": "📄",
      "titleAr": "كشف حساب دوري",
      "titleEn": "Periodic Statements",
      "descAr": "أرسل كشف حساب للعميل بضغطة واحدة.",
      "descEn": "Send customer account statements with one click."
    },
    {
      "icon": "🛡️",
      "iconAr": "🛡️",
      "iconEn": "🛡️",
      "titleAr": "بيانات آمنة",
      "titleEn": "Secure Data",
      "descAr": "حماية عالية لبياناتك والتزام بأعلى معايير الأمان.",
      "descEn": "Strong data protection with high security standards."
    },
    {
      "icon": "✅",
      "iconAr": "✅",
      "iconEn": "✅",
      "titleAr": "سهل وبسيط",
      "titleEn": "Simple & Easy",
      "descAr": "واجهة سهلة وواضحة ومناسبة لجميع المستخدمين.",
      "descEn": "A clear and simple interface for every user."
    },
    {
      "icon": "☁️",
      "iconAr": "☁️",
      "iconEn": "☁️",
      "titleAr": "من أي مكان",
      "titleEn": "From Anywhere",
      "descAr": "ادخل على بياناتك من أي جهاز وفي أي وقت.",
      "descEn": "Access your data from any device at any time."
    },
    {
      "icon": "⚡",
      "iconAr": "⚡",
      "iconEn": "⚡",
      "titleAr": "سريع وموثوق",
      "titleEn": "Fast & Reliable",
      "descAr": "منصة سريعة ومستقرة تساعد فريقك على إنجاز العمل بثقة.",
      "descEn": "A fast and reliable platform that helps your team work confidently."
    },
    {
      "icon": "24",
      "iconAr": "24",
      "iconEn": "24",
      "titleAr": "دعم فني",
      "titleEn": "Technical Support",
      "descAr": "فريق دعم متاح لمساعدتك عند الحاجة.",
      "descEn": "A support team available whenever you need help."
    }
  ]$$,
  true,
  'باقات الاشتراك',
  'Subscription Plans',
  true,
  'من نحن',
  'About Q1KEY',
  'Q1KEY منصة تساعدك على إدارة الأنشطة والتحصيل ومنع التعثرات بكل يسر وسهولة.',
  'Q1KEY helps you manage activities, collections, and prevent defaults with clarity and ease.',
  NULL,
  true,
  'تواصل معنا',
  'Contact Us',
  '["hero","features","plans","about","contact"]',
  'جميع الحقوق محفوظة Q1KEY',
  'All rights reserved Q1KEY',
  '{}',
  'support@q1key.com',
  $$[
    {"textAr":"الرئيسية","textEn":"Home","url":"#hero","visible":true},
    {"textAr":"مناسب لـ","textEn":"Suitable For","url":"#suitable","visible":true},
    {"textAr":"كيف يعمل","textEn":"How It Works","url":"#how","visible":true},
    {"textAr":"المميزات","textEn":"Features","url":"#features","visible":true},
    {"textAr":"الاشتراكات","textEn":"Subscriptions","url":"#plans","visible":true},
    {"textAr":"تواصل معنا","textEn":"Contact","url":"#contact","visible":true}
  ]$$,
  '0534678464',
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  hero_title_ar = EXCLUDED.hero_title_ar,
  hero_title_en = EXCLUDED.hero_title_en,
  hero_subtitle_ar = EXCLUDED.hero_subtitle_ar,
  hero_subtitle_en = EXCLUDED.hero_subtitle_en,
  hero_image_url = EXCLUDED.hero_image_url,
  hero_video_url = EXCLUDED.hero_video_url,
  hero_background_type = EXCLUDED.hero_background_type,
  login_button_text_ar = EXCLUDED.login_button_text_ar,
  login_button_text_en = EXCLUDED.login_button_text_en,
  login_button_visible = EXCLUDED.login_button_visible,
  register_button_text_ar = EXCLUDED.register_button_text_ar,
  register_button_text_en = EXCLUDED.register_button_text_en,
  register_button_visible = EXCLUDED.register_button_visible,
  features_section_visible = EXCLUDED.features_section_visible,
  features_title_ar = EXCLUDED.features_title_ar,
  features_title_en = EXCLUDED.features_title_en,
  features_data = EXCLUDED.features_data,
  plans_section_visible = EXCLUDED.plans_section_visible,
  plans_title_ar = EXCLUDED.plans_title_ar,
  plans_title_en = EXCLUDED.plans_title_en,
  about_section_visible = EXCLUDED.about_section_visible,
  about_title_ar = EXCLUDED.about_title_ar,
  about_title_en = EXCLUDED.about_title_en,
  about_content_ar = EXCLUDED.about_content_ar,
  about_content_en = EXCLUDED.about_content_en,
  about_image_url = EXCLUDED.about_image_url,
  contact_section_visible = EXCLUDED.contact_section_visible,
  contact_title_ar = EXCLUDED.contact_title_ar,
  contact_title_en = EXCLUDED.contact_title_en,
  sections_order = EXCLUDED.sections_order,
  footer_text_ar = EXCLUDED.footer_text_ar,
  footer_text_en = EXCLUDED.footer_text_en,
  social_links = EXCLUDED.social_links,
  support_email = EXCLUDED.support_email,
  quick_links = EXCLUDED.quick_links,
  whatsapp_number = EXCLUDED.whatsapp_number,
  updated_at = NOW();

SELECT setval(
  pg_get_serial_sequence('homepage_settings', 'id'),
  GREATEST((SELECT COALESCE(MAX(id), 1) FROM homepage_settings), 1),
  true
);

INSERT INTO subscription_plans (
  id,
  name,
  name_en,
  duration_months,
  price,
  is_active,
  is_free_trial,
  sort_order,
  description,
  created_at,
  updated_at
)
VALUES
  (1, 'شهر واحد', '1 Month', 1, 100, true, false, 1, NULL, NOW(), NOW()),
  (2, '3 أشهر', '3 Months', 3, 250, true, false, 2, NULL, NOW(), NOW()),
  (3, '6 أشهر', '6 Months', 6, 450, true, false, 3, NULL, NOW(), NOW()),
  (4, 'سنة كاملة', '1 Year', 12, 800, true, false, 4, NULL, NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  name_en = EXCLUDED.name_en,
  duration_months = EXCLUDED.duration_months,
  price = EXCLUDED.price,
  is_active = true,
  is_free_trial = false,
  sort_order = EXCLUDED.sort_order,
  updated_at = NOW();

UPDATE subscription_plans
SET is_active = false,
    updated_at = NOW()
WHERE id NOT IN (1, 2, 3, 4);

SELECT setval(
  pg_get_serial_sequence('subscription_plans', 'id'),
  GREATEST((SELECT COALESCE(MAX(id), 1) FROM subscription_plans), 1),
  true
);
