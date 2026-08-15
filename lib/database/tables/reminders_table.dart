import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();

  TextColumn get featureKey => text().nullable()();
  IntColumn get entityId => integer().nullable()();

  TextColumn get message => text().nullable()();

  TextColumn get reminderTime => text()();
  TextColumn get startDate => text().nullable()();

  TextColumn get repeatType => text()();

  TextColumn get daysOfWeek => text().nullable()();
  IntColumn get dayOfMonth => integer().nullable()();
  IntColumn get monthOfYear => integer().nullable()();
  IntColumn get intervalCount => integer().nullable()();
  TextColumn get intervalUnit => text().nullable()();

  TextColumn get endType => text().withDefault(const Constant('NEVER'))();
  TextColumn get endDate => text().nullable()();
  IntColumn get endCount => integer().nullable()();
  IntColumn get occurrenceCount => integer().withDefault(const Constant(0))();

  IntColumn get isActive => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}