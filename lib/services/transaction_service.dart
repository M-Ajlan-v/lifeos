import 'package:drift/drift.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/services/account_service.dart';

class TransactionService {
  final AppDatabase db;
  final ContactService contactService;
  final AccountService accountService;
  final CategoryService categoryService;

  TransactionService(
    this.db,
    this.contactService,
    this.accountService,
    this.categoryService,
  );
  // -------------------------------------------------------
  // Watch all active transactions for a user (newest first)
  // -------------------------------------------------------
  Stream<List<Transaction>> watchActiveTransactions(int userId) {
    final query = db.select(db.transactions).join([
      leftOuterJoin(
        db.contacts,
        db.contacts.id.equalsExp(db.transactions.contactId),
      ),
    ])
      ..where(
        db.transactions.userId.equals(userId) &
            db.transactions.isActive.equals(1) &
            (
              db.transactions.type.isNotIn(['GAVE', 'GOT']) |
                  db.contacts.isActive.equals(1)
            ),
      )
      ..orderBy([
        OrderingTerm.desc(db.transactions.transactionDate),
      ]);

    return query.watch().map(
          (rows) => rows
              .map((row) => row.readTable(db.transactions))
              .toList(),
        );
  }
    // -------------------------------------------------------
  // Watch only INCOME + EXPENSE (for Cashbook screen)
  // -------------------------------------------------------
  Stream<List<Transaction>> watchCashbookTransactions(int userId) {
    return (db.select(db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.isActive.equals(1) &
              (t.type.equals('INCOME') | t.type.equals('EXPENSE')))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  // -------------------------------------------------------
  // Watch only TRANSFER transactions (for Transfers screen)
  // -------------------------------------------------------
  Stream<List<Transaction>> watchTransferTransactions(int userId) {
    return (db.select(db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.isActive.equals(1) &
              t.type.equals('TRANSFER'))
          ..orderBy([
            (t) => OrderingTerm.desc(t.transactionDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  // -------------------------------------------------------
  // Get single transaction
  // -------------------------------------------------------
  Future<Transaction?> getTransactionById({
    required int userId,
    required int transactionId,
  }) {
    return (db.select(db.transactions)
          ..where((t) =>
              t.id.equals(transactionId) & t.userId.equals(userId)))
        .getSingleOrNull();
  }

  // -------------------------------------------------------
  // Create a new transaction (with full validation + balance updates)
  // -------------------------------------------------------
  Future<int> createTransaction({
    required int userId,
    required String type, // INCOME, EXPENSE, GAVE, GOT, TRANSFER
    required int amount,
    required int accountId,
    int? toAccountId,
    int? contactId,
    int? categoryId,
    String? description,
    required DateTime transactionDate,
  }) async {
    // Basic validation
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    // Ownership checks
    final account = await accountService.getAccountById(
      userId: userId,
      accountId: accountId,
    );
    if (account == null) {
      throw Exception('Account not found');
    }

    if (type == 'TRANSFER') {
      if (toAccountId == null || toAccountId == accountId) {
        throw Exception('TRANSFER requires a different destination account');
      }
      final toAccount = await accountService.getAccountById(
        userId: userId,
        accountId: toAccountId,
      );
      if (toAccount == null) {
        throw Exception('Destination account not found');
      }
      if (contactId != null || categoryId != null) {
        throw Exception('TRANSFER cannot have contact or category');
      }
    }

    if (type == 'GAVE' || type == 'GOT') {
      if (contactId == null) {
        throw Exception('GAVE/GOT requires a contact');
      }
      final contact = await contactService.getContactById(
        userId: userId,
        contactId: contactId,
      );
      if (contact == null) {
        throw Exception('Contact not found');
      }
      if (categoryId != null || toAccountId != null) {
        throw Exception('GAVE/GOT cannot have category or toAccount');
      }
    }

    if (type == 'INCOME' || type == 'EXPENSE') {
      if (categoryId == null) {
        throw Exception('INCOME/EXPENSE requires a category');
      }
      if (contactId != null || toAccountId != null) {
        throw Exception('INCOME/EXPENSE cannot have contact or toAccount');
      }
    }

    if (type == 'EXPENSE' && account.openingBalance < amount) {
      throw Exception(
        'Cannot add expense. This expense is ₹$amount, but the selected account balance is ₹${account.openingBalance}.',
      );
    }

    final now = DateTime.now().toUtc();

    return await db.transaction(() async {
      // 1. Insert the transaction
      final txId = await db.into(db.transactions).insert(
            TransactionsCompanion.insert(
              userId: userId,
              type: type,
              amount: amount,
              accountId: accountId,
              toAccountId: Value(toAccountId),
              contactId: Value(contactId),
              categoryId: Value(categoryId),
              description: Value(description),
              transactionDate: transactionDate,
              createdAt: now,
              updatedAt: now,
              isActive: const Value(1),
            ),
          );

      // 2. Update Account balance(s)
      if (type == 'INCOME' || type == 'GOT') {
        // Money comes in → increase account balance
        await _updateAccountBalance(accountId, amount);
      } else if (type == 'EXPENSE' || type == 'GAVE') {
        // Money goes out → decrease account balance
        await _updateAccountBalance(accountId, -amount);
      } else if (type == 'TRANSFER') {
        // From account decreases, to account increases
        await _updateAccountBalance(accountId, -amount);
        await _updateAccountBalance(toAccountId!, amount);
      }

      // 3. Update Contact balance if GAVE or GOT
      if (type == 'GAVE' || type == 'GOT') {
        await contactService.recalculateContactBalance(
          userId: userId,
          contactId: contactId!,
        );
      }

      return txId;
    });
  }

  // -------------------------------------------------------
  // Soft delete a transaction + reverse balances
  // -------------------------------------------------------
  // -------------------------------------------------------
// Soft delete a transaction + reverse balances (atomic)
// -------------------------------------------------------
  Future<void> softDeleteTransaction({
    required int userId,
    required int transactionId,
  }) async {
    final tx = await getTransactionById(
      userId: userId,
      transactionId: transactionId,
    );

    if (tx == null) {
      throw Exception('Transaction not found');
    }
    if (tx.isActive == 0) {
      throw Exception('Transaction already deleted');
    }

    await db.transaction(() async {
      // 1. Reverse account balance FIRST
      if (tx.type == 'INCOME' || tx.type == 'GOT') {
        await _updateAccountBalance(tx.accountId, -tx.amount);
      } else if (tx.type == 'EXPENSE' || tx.type == 'GAVE') {
        await _updateAccountBalance(tx.accountId, tx.amount);
      } else if (tx.type == 'TRANSFER') {
        await _updateAccountBalance(tx.accountId, tx.amount);
        if (tx.toAccountId != null) {
          await _updateAccountBalance(tx.toAccountId!, -tx.amount);
        }
      }

      // 2. Mark inactive + recalculate contact if needed
      if ((tx.type == 'GAVE' || tx.type == 'GOT') && tx.contactId != null) {
        // Mark inactive first so recalculate excludes this transaction
        await (db.update(db.transactions)
              ..where((t) => t.id.equals(transactionId)))
            .write(const TransactionsCompanion(isActive: Value(0)));

        await contactService.recalculateContactBalance(
          userId: userId,
          contactId: tx.contactId!,
        );
      } else {
        // Non-contact transactions
        await (db.update(db.transactions)
              ..where((t) => t.id.equals(transactionId)))
            .write(const TransactionsCompanion(isActive: Value(0)));
      }
    });
  }

  // -------------------------------------------------------
  // Helper: update account openingBalance (which we use as current balance)
  // -------------------------------------------------------
  Future<void> _updateAccountBalance(int accountId, int delta) async {
    final account = await (db.select(db.accounts)
          ..where((a) => a.id.equals(accountId)))
        .getSingle();

    final newBalance = account.openingBalance + delta;

    await (db.update(db.accounts)..where((a) => a.id.equals(accountId))).write(
      AccountsCompanion(
        openingBalance: Value(newBalance),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}