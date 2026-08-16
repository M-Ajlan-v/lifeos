import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class TodosEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get type => text()(); // 'TODO' | 'EVENT'
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get createdAt => text()(); // ISO string
  IntColumn get notificationEnabled => integer().withDefault(const Constant(0))(); // 0/1
  TextColumn get date => text().nullable()(); // yyyy-MM-dd
  TextColumn get time => text().nullable()(); // HH:mm
  IntColumn get notificationId => integer().nullable()();
  IntColumn get isCompleted => integer().withDefault(const Constant(0))(); // only for TODO
}