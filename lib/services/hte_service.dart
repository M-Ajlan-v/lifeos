import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:lifeos/database/app_database.dart';
import 'package:intl/intl.dart';

class HteService {
  final AppDatabase db;
  final FlutterLocalNotificationsPlugin plugin;

  HteService(this.db, this.plugin);

  // ==================== HELPERS ====================

  String _today() => DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _nowIso() => DateTime.now().toIso8601String();

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          'hte_channel',
          'Todos Events Habits',
          channelDescription: 'Notifications for Todos, Events and Habits',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
      );
   // ==================== TODOS & EVENTS ====================

  Future<int> createTodoEvent({
    required int userId,
    required String type, // 'TODO' | 'EVENT'
    required String title,
    String? description,
    required bool notificationEnabled,
    String? date,
    String? time,
  }) async {
    final id = await db.into(db.todosEvents).insert(
          TodosEventsCompanion.insert(
            userId: userId,
            type: type,
            title: title,
            description: Value(description),
            createdAt: _nowIso(),
            notificationEnabled: Value(notificationEnabled ? 1 : 0),
            date: Value(date),
            time: Value(time),
            isCompleted: const Value(0),
          ),
        );

    if (notificationEnabled && date != null && time != null) {
      final notifId = await _scheduleTodoEventNotification(
        id: id,
        title: title,
        body: description ?? title,
        date: date,
        time: time,
      );
      await (db.update(db.todosEvents)..where((t) => t.id.equals(id)))
          .write(TodosEventsCompanion(notificationId: Value(notifId)));
    }

    return id;
  }

  Future<void> updateTodoEvent({
    required int id,
    required String title,
    String? description,
    required bool notificationEnabled,
    String? date,
    String? time,
  }) async {
    final existing = await (db.select(db.todosEvents)..where((t) => t.id.equals(id))).getSingle();

    // Cancel old notification if any
    if (existing.notificationId != null) {
      await plugin.cancel(id: existing.notificationId!);
    }

    int? newNotifId;
    if (notificationEnabled && date != null && time != null) {
      newNotifId = await _scheduleTodoEventNotification(
        id: id,
        title: title,
        body: description ?? title,
        date: date,
        time: time,
      );
    }

    await (db.update(db.todosEvents)..where((t) => t.id.equals(id))).write(
      TodosEventsCompanion(
        title: Value(title),
        description: Value(description),
        notificationEnabled: Value(notificationEnabled ? 1 : 0),
        date: Value(date),
        time: Value(time),
        notificationId: Value(newNotifId),
      ),
    );
  }

  Future<void> completeTodo(int id) async {
    final item = await (db.select(db.todosEvents)..where((t) => t.id.equals(id))).getSingle();
    if (item.notificationId != null) {
      await plugin.cancel(id: item.notificationId!);
    }
    await (db.delete(db.todosEvents)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteTodoEvent(int id) async {
    final item = await (db.select(db.todosEvents)..where((t) => t.id.equals(id))).getSingle();
    if (item.notificationId != null) {
      await plugin.cancel(id: item.notificationId!);
    }
    await (db.delete(db.todosEvents)..where((t) => t.id.equals(id))).go();
  }

  Future<List<TodosEvent>> getTodosEvents(int userId, {String? type}) {
    final query = db.select(db.todosEvents)..where((t) => t.userId.equals(userId));
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.get();
  }

  Future<int> _scheduleTodoEventNotification({
    required int id,
    required String title,
    required String body,
    required String date,
    required String time,
  }) async {
    final parts = date.split('-').map(int.parse).toList();
    final timeParts = time.split(':').map(int.parse).toList();

    final when = tz.TZDateTime(
      tz.local,
      parts[0],
      parts[1],
      parts[2],
      timeParts[0],
      timeParts[1],
    );

    final now = tz.TZDateTime.now(tz.local);

    // Do not schedule if time is already past
    if (when.isBefore(now)) {
      print('❌ Todo/Event time is in the past – notification not scheduled');
      return -1;
    }

    final notifId = 100000 + id;

    await plugin.zonedSchedule(
      id: notifId,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'TODO_EVENT|$id',
    );

    print('✅ Todo/Event notification scheduled for $when (id: $notifId)');
    return notifId;
  }

  // ==================== HABITS ====================

  Future<int> createHabit({
    required int userId,
    required String title,
    String? description,
    required String time, // HH:mm
  }) async {
    final id = await db.into(db.habits).insert(
          HabitsCompanion.insert(
            userId: userId,
            title: title,
            description: Value(description),
            time: time,
            createdAt: _nowIso(),
            isActive: const Value(1),
          ),
        );

    await _refreshHabitNotifications(userId);
    return id;
  }

  Future<void> updateHabit({
    required int id,
    required String title,
    String? description,
    required String time,
  }) async {
    await (db.update(db.habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(
        title: Value(title),
        description: Value(description),
        time: Value(time),
      ),
    );
    final habit = await (db.select(db.habits)..where((h) => h.id.equals(id))).getSingle();
    await _refreshHabitNotifications(habit.userId);
  }

  Future<void> deleteHabit(int id) async {
    final habit = await (db.select(db.habits)..where((h) => h.id.equals(id))).getSingle();

    // Soft delete
    await (db.update(db.habits)..where((h) => h.id.equals(id)))
        .write(const HabitsCompanion(isActive: Value(0)));

    // Cancel all scheduled notifications for this habit (30-day window)
    final notifId = 200000 + id;
    await plugin.cancel(id: notifId);

    await _refreshHabitNotifications(habit.userId);
  }

  Future<void> markHabitDone(int habitId) async {
    final today = _today();
    final now = _nowIso();

    // Upsert
    final existing = await (db.select(db.habitHistory)
          ..where((h) => h.habitId.equals(habitId) & h.date.equals(today)))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.habitHistory).insert(
            HabitHistoryCompanion.insert(
              habitId: habitId,
              date: today,
              status: 'DONE',
              completedAt: Value(now),
            ),
          );
    } else {
      await (db.update(db.habitHistory)..where((h) => h.id.equals(existing.id))).write(
        HabitHistoryCompanion(
          status: const Value('DONE'),
          completedAt: Value(now),
        ),
      );
    }

    // Cancel today's notification if still pending
    final notifId = _habitNotifId(habitId, 0);
    await plugin.cancel(id: notifId);
  }

  Future<List<Habit>> getActiveHabits(int userId) {
    return (db.select(db.habits)
          ..where((h) => h.userId.equals(userId) & h.isActive.equals(1))
          ..orderBy([(h) => OrderingTerm.desc(h.createdAt)]))
        .get();
  }

  Future<List<HabitHistoryData>> getHabitHistory(int habitId) {
    return (db.select(db.habitHistory)
          ..where((h) => h.habitId.equals(habitId))
          ..orderBy([(h) => OrderingTerm.desc(h.date)]))
        .get();
  }

  // Day-end processing (call on every app open / resume)
  Future<void> processMissedHabitDays(int userId) async {
    final today = _today();

    // Get last_checked_date
    final setting = await (db.select(db.userSettings)
          ..where((s) => s.userId.equals(userId) & s.key.equals('last_checked_date')))
        .getSingleOrNull();

    String lastChecked = setting?.value ?? today;

    if (lastChecked.compareTo(today) >= 0) {
      // Already up to date
      return;
    }

    final start = DateTime.parse(lastChecked).add(const Duration(days: 1));
    final end = DateTime.parse(today).subtract(const Duration(days: 1));

    if (start.isAfter(end)) {
      // Nothing to process
      await _setLastChecked(userId, today);
      return;
    }

    final activeHabits = await getActiveHabits(userId);

    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      final dateStr = DateFormat('yyyy-MM-dd').format(d);

      for (final habit in activeHabits) {
        final exists = await (db.select(db.habitHistory)
              ..where((h) => h.habitId.equals(habit.id) & h.date.equals(dateStr)))
            .getSingleOrNull();

        if (exists == null) {
          await db.into(db.habitHistory).insert(
                HabitHistoryCompanion.insert(
                  habitId: habit.id,
                  date: dateStr,
                  status: 'NOT_DONE',
                ),
              );
        }
      }
    }

    await _setLastChecked(userId, today);
  }

  Future<void> _setLastChecked(int userId, String date) async {
    final existing = await (db.select(db.userSettings)
          ..where((s) => s.userId.equals(userId) & s.key.equals('last_checked_date')))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.userSettings).insert(
            UserSettingsCompanion.insert(
              userId: userId,
              key: 'last_checked_date',
              value: date,
            ),
          );
    } else {
      await (db.update(db.userSettings)
            ..where((s) => s.userId.equals(userId) & s.key.equals('last_checked_date')))
          .write(UserSettingsCompanion(value: Value(date)));
    }
  }

  // Rolling 30-day notifications for habits
  Future<void> _refreshHabitNotifications(int userId) async {
    final habits = await getActiveHabits(userId);

    for (final habit in habits) {
      // Cancel any previous notifications for this habit
      // (we now use a single daily notification per habit)
      final notifId = 200000 + habit.id;
      await plugin.cancel(id: notifId);

      final timeParts = habit.time.split(':').map(int.parse).toList();
      final now = tz.TZDateTime.now(tz.local);

      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        timeParts[0],
        timeParts[1],
      );

      // If today's time has already passed → schedule for tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      await plugin.zonedSchedule(
        id: notifId,
        title: habit.title,
        body: habit.description ?? 'Habit reminder',
        scheduledDate: scheduled,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // ← daily repeat
        payload: 'HABIT|${habit.id}',
      );

      print('✅ Daily habit notification scheduled for ${habit.title} at ${habit.time}');
    }
  }

  int _habitNotifId(int habitId, int dayOffset) => 200000 + (habitId * 100) + dayOffset;

  // ==================== NOTIFICATION LOG ====================

  Future<void> logNotificationFired({
    required int userId,
    required String sourceType, // 'TODO' | 'EVENT' | 'HABIT'
    required int sourceId,
    required String title,
    required String body,
  }) async {
    await db.into(db.notificationLog).insert(
          NotificationLogCompanion.insert(
            userId: userId,
            sourceType: Value(sourceType),
            sourceId: Value(sourceId),
            title: Value(title),
            body: Value(body),
            firedAt: Value(DateTime.now().toUtc()),
            status: const Value('UNSEEN'),
            createdAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<List<NotificationLogData>> getFiredNotifications(int userId) {
    return (db.select(db.notificationLog)
          ..where((n) => n.userId.equals(userId))
          ..orderBy([(n) => OrderingTerm(expression: n.firedAt, mode: OrderingMode.desc)]))
        .get();
  }

    /// Call this every time the app starts or resumes.
  /// It finds notifications that should have already fired and logs them.
  Future<void> syncFiredNotifications(int userId) async {
    final now = tz.TZDateTime.now(tz.local);

    // ---------- 1. Check Todos & Events ----------
    final todosEvents = await (db.select(db.todosEvents)
          ..where((t) =>
              t.userId.equals(userId) &
              t.notificationEnabled.equals(1) &
              t.date.isNotNull() &
              t.time.isNotNull()))
        .get();

    for (final item in todosEvents) {
      if (item.date == null || item.time == null) continue;

      final parts = item.date!.split('-').map(int.parse).toList();
      final timeParts = item.time!.split(':').map(int.parse).toList();

      final scheduled = tz.TZDateTime(
        tz.local,
        parts[0],
        parts[1],
        parts[2],
        timeParts[0],
        timeParts[1],
      );

      // Only log if the time has already passed
      if (scheduled.isAfter(now)) continue;

      // Check if already logged
      final alreadyLogged = await (db.select(db.notificationLog)
            ..where((n) =>
                n.userId.equals(userId) &
                n.sourceType.equals(item.type) &
                n.sourceId.equals(item.id)))
          .getSingleOrNull();

      if (alreadyLogged != null) continue;

      // Insert into log
      await db.into(db.notificationLog).insert(
            NotificationLogCompanion.insert(
              userId: userId,
              sourceType: Value(item.type),
              sourceId: Value(item.id),
              title: Value(item.title),
              body: Value(item.description ?? item.title),
              firedAt: Value(scheduled.toUtc()),
              status: const Value('UNSEEN'),
              createdAt: Value(DateTime.now().toUtc()),
            ),
          );
    }

    // ---------- 2. Check Habits (daily) ----------
    final habits = await getActiveHabits(userId);

    for (final habit in habits) {
      final timeParts = habit.time.split(':').map(int.parse).toList();

      // Check today
      var scheduledToday = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        timeParts[0],
        timeParts[1],
      );

      if (scheduledToday.isBefore(now) || scheduledToday.isAtSameMomentAs(now)) {
        final alreadyLogged = await (db.select(db.notificationLog)
              ..where((n) =>
                  n.userId.equals(userId) &
                  n.sourceType.equals('HABIT') &
                  n.sourceId.equals(habit.id) &
                  n.firedAt.isBiggerOrEqualValue(
                      DateTime(now.year, now.month, now.day).toUtc())))
            .getSingleOrNull();

        if (alreadyLogged == null) {
          await db.into(db.notificationLog).insert(
                NotificationLogCompanion.insert(
                  userId: userId,
                  sourceType: const Value('HABIT'),
                  sourceId: Value(habit.id),
                  title: Value(habit.title),
                  body: Value(habit.description ?? 'Habit reminder'),
                  firedAt: Value(scheduledToday.toUtc()),
                  status: const Value('UNSEEN'),
                  createdAt: Value(DateTime.now().toUtc()),
                ),
              );
        }
      }
    }
  }
}