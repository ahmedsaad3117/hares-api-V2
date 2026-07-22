import { BadRequestException } from "@nestjs/common";
import { Loan, LoanStatus } from "../../entities/loan.entity";
import { Installment } from "../../entities/installment.entity";
import { CashBoxTransaction } from "../../entities/cash-box-transaction.entity";
import { LoansService } from "./loans.service";

describe("LoansService soft delete", () => {
  const manager = {
    decrement: jest.fn(),
    delete: jest.fn(),
    update: jest.fn(),
    save: jest.fn(),
  };

  const dataSource = {
    transaction: jest.fn(async (callback: any) => callback(manager)),
  };

  const cashBoxService = {
    getOrCreateBranchCashBox: jest.fn(async () => ({ balance: 500 })),
    getOrCreateInstitutionCashBox: jest.fn(),
  };

  const service = new LoansService(
    {} as any,
    {} as any,
    {} as any,
    {} as any,
    {} as any,
    dataSource as any,
    {} as any,
    cashBoxService as any,
  );

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("keeps the loan row with Deleted status while removing active obligations", async () => {
    jest.spyOn(service, "findOne").mockResolvedValue({
      loanId: 62,
      customerId: 10,
      branchId: 4,
      productId: 2,
      principalAmount: 1200,
      profitAmount: 100,
      paidAmount: 0,
      status: LoanStatus.ACTIVE,
      createdAt: new Date(),
      updatedAt: new Date(),
      dueDate: null,
      installments: [
        {
          id: 101,
          installmentNumber: 1,
          dueDate: new Date(),
          amount: 600,
          status: "Pending" as any,
          paymentDate: null,
        },
      ],
    });

    await service.remove(62);

    expect(manager.delete).toHaveBeenCalledWith(CashBoxTransaction, {
      installmentId: expect.anything(),
    });
    expect(manager.delete).toHaveBeenCalledWith(CashBoxTransaction, {
      loanId: 62,
    });
    expect(manager.delete).toHaveBeenCalledWith(Installment, { loanId: 62 });
    expect(manager.delete).not.toHaveBeenCalledWith(Loan, { loanId: 62 });
    expect(manager.update).toHaveBeenCalledWith(
      Loan,
      { loanId: 62 },
      { status: LoanStatus.DELETED },
    );
  });

  it("does not reverse balances twice when the loan is already deleted", async () => {
    jest.spyOn(service, "findOne").mockResolvedValue({
      loanId: 62,
      customerId: 10,
      branchId: 4,
      productId: 2,
      principalAmount: 1200,
      status: LoanStatus.DELETED,
      createdAt: new Date(),
      updatedAt: new Date(),
      dueDate: null,
    });

    await expect(service.remove(62)).rejects.toThrow(BadRequestException);
    expect(dataSource.transaction).not.toHaveBeenCalled();
  });
});
