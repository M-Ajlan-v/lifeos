import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart';

class AuthService {
  final AppDatabase db;

  AuthService(this.db);

  static const String _keyUserId = 'current_user_id';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Future<bool> isFirstLaunch() async {
    final users = await db.select(db.users).get();
    return users.isEmpty;
  }

  Future<int> register({
    required String username,
    required String password,
    String? displayName,
  }) async {
    final existing = await (db.select(db.users)
          ..where((u) => u.username.equals(username.toLowerCase())))
        .get();

    if (existing.isNotEmpty) {
      throw Exception('Username already exists');
    }

    final now = DateTime.now().toUtc();

    return await db.transaction(() async {
      final userId = await db.into(db.users).insert(
            UsersCompanion.insert(
              username: username.toLowerCase(),
              password: password,
              displayName: Value(displayName),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.accounts).insert(
            AccountsCompanion.insert(
              userId: userId,
              name: 'Cash',
              type: 'CASH',
              openingBalance: 0,
              isActive: const Value(1),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final moneyId = await db.into(db.features).insert(
            FeaturesCompanion.insert(
              userId: userId,
              featureKey: 'money',
              name: 'Money',
              isEnabled: const Value(1),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.features).insert(
            FeaturesCompanion.insert(
              userId: userId,
              featureKey: 'money.transfer',
              name: 'Transfer',
              parentFeatureId: Value(moneyId),
              isEnabled: const Value(1),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.features).insert(
            FeaturesCompanion.insert(
              userId: userId,
              featureKey: 'learning',
              name: 'Learning',
              isEnabled: const Value(0),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.features).insert(
            FeaturesCompanion.insert(
              userId: userId,
              featureKey: 'reading',
              name: 'Reading',
              isEnabled: const Value(0),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _saveSession(userId);
      return userId;
    });
  }

  Future<int> login({
    required String username,
    required String password,
  }) async {
    final user = await (db.select(db.users)
          ..where((u) => u.username.equals(username.toLowerCase())))
        .getSingleOrNull();

    if (user == null) {
      throw Exception('User not found');
    }

    if (user.password != password) {
      throw Exception('Incorrect password');
    }

    await _saveSession(user.id);
    return user.id;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogged = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLogged) return null;
    return prefs.getInt(_keyUserId);
  }

  Future<User?> getCurrentUser() async {
    final userId = await getCurrentUserId();
    if (userId == null) return null;

    return await (db.select(db.users)..where((u) => u.id.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> _saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setBool(_keyIsLoggedIn, true);
  }
}