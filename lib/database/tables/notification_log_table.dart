import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';
import 'reminders_table.dart';

class NotificationLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get reminderId => integer().references(Reminders, #id)();

  DateTimeColumn get scheduledFor => dateTime()();
  DateTimeColumn get firedAt => dateTime().nullable()();

  TextColumn get status => text().withDefault(const Constant('UNSEEN'))();

  DateTimeColumn get createdAt => dateTime()();
}