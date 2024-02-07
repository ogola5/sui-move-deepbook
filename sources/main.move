/*
Disclaimer: Use of Unaudited Code for Educational Purposes Only
This code is provided strictly for educational purposes and has not undergone any formal security audit. 
It may contain errors, vulnerabilities, or other issues that could pose risks to the integrity of your system or data.

By using this code, you acknowledge and agree that:
    - No Warranty: The code is provided "as is" without any warranty of any kind, either express or implied. The entire risk as to the quality and performance of the code is with you.
    - Educational Use Only: This code is intended solely for educational and learning purposes. It is not intended for use in any mission-critical or production systems.
    - No Liability: In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the use or performance of this code.
    - Security Risks: The code may not have been tested for security vulnerabilities. It is your responsibility to conduct a thorough security review before using this code in any sensitive or production environment.
    - No Support: The authors of this code may not provide any support, assistance, or updates. You are using the code at your own risk and discretion.

Before using this code, it is recommended to consult with a qualified professional and perform a comprehensive security assessment. By proceeding to use this code, you agree to assume all associated risks and responsibilities.
*/

// #[lint_allow(self_transfer)]
// module dacade_deepbook::book {
//     use deepbook::clob_v2 as deepbook;
//     use deepbook::custodian_v2 as custodian;
//     use sui::sui::SUI;
//     use sui::tx_context::{TxContext, Self};
//     use sui::coin::{Coin, Self};
//     use sui::balance::{Self};
//     use sui::transfer::Self;
//     use sui::clock::Clock;

//     const FLOAT_SCALING: u64 = 1_000_000_000;


//     public fun new_pool<Base, Quote>(payment: &mut Coin<SUI>, ctx: &mut TxContext) {
//         let balance = coin::balance_mut(payment);
//         let fee = balance::split(balance, 100 * 1_000_000_000);
//         let coin = coin::from_balance(fee, ctx);

//         deepbook::create_pool<Base, Quote>(
//             1 * FLOAT_SCALING,
//             1,
//             coin,
//             ctx
//         );
//     }

//     public fun new_custodian_account(ctx: &mut TxContext) {
//         transfer::public_transfer(deepbook::create_account(ctx), tx_context::sender(ctx))
//     }

//     public fun make_base_deposit<Base, Quote>(pool: &mut deepbook::Pool<Base, Quote>, coin: Coin<Base>, account_cap: &custodian::AccountCap) {
//         deepbook::deposit_base(pool, coin, account_cap)
//     }

//     public fun make_quote_deposit<Base, Quote>(pool: &mut deepbook::Pool<Base, Quote>, coin: Coin<Quote>, account_cap: &custodian::AccountCap) {
//         deepbook::deposit_quote(pool, coin, account_cap)
//     }

//     public fun withdraw_base<BaseAsset, QuoteAsset>(
//         pool: &mut deepbook::Pool<BaseAsset, QuoteAsset>,
//         quantity: u64,
//         account_cap: &custodian::AccountCap,
//         ctx: &mut TxContext
//     ) {
//         let base = deepbook::withdraw_base(pool, quantity, account_cap, ctx);
//         transfer::public_transfer(base, tx_context::sender(ctx));
//     }

//     public fun withdraw_quote<BaseAsset, QuoteAsset>(
//         pool: &mut deepbook::Pool<BaseAsset, QuoteAsset>,
//         quantity: u64,
//         account_cap: &custodian::AccountCap,
//         ctx: &mut TxContext
//     ) {
//         let quote = deepbook::withdraw_quote(pool, quantity, account_cap, ctx);
//         transfer::public_transfer(quote, tx_context::sender(ctx));
//     }

//     public fun place_limit_order<Base, Quote>(
//         pool: &mut deepbook::Pool<Base, Quote>,
//         client_order_id: u64,
//         price: u64, 
//         quantity: u64, 
//         self_matching_prevention: u8,
//         is_bid: bool,
//         expire_timestamp: u64,
//         restriction: u8,
//         clock: &Clock,
//         account_cap: &custodian::AccountCap,
//         ctx: &mut TxContext
//     ): (u64, u64, bool, u64) {
//         deepbook::place_limit_order(
//             pool, 
//             client_order_id, 
//             price, 
//             quantity, 
//             self_matching_prevention, 
//             is_bid, 
//             expire_timestamp, 
//             restriction, 
//             clock, 
//             account_cap, 
//             ctx
//         )
//     }

//     public fun place_base_market_order<Base, Quote>(
//         pool: &mut deepbook::Pool<Base, Quote>,
//         account_cap: &custodian::AccountCap,
//         base_coin: Coin<Base>,
//         client_order_id: u64,
//         is_bid: bool,
//         clock: &Clock,
//         ctx: &mut TxContext,
//     ) {
//         let quote_coin = coin::zero<Quote>(ctx);
//         let quantity = coin::value(&base_coin);
//         place_market_order(
//             pool,
//             account_cap,
//             client_order_id,
//             quantity,
//             is_bid,
//             base_coin,
//             quote_coin,
//             clock,
//             ctx
//         )
//     }

//     public fun place_quote_market_order<Base, Quote>(
//         pool: &mut deepbook::Pool<Base, Quote>,
//         account_cap: &custodian::AccountCap,
//         quote_coin: Coin<Quote>,
//         client_order_id: u64,
//         is_bid: bool,
//         clock: &Clock,
//         ctx: &mut TxContext,
//     ) {
//         let base_coin = coin::zero<Base>(ctx);
//         let quantity = coin::value(&quote_coin);
//         place_market_order(
//             pool,
//             account_cap,
//             client_order_id,
//             quantity,
//             is_bid,
//             base_coin,
//             quote_coin,
//             clock,
//             ctx
//         )
//     }

//     fun place_market_order<Base, Quote>(
//         pool: &mut deepbook::Pool<Base, Quote>,
//         account_cap: &custodian::AccountCap,
//         client_order_id: u64,
//         quantity: u64,
//         is_bid: bool,
//         base_coin: Coin<Base>,
//         quote_coin: Coin<Quote>,
//         clock: &Clock, // @0x6 hardcoded id of the Clock object
//         ctx: &mut TxContext,
//     ) {
//         let (base, quote) = deepbook::place_market_order(
//             pool, 
//             account_cap, 
//             client_order_id, 
//             quantity, 
//             is_bid, 
//             base_coin, 
//             quote_coin, 
//             clock, 
//             ctx
//         );
//         transfer::public_transfer(base, tx_context::sender(ctx));
//         transfer::public_transfer(quote, tx_context::sender(ctx));
//     }

//     public fun swap_exact_base_for_quote<Base, Quote>(
//         pool: &mut deepbook::Pool<Base, Quote>,
//         client_order_id: u64,
//         account_cap: &custodian::AccountCap,
//         quantity: u64,
//         base_coin: Coin<Base>,
//         clock: &Clock,
//         ctx: &mut TxContext
//     ) {
//         let quote_coin = coin::zero<Quote>(ctx);
//         let (base, quote, _) = deepbook::swap_exact_base_for_quote(
//             pool,
//             client_order_id,
//             account_cap,
//             quantity,
//             base_coin,
//             quote_coin,
//             clock,
//             ctx
//         );
//         transfer::public_transfer(base, tx_context::sender(ctx));
//         transfer::public_transfer(quote, tx_context::sender(ctx));
//     }

//     public fun swap_exact_quote_for_base<Base, Quote>(
//         pool: &mut deepbook::Pool<Base, Quote>,
//         account_cap: &custodian::AccountCap,
//         quote_coin: Coin<Quote>,
//         client_order_id: u64,
//         quantity: u64,
//         clock: &Clock,
//         ctx: &mut TxContext,
//     ) {
//         let (base, quote, _) = deepbook::swap_exact_quote_for_base(
//             pool,
//             client_order_id,
//             account_cap,
//             quantity,
//             clock,
//             quote_coin,
//             ctx
//         );
//         transfer::public_transfer(base, tx_context::sender(ctx));
//         transfer::public_transfer(quote, tx_context::sender(ctx));
//     }
// }

#[lint_allow(self_transfer)]
module microfinance::savings_lending {
    use sui::tx_context::{TxContext, Self};
    use sui::coin::{Coin, Self};
    use sui::balance::{Self, Balance};
    use sui::transfer::Self;
    use sui::object::UID;
    use deepbook::clob_v2;
    use deepbook::custodian_v2;


    // Constants and Structs
    const MIN_SAVINGS: u64 = 1_000;  // Minimum savings amount
    const MIN_LOAN: u64 = 5_000;     // Minimum loan amount
    const INTEREST_RATE: u64 = 5;    // Annual interest rate in percentage

    struct UserAccount has key, store {
    id: UID,                      // Unique identifier for the user account
    savings_balance: Balance<SUI>,// Balance for savings
    loan_balance: Balance<SUI>,   // Balance for loans
    loan_due_date: u64,           // Timestamp for when the loan is due
    credit_score: u64,            // User's credit score, could affect loan terms
    total_saved: u64,             // Total amount saved over time
    total_borrowed: u64,          // Total amount borrowed over time
    active_loan_id: UID,          // ID of any active loan
    transaction_history: Vector<TransactionRecord>, // History of transactions
    last_interest_calculation: u64, // Timestamp of last interest calculation
    // Additional fields as needed
}

    struct LoanRequest has key, store {
        id: UID,                           // Unique identifier for the loan request
        borrower_id: UID,                  // Link to the borrower's UserAccount
        amount: u64,                       // Amount requested for the loan
        requested_on: u64,                 // Timestamp when the loan was requested
        due_by: u64,                       // Timestamp for when the loan is due
        interest_rate: u64,                // Interest rate applicable to this loan
        status: LoanStatus,                // Current status of the loan (e.g., pending, approved, rejected)
        purpose: String,                   // Purpose of the loan
        repayment_history: Vector<RepaymentRecord>, // History of repayments for this loan
        credit_score_at_request: u64,      // Borrower's credit score at the time of request
        collateral_id: Option<UID>,        // Optional: ID of any collateral provided
        // Additional fields as needed
    }

    enum LoanStatus {
        Pending,
        Approved,
        Rejected,
        Repaid,
        Defaulted,
        // Additional statuses as necessary
    }
    struct RepaymentRecord has key, store {
        id: UID,                         // Unique identifier for the repayment record
        loan_request_id: UID,            // Link to the associated LoanRequest
        payment_date: u64,               // Timestamp of the repayment
        amount_paid: u64,                // Amount that was paid
        remaining_balance: u64,          // Remaining balance after this repayment
        interest_paid: u64,              // Amount of payment that went towards interest
        principal_paid: u64,             // Amount of payment that went towards the principal
        late_fee_applied: u64,           // Late fee amount (if any) applied to this repayment
        payer_id: UID,                   // ID of the UserAccount that made the repayment
        repayment_method: String,        // Method of repayment (e.g., direct transfer, round-up)
        // Additional fields as needed
    }


    public fun create_user_account(ctx: &mut TxContext): UID {
        // Generate a new unique identifier for the user account
        let user_account_id = UID::new();

        // Initialize the UserAccount struct with default values
        let new_account = UserAccount {
            id: user_account_id,
            savings_balance: Balance::zero::<SUI>(),  // Set initial savings balance to zero
            loan_balance: Balance::zero::<SUI>(),     // Set initial loan balance to zero
            loan_due_date: 0,                         // Default value, to be set when a loan is taken
            credit_score: 0,                          // Default credit score, can be updated later
            total_saved: 0,                           // Initially, no savings
            total_borrowed: 0,                        // Initially, no loans
            active_loan_id: None,                     // No active loans initially
            transaction_history: Vector::empty(),     // Initialize empty transaction history
            last_interest_calculation: 0,             // Timestamp to be updated upon interest calculation
        };

        // Store the new account in Sui storage
        // Note: Add logic to save the account struct in the blockchain's storage

        // Return the unique identifier of the new user account
        user_account_id
    }
    public fun deposit_to_savings(user_id: UID, amount: u64, ctx: &mut TxContext) {
        // Validate the deposit amount
        assert!(amount >= MIN_SAVINGS, EDepositAmountTooLow);

        // Retrieve the user's account from storage
        let account = get_account(user_id);
        
        // Assert that the account exists
        assert!(exists<UserAccount>(user_id), EAccountNotFound);

        // Update the savings balance
        let user_account = borrow_global_mut<UserAccount>(user_id);
        let new_balance = Balance::add(user_account.savings_balance, amount);
        user_account.savings_balance = new_balance;

        // Optionally, update the transaction history
        let transaction_record = TransactionRecord {
            timestamp: now(ctx), // Assuming 'now' is a function to get the current timestamp
            transaction_type: "deposit".to_string(),
            amount: amount,
            // Other details
        };
        Vector::push_back(&mut user_account.transaction_history, transaction_record);

        // Save the updated account back to storage
        move_to(user_id, user_account);
    }
    public fun apply_for_loan(user_id: UID, amount: u64, purpose: String, ctx: &mut TxContext) -> UID {
        // Validate the loan amount
        assert!(amount >= MIN_LOAN, ELoanAmountTooLow);

        // Ensure the user account exists
        assert!(exists<UserAccount>(user_id), EAccountNotFound);

        // Generate a new UID for the loan request
        let loan_request_id = UID::new();

        // Create a new LoanRequest struct
        let loan_request = LoanRequest {
            id: loan_request_id,
            borrower_id: user_id,
            amount: amount,
            requested_on: now(ctx), // Assuming 'now' is a function to get the current timestamp
            due_by: calculate_due_date(ctx), // Function to calculate due date based on loan terms
            interest_rate: INTEREST_RATE,
            status: LoanStatus::Pending,
            purpose: purpose,
            repayment_history: Vector::empty(),
            credit_score_at_request: get_credit_score(user_id), // Function to retrieve user's credit score
            collateral_id: None, // Assuming no collateral is required for this loan type
        };

        // Store the loan request in Sui storage
        // Note: Add logic to save the loan request struct in the blockchain's storage

        // Return the unique identifier of the new loan request
        loan_request_id
    }

    public fun repay_loan(user_id: UID, loan_id: UID, amount: u64, ctx: &mut TxContext) {
        // Ensure the user account exists
        assert!(exists<UserAccount>(user_id), EAccountNotFound);

        // Ensure the loan request exists
        assert!(exists<LoanRequest>(loan_id), ELoanNotFound);

        // Retrieve the user's account and loan request from storage
        let mut user_account = borrow_global_mut<UserAccount>(user_id);
        let mut loan_request = borrow_global_mut<LoanRequest>(loan_id);

        // Check that the loan belongs to the user
        assert!(loan_request.borrower_id == user_id, EUnauthorizedLoanAccess);

        // Validate that the repayment amount is not more than the loan balance
        assert!(amount <= loan_request.amount, ERepaymentAmountTooHigh);

        // Update the loan balance and user's account
        loan_request.amount -= amount;
        user_account.loan_balance = Balance::subtract(user_account.loan_balance, amount);

        // Update the repayment history
        let repayment_record = RepaymentRecord {
            id: UID::new(), // Create a new UID for each repayment record
            loan_request_id: loan_id,
            payment_date: now(ctx), // Assuming 'now' is a function to get the current timestamp
            amount_paid: amount,
            remaining_balance: loan_request.amount,
            interest_paid: calculate_interest_paid(amount, loan_request.interest_rate), // Function to calculate interest paid
            principal_paid: calculate_principal_paid(amount, loan_request.interest_rate), // Function to calculate principal paid
            late_fee_applied: calculate_late_fee(loan_request.due_by, ctx), // Function to calculate any late fee
            payer_id: user_id,
            repayment_method: "direct".to_string(), // Assuming direct repayment method
        };
        Vector::push_back(&mut loan_request.repayment_history, repayment_record);

        // Update the loan status if fully repaid
        if loan_request.amount == 0 {
            loan_request.status = LoanStatus::Repaid;
        }

        // Save the updated user account and loan request back to storage
        move_to(user_id, user_account);
        move_to(loan_id, loan_request);
    }

    public fun calculate_and_apply_interest(ctx: &mut TxContext) {
        // Iterate over all UserAccounts in the storage
        let user_accounts = global<UserAccounts>(ctx); // Assuming a collection of all user accounts

        for account in &user_accounts {
            // Retrieve each user account
            let mut user_account = borrow_global_mut<UserAccount>(account.id);

            // Calculate interest for savings
            let savings_interest = (user_account.savings_balance * INTEREST_RATE) / 100;
            user_account.savings_balance += savings_interest;

            // Check if there's an active loan
            if (user_account.active_loan_id.is_some()) {
                let loan_id = user_account.active_loan_id.unwrap();
                if (exists<LoanRequest>(loan_id)) {
                    let mut loan_request = borrow_global_mut<LoanRequest>(loan_id);

                    // Calculate interest for loan
                    let loan_interest = (loan_request.amount * loan_request.interest_rate) / 100;

                    // Update loan amount with interest
                    loan_request.amount += loan_interest;
                }
            }

            // Update last interest calculation timestamp
            user_account.last_interest_calculation = now(ctx);

            // Save the updated account
            move_to(account.id, user_account);
        }
    }public fun round_up_transaction(user_id: UID, transaction_amount: u64, ctx: &mut TxContext) {
        // Validate that the user account exists
        assert!(exists<UserAccount>(user_id), EAccountNotFound);

        // Retrieve the user's account
        let mut user_account = borrow_global_mut<UserAccount>(user_id);

        // Calculate the rounded amount (round up to the nearest unit)
        let rounded_amount = (transaction_amount + 99) / 100 * 100; // Assuming rounding to the nearest 100
        let round_up_difference = rounded_amount - transaction_amount;

        // Check if rounding up leads to any difference
        if (round_up_difference > 0) {
            // Decide whether to save or lend the difference
            // This decision can be based on user's preference or other logic
            // For simplicity, let's assume we always add it to savings

            // Update the user's savings balance
            user_account.savings_balance = Balance::add(user_account.savings_balance, round_up_difference);

            // Optionally, update the transaction history
            let transaction_record = TransactionRecord {
                timestamp: now(ctx), // Assuming 'now' is a function to get the current timestamp
                transaction_type: "round-up".to_string(),
                amount: round_up_difference,
                // Other details...
            };
            Vector::push_back(&mut user_account.transaction_history, transaction_record);
        }

        // Save the updated account back to storage
        move_to(user_id, user_account);
    }
    fun get_account(user_id: UID): UserAccount {
        // Check if the account exists
        assert!(exists<UserAccount>(user_id), EAccountNotFound);

        // Retrieve and return the user account
        let account = borrow_global<UserAccount>(user_id);
        *account
    }
    fun calculate_due_date(ctx: &mut TxContext): u64 {
        // Assuming a fixed loan term, e.g., 30 days
        const LOAN_TERM_DAYS: u64 = 30;
        // Add LOAN_TERM_DAYS to the current timestamp
        now(ctx) + (LOAN_TERM_DAYS * 86400) // 86400 seconds in a day
    }
    fun get_credit_score(user_id: UID): u64 {
        // Retrieve the user account
        assert!(exists<UserAccount>(user_id), EAccountNotFound);
        let account = borrow_global<UserAccount>(user_id);

        // Return the credit score
        account.credit_score
        }fun calculate_interest_paid(amount: u64, interest_rate: u64): u64 {
        // Simple interest calculation
        (amount * interest_rate) / 100
    }

    fun calculate_principal_paid(amount: u64, interest_rate: u64): u64 {
        // Assuming the entire amount goes towards the principal for simplicity
        amount
    }

    fun calculate_late_fee(due_by: u64, ctx: &mut TxContext): u64 {
        // Check if the payment is late
        if (now(ctx) > due_by) {
            // Calculate late fee, e.g., a flat fee or a percentage of the loan amount
            const LATE_FEE: u64 = 50; // Flat late fee
            LATE_FEE
        } else {
            0
        }
    }



}
