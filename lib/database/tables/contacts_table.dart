import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  IntColumn get openingAmount => integer().withDefault(const Constant(0))();
  TextColumn get openingType => text()();
  TextColumn get description => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, phone},
  ];
}