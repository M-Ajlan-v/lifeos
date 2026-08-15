import 'package:lifeos/database/app_database.dart';

/// Temporary helper only for verifying Contacts migration.
/// Delete this file after testing is finished.
class MigrationTestHelper {
  final AppDatabase db;

  MigrationTestHelper(this.db);

  /// Prints useful information about the contacts table.
  Future<void> printContactsInfo() async {
    print('=== CONTACTS MIGRATION TEST ===');

    // Check columns exist
    final tableInfo = await db.customSelect('PRAGMA table_info(contacts)').get();
    print('Columns in contacts table:');
    for (final row in tableInfo) {
      print('  - ${row.data['name']} (${row.data['type']})');
    }

    // Check indexes
    final indexes = await db.customSelect(
      "SELECT name, sql FROM sqlite_master WHERE type = 'index' AND tbl_name = 'contacts'",
    ).get();
    print('\nIndexes on contacts:');
    for (final row in indexes) {
      print('  - ${row.data['name']}');
      print('    ${row.data['sql']}');
    }

    // Count contacts
    final count = await db.customSelect('SELECT COUNT(*) as c FROM contacts').getSingle();
    print('\nTotal contacts: ${count.data['c']}');

    // Show a few contacts if any exist
    final contacts = await db.customSelect(
      'SELECT id, user_id, name, phone, opening_amount, opening_type, '
      'current_amount, current_type, is_active FROM contacts LIMIT 10',
    ).get();

    print('\nSample contacts:');
    for (final row in contacts) {
      print(row.data);
    }

    print('=== END TEST ===');
  }
}