import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get type => text()();
  IntColumn get openingBalance => integer()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}