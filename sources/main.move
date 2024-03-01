
#[allow(lint(self_transfer))]

/// Microfinance module for managing savings accounts, loans, and lending pools.
module microfinance::microfinance {
    // Import necessary modules and types from the SUI framework and standard library.
    use sui::object::{Self, UID};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::transfer;
    use sui::sui::SUI;
    use std::vector;
    use sui::tx_context::{Self, TxContext};

    // Define error codes for common operations.
    const E_INSUFFICIENT_FUNDS: u64 = 1; // Insufficient funds for a loan or repayment.
    const E_LOAN_ALREADY_EXISTS: u64 = 2; // A loan already exists for the borrower.
    const E_NO_LOAN_FOUND: u64 = 3; // No loan found for the specified ID.

    // Define structs for various entities in the microfinance system.

    /// Represents a borrower's account, including their balance and active loans.
    struct BorrowerAccount has key, store {
        id: UID, // Unique identifier for the account.
        owner: address, // Address of the account owner.
        balance: Balance<SUI>, // Current balance of the account.
        active_loans: vector<UID>, // IDs of active loans.
    }

    /// Represents a lender's account, including their balance.
    struct LenderAccount has key, store {
        id: UID, // Unique identifier for the account.
        owner: address, // Address of the account owner.
        balance: Balance<SUI>, // Current balance of the account.
    }

    /// Represents the lending pool, including total funds and outstanding loans.
    struct LendingPool has key, store {
        id: UID, // Unique identifier for the lending pool.
        total_funds: Balance<SUI>, // Total funds available in the lending pool.
        loans_outstanding: vector<UID>, // IDs of outstanding loans.
    }

    /// Represents a savings account, including the owner and balance.
    struct SavingsAccount has key, store {
        id: UID, // Unique identifier for the savings account.
        owner: address, // Address of the account owner.
        balance: Balance<SUI>, // Current balance of the savings account.
    }

    /// Represents a loan, including the borrower, amount, and repayment status.
    struct Loan has key, store {
        id: UID, // Unique identifier for the loan.
        borrower: address, // Address of the borrower.
        amount: u64, // Amount of the loan.
        repaid: bool, // Whether the loan has been repaid.
    }

    // Functions for creating and managing accounts and loans.

    /// Creates a new borrower account with an initial balance of zero.
    public fun create_borrower_account(ctx: &mut TxContext) {
        let account = BorrowerAccount {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            balance: balance::zero(),
            active_loans: vector::empty(),
        };
        transfer::share_object(account);
    }

    /// Creates a new lender account with an initial balance of zero.
    public fun create_lender_account(ctx: &mut TxContext) {
        let account = LenderAccount {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            balance: balance::zero(),
        };
        transfer::share_object(account);
    }

    /// Initializes a new lending pool with a specified initial amount.
    public fun initialize_lending_pool(ctx: &mut TxContext, initial_amount: u64) {
        let pool = LendingPool {
            id: object::new(ctx),
            total_funds: balance::zero(),
            loans_outstanding: vector::empty(),
        };
        transfer::share_object(pool);
    }

    /// Deposits funds into the lending pool from a lender's account.
    public fun deposit_to_pool(lender_account: &mut LenderAccount, amount: Coin<SUI>, pool: &mut LendingPool, ctx: &mut TxContext) {
        let deposit_balance = sui::coin::into_balance(amount);
        balance::join(&mut pool.total_funds, deposit_balance);
        
    }

    /// Initializes a new savings account with an initial balance of zero.
    public fun create_savings_account(ctx: &mut TxContext) {
        let account = SavingsAccount {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            balance: balance::zero(),
        };
        transfer::share_object(account);
    }

    /// Deposits funds into a savings account.
    public fun deposit(account: &mut SavingsAccount, amount: Coin<SUI>, ctx: &mut TxContext) {
        let deposit_balance = sui::coin::into_balance(amount); 
        balance::join(&mut account.balance, deposit_balance);
    }

    /// Borrows funds from the microfinance system.
    public fun borrow(ctx: &mut TxContext, amount: u64) {
        let loan = Loan {
            id: object::new(ctx),
            borrower: tx_context::sender(ctx),
            amount,
            repaid: false,
        };
        transfer::share_object(loan);
    }

    /// Repays a loan.
    public fun repay_loan(loan: &mut Loan, amount: &Coin<SUI>, ctx: &mut TxContext) {
        assert!(coin::value(amount) >= loan.amount, E_INSUFFICIENT_FUNDS);
        loan.repaid = true;
        
    }

    /// Checks the balance of a savings account.
    public fun check_balance(account: &SavingsAccount): u64 {
        balance::value(&account.balance)
    }
}

