import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

import 'accounts_table.dart';
import 'categories_table.dart';
import 'contacts_table.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get type => text()();
  IntColumn get amount => integer()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get toAccountId => integer().nullable().references(Accounts, #id)();
  IntColumn get contactId => integer().nullable().references(Contacts, #id)();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
}