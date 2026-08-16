import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class UserSettings extends Table {
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {userId, key};
}