import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/habits_table.dart';

class HabitHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  TextColumn get date => text()(); // yyyy-MM-dd
  TextColumn get status => text()(); // 'DONE' | 'NOT_DONE'
  TextColumn get completedAt => text().nullable()(); // ISO string, only when DONE

  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, date},
      ];
}