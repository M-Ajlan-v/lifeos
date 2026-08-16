import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class NotificationLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();

  // New fields for Todo / Event / Habit
  TextColumn get sourceType => text().nullable()(); // 'TODO' | 'EVENT' | 'HABIT' | 'REMINDER'
  IntColumn get sourceId => integer().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text().nullable()();

  // Keep old columns so existing ReminderService still works
  IntColumn get reminderId => integer().nullable()();
  DateTimeColumn get scheduledFor => dateTime().nullable()();
  DateTimeColumn get firedAt => dateTime().nullable()(); // already existed
  TextColumn get status => text().withDefault(const Constant('UNSEEN'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}