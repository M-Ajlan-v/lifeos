import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/reminder_service.dart';

class ReminderProvider extends ChangeNotifier {
  final AppDatabase db;
  final ReminderService reminderService;
  final int userId;

  List<NotificationLogData> _logs = [];
  int _unseenCount = 0;

  List<NotificationLogData> get logs => _logs;
  int get unseenCount => _unseenCount;

  ReminderProvider({
    required this.db,
    required this.reminderService,
    required this.userId,
  }) {
    _listenToLogs();
  }

  void _listenToLogs() {
    final query = db.select(db.notificationLog)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);

    query.watch().listen((rows) {
      _logs = rows;
      _unseenCount = rows.where((r) => r.status == 'UNSEEN').length;
      notifyListeners();
    });
  }

  Future<void> markSeen(int logId) async {
    await (db.update(db.notificationLog)..where((t) => t.id.equals(logId)))
        .write(const NotificationLogCompanion(status: Value('SEEN')));
  }

  Future<void> scheduleAll() => reminderService.scheduleAllActive(userId);
}