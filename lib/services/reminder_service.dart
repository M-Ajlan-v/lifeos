import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:lifeos/database/app_database.dart';

class ReminderService {
  final AppDatabase db;
  final FlutterLocalNotificationsPlugin plugin;

  ReminderService(this.db, this.plugin);

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails('reminders', 'Reminders'),
      );

  Future<int> createReminder({
    required int userId,
    String? featureKey,
    int? entityId,
    String? message,
    required String reminderTime,
    String? startDate,
    required String repeatType,
    String? daysOfWeek,
    int? dayOfMonth,
    int? monthOfYear,
    int? intervalCount,
    String? intervalUnit,
    String endType = 'NEVER',
    String? endDate,
    int? endCount,
  }) async {
    final now = DateTime.now().toUtc();
    final id = await db.into(db.reminders).insert(
      RemindersCompanion.insert(
        userId: userId,
        featureKey: Value(featureKey),
        entityId: Value(entityId),
        message: Value(message),
        reminderTime: reminderTime,
        startDate: Value(startDate),
        repeatType: repeatType,
        daysOfWeek: Value(daysOfWeek),
        dayOfMonth: Value(dayOfMonth),
        monthOfYear: Value(monthOfYear),
        intervalCount: Value(intervalCount),
        intervalUnit: Value(intervalUnit),
        endType: Value(endType),
        endDate: Value(endDate),
        endCount: Value(endCount),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await scheduleReminder(id);
    return id;
  }

  Future<void> scheduleReminder(int reminderId) async {
    final reminder = await (db.select(db.reminders)..where((r) => r.id.equals(reminderId))).getSingle();
    if (reminder.isActive == 0) return;

    final parts = reminder.reminderTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await plugin.cancel(id: reminderId);

    switch (reminder.repeatType) {
      case 'ONCE':
        final d = reminder.startDate!.split('-').map(int.parse).toList();
        final when = tz.TZDateTime(tz.local, d[0], d[1], d[2], hour, minute);
        await plugin.zonedSchedule(
          id: reminderId,
          title: 'Reminder',
          body: reminder.message ?? 'Reminder',
          scheduledDate: when,
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        break;

      case 'DAILY':
        await plugin.zonedSchedule(
          id: reminderId,
          title: 'Reminder',
          body: reminder.message ?? 'Reminder',
          scheduledDate: _nextTime(hour, minute),
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        break;

      case 'WEEKLY':
        final days = reminder.daysOfWeek!.split(',');
        for (final code in days) {
          final weekday = _weekdayFromCode(code);
          await plugin.zonedSchedule(
            id: reminderId * 10 + weekday,
            title: 'Reminder',
            body: reminder.message ?? 'Reminder',
            scheduledDate: _nextWeekday(weekday, hour, minute),
            notificationDetails: _details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
        }
        break;

      case 'MONTHLY':
        await plugin.zonedSchedule(
          id: reminderId,
          title: 'Reminder',
          body: reminder.message ?? 'Reminder',
          scheduledDate: _nextDayOfMonth(reminder.dayOfMonth!, hour, minute),
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        );
        break;

      case 'YEARLY':
        await plugin.zonedSchedule(
          id: reminderId,
          title: 'Reminder',
          body: reminder.message ?? 'Reminder',
          scheduledDate: _nextYearlyDate(reminder.monthOfYear!, reminder.dayOfMonth!, hour, minute),
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
        break;

      case 'CUSTOM_INTERVAL':
        final d = reminder.startDate!.split('-').map(int.parse).toList();
        final when = tz.TZDateTime(tz.local, d[0], d[1], d[2], hour, minute);
        await plugin.zonedSchedule(
          id: reminderId,
          title: 'Reminder',
          body: reminder.message ?? 'Reminder',
          scheduledDate: when,
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        break;
    }
  }

  tz.TZDateTime _nextTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (t.isBefore(now)) t = t.add(const Duration(days: 1));
    return t;
  }

  tz.TZDateTime _nextWeekday(int weekday, int hour, int minute) {
    var t = _nextTime(hour, minute);
    while (t.weekday != weekday) {
      t = t.add(const Duration(days: 1));
    }
    return t;
  }

  tz.TZDateTime _nextDayOfMonth(int day, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(tz.local, now.year, now.month, day, hour, minute);
    if (t.isBefore(now)) {
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      final nextYear = now.month == 12 ? now.year + 1 : now.year;
      t = tz.TZDateTime(tz.local, nextYear, nextMonth, day, hour, minute);
    }
    return t;
  }

  tz.TZDateTime _nextYearlyDate(int month, int day, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(tz.local, now.year, month, day, hour, minute);
    if (t.isBefore(now)) t = tz.TZDateTime(tz.local, now.year + 1, month, day, hour, minute);
    return t;
  }

  int _weekdayFromCode(String code) {
    const map = {'MON': 1, 'TUE': 2, 'WED': 3, 'THU': 4, 'FRI': 5, 'SAT': 6, 'SUN': 7};
    return map[code]!;
  }

  Future<void> onNotificationFired(int reminderId) async {
    final reminder = await (db.select(db.reminders)..where((r) => r.id.equals(reminderId))).getSingle();
    final now = DateTime.now().toUtc();

    await db.into(db.notificationLog).insert(
      NotificationLogCompanion.insert(
        userId: reminder.userId,
        reminderId: reminderId,
        scheduledFor: now,
        firedAt: Value(now),
        status: const Value('UNSEEN'),
        createdAt: now,
      ),
    );

    final newCount = reminder.occurrenceCount + 1;
    await (db.update(db.reminders)..where((r) => r.id.equals(reminderId)))
        .write(RemindersCompanion(occurrenceCount: Value(newCount)));

    var shouldStop = false;
    if (reminder.endType == 'AFTER_COUNT' && reminder.endCount != null && newCount >= reminder.endCount!) {
      shouldStop = true;
    }
    if (reminder.endType == 'ON_DATE' && reminder.endDate != null) {
      if (DateTime.now().isAfter(DateTime.parse(reminder.endDate!))) shouldStop = true;
    }

    if (shouldStop) {
      await (db.update(db.reminders)..where((r) => r.id.equals(reminderId)))
          .write(const RemindersCompanion(isActive: Value(0)));
    } else if (reminder.repeatType == 'CUSTOM_INTERVAL') {
      await _scheduleNextCustomInterval(reminder);
    }
  }

  Future<void> _scheduleNextCustomInterval(Reminder reminder) async {
    final parts = reminder.reminderTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = tz.TZDateTime.now(tz.local);
    final gap = reminder.intervalUnit == 'WEEKS'
        ? Duration(days: 7 * reminder.intervalCount!)
        : Duration(days: reminder.intervalCount!);
    final next = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute).add(gap);

    await plugin.zonedSchedule(
      id: reminder.id,
      title: 'Reminder',
      body: reminder.message ?? 'Reminder',
      scheduledDate: next,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleAllActive(int userId) async {
    final all = await (db.select(db.reminders)
          ..where((r) => r.userId.equals(userId) & r.isActive.equals(1)))
        .get();
    for (final r in all) {
      await scheduleReminder(r.id);
    }
  }

  Future<void> deleteReminder(int reminderId) async {
    await plugin.cancel(id: reminderId);
    await (db.update(db.reminders)..where((r) => r.id.equals(reminderId)))
        .write(const RemindersCompanion(isActive: Value(0)));
  }
}