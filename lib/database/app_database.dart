import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/users_table.dart';
import 'tables/accounts_table.dart';
import 'tables/contacts_table.dart';
import 'tables/categories_table.dart';
import 'tables/transactions_table.dart';
import 'tables/features_table.dart';
import 'tables/reminders_table.dart';
import 'tables/notification_log_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Users,
  Accounts,
  Contacts,
  Categories,
  Transactions,
  Features,
  Reminders,
  NotificationLog,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        await customStatement('PRAGMA foreign_keys = ON');

        // updated_at triggers
        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS users_updated_at
          AFTER UPDATE ON users
          BEGIN
            UPDATE users SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS accounts_updated_at
          AFTER UPDATE ON accounts
          BEGIN
            UPDATE accounts SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS contacts_updated_at
          AFTER UPDATE ON contacts
          BEGIN
            UPDATE contacts SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS categories_updated_at
          AFTER UPDATE ON categories
          BEGIN
            UPDATE categories SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS transactions_updated_at
          AFTER UPDATE ON transactions
          BEGIN
            UPDATE transactions SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS features_updated_at
          AFTER UPDATE ON features
          BEGIN
            UPDATE features SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS reminders_updated_at
          AFTER UPDATE ON reminders
          BEGIN
            UPDATE reminders SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
          END;
        ''');

        // Transaction integrity triggers
        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS validate_transaction_insert
          BEFORE INSERT ON transactions
          BEGIN
            SELECT CASE
              WHEN NEW.amount <= 0 THEN
                RAISE(ABORT, 'amount must be greater than 0')
              WHEN NEW.type = 'TRANSFER' AND (NEW.to_account_id IS NULL OR NEW.account_id = NEW.to_account_id) THEN
                RAISE(ABORT, 'TRANSFER requires different to_account_id')
              WHEN NEW.type = 'TRANSFER' AND (NEW.contact_id IS NOT NULL OR NEW.category_id IS NOT NULL) THEN
                RAISE(ABORT, 'TRANSFER cannot have contact or category')
              WHEN NEW.type IN ('INCOME', 'EXPENSE') AND (NEW.category_id IS NULL OR NEW.contact_id IS NOT NULL OR NEW.to_account_id IS NOT NULL) THEN
                RAISE(ABORT, 'INCOME/EXPENSE requires category and no contact/to_account')
              WHEN NEW.type IN ('GAVE', 'GOT') AND (NEW.contact_id IS NULL OR NEW.category_id IS NOT NULL OR NEW.to_account_id IS NOT NULL) THEN
                RAISE(ABORT, 'GAVE/GOT requires contact and no category/to_account')
              WHEN NEW.type NOT IN ('INCOME', 'EXPENSE', 'GAVE', 'GOT', 'TRANSFER') THEN
                RAISE(ABORT, 'invalid transaction type')
            END;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS validate_transaction_update
          BEFORE UPDATE ON transactions
          BEGIN
            SELECT CASE
              WHEN NEW.amount <= 0 THEN
                RAISE(ABORT, 'amount must be greater than 0')
              WHEN NEW.type = 'TRANSFER' AND (NEW.to_account_id IS NULL OR NEW.account_id = NEW.to_account_id) THEN
                RAISE(ABORT, 'TRANSFER requires different to_account_id')
              WHEN NEW.type = 'TRANSFER' AND (NEW.contact_id IS NOT NULL OR NEW.category_id IS NOT NULL) THEN
                RAISE(ABORT, 'TRANSFER cannot have contact or category')
              WHEN NEW.type IN ('INCOME', 'EXPENSE') AND (NEW.category_id IS NULL OR NEW.contact_id IS NOT NULL OR NEW.to_account_id IS NOT NULL) THEN
                RAISE(ABORT, 'INCOME/EXPENSE requires category and no contact/to_account')
              WHEN NEW.type IN ('GAVE', 'GOT') AND (NEW.contact_id IS NULL OR NEW.category_id IS NOT NULL OR NEW.to_account_id IS NOT NULL) THEN
                RAISE(ABORT, 'GAVE/GOT requires contact and no category/to_account')
              WHEN NEW.type NOT IN ('INCOME', 'EXPENSE', 'GAVE', 'GOT', 'TRANSFER') THEN
                RAISE(ABORT, 'invalid transaction type')
            END;
          END;
        ''');

        // Indexes
        await customStatement('CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON accounts(user_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_contacts_user_id ON contacts(user_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_categories_user_id ON categories(user_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_features_user_id ON features(user_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_features_user_parent ON features(user_id, parent_feature_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions(user_id, transaction_date)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_user_account ON transactions(user_id, account_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_user_to_account ON transactions(user_id, to_account_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_user_category ON transactions(user_id, category_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_user_contact ON transactions(user_id, contact_id)');

        await customStatement('CREATE INDEX IF NOT EXISTS idx_accounts_active ON accounts(user_id) WHERE is_active = 1');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_contacts_active ON contacts(user_id) WHERE is_active = 1');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(user_id) WHERE is_active = 1');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_active_date ON transactions(user_id, transaction_date) WHERE is_active = 1');

        await customStatement('CREATE INDEX IF NOT EXISTS idx_reminders_user ON reminders(user_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_reminders_active ON reminders(user_id) WHERE is_active = 1');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_reminders_entity ON reminders(feature_key, entity_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_notiflog_user_status ON notification_log(user_id, status)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_notiflog_reminder ON notification_log(reminder_id)');

        // NEW for schema 2: active-only unique phone per user
        await customStatement('''
          CREATE UNIQUE INDEX IF NOT EXISTS idx_contacts_user_phone_active
          ON contacts(user_id, phone)
          WHERE is_active = 1
        ''');
      },
         onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // 1. Add the two new columns using raw SQL (avoids the IntColumn / GeneratedColumn type error)
          await customStatement(
            'ALTER TABLE contacts ADD COLUMN current_amount INTEGER NOT NULL DEFAULT 0',
          );
          await customStatement(
            "ALTER TABLE contacts ADD COLUMN current_type TEXT NOT NULL DEFAULT 'SETTLED'",
          );

          // 2. Backfill currentAmount / currentType from opening + active GAVE/GOT
          await customStatement('''
            UPDATE contacts
            SET
              current_amount = (
                CASE
                  WHEN opening_type = 'WILL_GET' THEN opening_amount
                  WHEN opening_type = 'WILL_GIVE' THEN -opening_amount
                  ELSE 0
                END
                + COALESCE((
                  SELECT SUM(amount)
                  FROM transactions t
                  WHERE t.contact_id = contacts.id
                    AND t.user_id = contacts.user_id
                    AND t.is_active = 1
                    AND t.type = 'GAVE'
                ), 0)
                - COALESCE((
                  SELECT SUM(amount)
                  FROM transactions t
                  WHERE t.contact_id = contacts.id
                    AND t.user_id = contacts.user_id
                    AND t.is_active = 1
                    AND t.type = 'GOT'
                ), 0)
              ),
              current_type = (
                CASE
                  WHEN (
                    CASE
                      WHEN opening_type = 'WILL_GET' THEN opening_amount
                      WHEN opening_type = 'WILL_GIVE' THEN -opening_amount
                      ELSE 0
                    END
                    + COALESCE((
                      SELECT SUM(amount)
                      FROM transactions t
                      WHERE t.contact_id = contacts.id
                        AND t.user_id = contacts.user_id
                        AND t.is_active = 1
                        AND t.type = 'GAVE'
                    ), 0)
                    - COALESCE((
                      SELECT SUM(amount)
                      FROM transactions t
                      WHERE t.contact_id = contacts.id
                        AND t.user_id = contacts.user_id
                        AND t.is_active = 1
                        AND t.type = 'GOT'
                    ), 0)
                  ) > 0 THEN 'WILL_GET'
                  WHEN (
                    CASE
                      WHEN opening_type = 'WILL_GET' THEN opening_amount
                      WHEN opening_type = 'WILL_GIVE' THEN -opening_amount
                      ELSE 0
                    END
                    + COALESCE((
                      SELECT SUM(amount)
                      FROM transactions t
                      WHERE t.contact_id = contacts.id
                        AND t.user_id = contacts.user_id
                        AND t.is_active = 1
                        AND t.type = 'GAVE'
                    ), 0)
                    - COALESCE((
                      SELECT SUM(amount)
                      FROM transactions t
                      WHERE t.contact_id = contacts.id
                        AND t.user_id = contacts.user_id
                        AND t.is_active = 1
                        AND t.type = 'GOT'
                    ), 0)
                  ) < 0 THEN 'WILL_GIVE'
                  ELSE 'SETTLED'
                END
              )
          ''');

          // 3. Make current_amount always positive
          await customStatement('''
            UPDATE contacts
            SET current_amount = ABS(current_amount)
          ''');

          // 4. Drop old full unique indexes (common names Drift may have created)
          await customStatement('DROP INDEX IF EXISTS contacts_user_id_phone_key');
          await customStatement('DROP INDEX IF EXISTS contacts_user_id_phone_unique');
          await customStatement('DROP INDEX IF EXISTS idx_contacts_user_phone');

          // 5. Create the new partial unique index (only active contacts)
          await customStatement('''
            CREATE UNIQUE INDEX IF NOT EXISTS idx_contacts_user_phone_active
            ON contacts(user_id, phone)
            WHERE is_active = 1
          ''');
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> createFirstUserAndDefaults({
    required String username,
    required String password,
    String? displayName,
  }) async {
    await transaction(() async {
      final now = DateTime.now().toUtc();

      final userId = await into(users).insert(
        UsersCompanion.insert(
          username: username.toLowerCase(),
          password: password,
          displayName: Value(displayName),
          createdAt: now,
          updatedAt: now,
        ),
      );

      await into(accounts).insert(
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

      final moneyId = await into(features).insert(
        FeaturesCompanion.insert(
          userId: userId,
          featureKey: 'money',
          name: 'Money',
          isEnabled: const Value(1),
          createdAt: now,
          updatedAt: now,
        ),
      );

      await into(features).insert(
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

      await into(features).insert(
        FeaturesCompanion.insert(
          userId: userId,
          featureKey: 'learning',
          name: 'Learning',
          isEnabled: const Value(0),
          createdAt: now,
          updatedAt: now,
        ),
      );

      await into(features).insert(
        FeaturesCompanion.insert(
          userId: userId,
          featureKey: 'reading',
          name: 'Reading',
          isEnabled: const Value(0),
          createdAt: now,
          updatedAt: now,
        ),
      );
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'lifeos.db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationDocumentsDirectory,
      ),
    );
  }
}