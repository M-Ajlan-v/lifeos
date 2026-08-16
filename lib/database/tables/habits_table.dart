import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get time => text()(); // HH:mm daily reminder
  TextColumn get createdAt => text()(); // ISO string
  IntColumn get isActive => integer().withDefault(const Constant(1))(); // 0/1 soft delete
}