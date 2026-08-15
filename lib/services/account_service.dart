import 'package:drift/drift.dart';
import 'package:lifeos/database/app_database.dart';

class AccountService {
  final AppDatabase db;

  AccountService(this.db);

  // -------------------------------------------------------
  // Watch all active accounts for a user
  // -------------------------------------------------------
  Stream<List<Account>> watchActiveAccounts(int userId) {
    return (db.select(db.accounts)
          ..where((a) => a.userId.equals(userId) & a.isActive.equals(1))
          ..orderBy([(a) => OrderingTerm.desc(a.updatedAt)]))
        .watch();
  }

  // -------------------------------------------------------
  // Get single account (with ownership check)
  // -------------------------------------------------------
  Future<Account?> getAccountById({
    required int userId,
    required int accountId,
  }) {
    return (db.select(db.accounts)
          ..where((a) =>
              a.id.equals(accountId) & a.userId.equals(userId)))
        .getSingleOrNull();
  }

  // -------------------------------------------------------
  // Create new account
  // -------------------------------------------------------
  Future<int> createAccount({
    required int userId,
    required String name,
    required String type,
    required int openingBalance,
  }) async {
    final now = DateTime.now().toUtc();

    return db.into(db.accounts).insert(
          AccountsCompanion.insert(
            userId: userId,
            name: name.trim(),
            type: type,
            openingBalance: openingBalance,
            isActive: const Value(1),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  // -------------------------------------------------------
  // Update account (name + type only)
  // Balance is never edited manually here
  // -------------------------------------------------------
  Future<void> updateAccount({
    required int userId,
    required int accountId,
    required String name,
    required String type,
  }) async {
    final existing = await getAccountById(userId: userId, accountId: accountId);
    if (existing == null) {
      throw Exception('Account not found');
    }

    await (db.update(db.accounts)
          ..where((a) => a.id.equals(accountId) & a.userId.equals(userId)))
        .write(
      AccountsCompanion(
        name: Value(name.trim()),
        type: Value(type),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  // -------------------------------------------------------
  // Soft delete (only allowed if balance == 0)
  // -------------------------------------------------------
  Future<void> deactivateAccount({
    required int userId,
    required int accountId,
  }) async {
    final account = await getAccountById(userId: userId, accountId: accountId);
    if (account == null) {
      throw Exception('Account not found');
    }

    if (account.isActive == 0) {
      throw Exception('Account is already inactive');
    }

    if (account.openingBalance != 0) {
      throw Exception('Cannot delete account with non-zero balance');
    }

    await (db.update(db.accounts)
          ..where((a) => a.id.equals(accountId) & a.userId.equals(userId)))
        .write(const AccountsCompanion(isActive: Value(0)));
  }
}