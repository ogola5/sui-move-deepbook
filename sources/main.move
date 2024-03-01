#[allow(lint(self_transfer))]



module microfinance::microfinance {
  use sui::object::{Self, UID};
  use sui::coin::{Self, Coin};
  use sui::balance::{Self, Balance};
  use sui::transfer;
  use sui::sui::SUI;
  use sui::tx_context::{Self, TxContext};

  // Errors
  const E_INSUFFICIENT_FUNDS: u64 = 1;
  const E_LOAN_ALREADY_EXISTS: u64 = 2;
  const E_NO_LOAN_FOUND: u64 = 3;

  // Structs
  struct SavingsAccount has key, store {
    id: UID,
    owner: address,
    balance: Balance<SUI>,
  }

  struct Loan has key, store {
    id: UID,
    borrower: address,
    amount: u64,
    repaid: bool,
  }

  // Initialize a new Savings Account
  public fun create_savings_account(ctx: &mut TxContext) {
    let account = SavingsAccount {
      id: object::new(ctx),
      owner: tx_context::sender(ctx),
      balance: balance::zero(),
    };
    transfer::share_object(account);
  }

  // Deposit funds into Savings Account
  public fun deposit(account: &mut SavingsAccount, amount: Coin<SUI>, ctx: &mut TxContext) {
    let deposit_balance = sui::coin::into_balance(amount); 
    balance::join(&mut account.balance, deposit_balance);
  }

  // Borrow funds from the microfinance
  public fun borrow(ctx: &mut TxContext, amount: u64) {
    let loan = Loan {
      id: object::new(ctx),
      borrower: tx_context::sender(ctx),
      amount,
      repaid: false,
    };
    transfer::share_object(loan);
  }

  // Repay the loan
  public fun repay_loan(loan: &mut Loan, amount: &Coin<SUI>, ctx: &mut TxContext) {
    assert!(coin::value(amount) >= loan.amount, E_INSUFFICIENT_FUNDS);
    loan.repaid = true;
    // Logic to handle the repayment process, e.g., transferring funds back
  }

  // Utility Functions
  public fun check_balance(account: &SavingsAccount): u64 {
    balance::value(&account.balance)
  }
}
