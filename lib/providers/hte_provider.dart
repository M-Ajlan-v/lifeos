import 'package:flutter/foundation.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/hte_service.dart';

class HteProvider extends ChangeNotifier {
  final HteService hteService;
  final int userId;

  List<TodosEvent> _todosEvents = [];
  List<Habit> _habits = [];
  List<NotificationLogData> _firedNotifications = [];

  List<TodosEvent> get todosEvents => _todosEvents;
  List<Habit> get habits => _habits;
  List<NotificationLogData> get firedNotifications => _firedNotifications;
  Stream<List<TodosEvent>> get todosEventsStream {
  return hteService.watchTodosEvents(userId);
  }

  Stream<List<Habit>> get habitsStream {
    return hteService.watchActiveHabits(userId);
  }

  Stream<List<NotificationLogData>>
      get firedNotificationsStream {
    return hteService.watchFiredNotifications(userId);
  }
  HteProvider({
    required this.hteService,
    required this.userId,
  }) {
    refreshAll();
  }

  Future<void> refreshAll() async {
    try {
      _todosEvents =
          await hteService.getTodosEvents(userId);
      _habits =
          await hteService.getActiveHabits(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('HTE data loading failed: $e');
    }
    try {
      await hteService.processMissedHabitDays(userId);
    } catch (e) {
      debugPrint('HTE missed-day processing failed: $e');
    }
    try {
      await hteService.syncFiredNotifications(userId);
    } catch (e) {
      debugPrint('HTE notification sync failed: $e');
    }
    try {
      _firedNotifications =
          await hteService.getFiredNotifications(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('HTE notification history failed: $e');
    }
  }

  Future<void> createTodoEvent({
    required String type,
    required String title,
    String? description,
    required bool notificationEnabled,
    String? date,
    String? time,
  }) async {
    await hteService.createTodoEvent(
      userId: userId,
      type: type,
      title: title,
      description: description,
      notificationEnabled: notificationEnabled,
      date: date,
      time: time,
    );
  }

  Future<void> updateTodoEvent({
    required int id,
    required String title,
    String? description,
    required bool notificationEnabled,
    String? date,
    String? time,
  }) async {
    await hteService.updateTodoEvent(
      id: id,
      title: title,
      description: description,
      notificationEnabled: notificationEnabled,
      date: date,
      time: time,
    );
    await refreshAll();
  }

  Future<void> completeTodo(int id) async {
    await hteService.completeTodo(id);
    await refreshAll();
  }

  Future<void> deleteTodoEvent(int id) async {
    await hteService.deleteTodoEvent(id);
    await refreshAll();
  }

  // ---------- Habits ----------

  Future<void> createHabit({
    required String title,
    String? description,
    required String time,
  }) async {
    await hteService.createHabit(
      userId: userId,
      title: title,
      description: description,
      time: time,
    );
    await refreshAll();
  }

  Future<void> updateHabit({
    required int id,
    required String title,
    String? description,
    required String time,
  }) async {
    await hteService.updateHabit(
      id: id,
      title: title,
      description: description,
      time: time,
    );
    await refreshAll();
  }

  Future<void> deleteHabit(int id) async {
    await hteService.deleteHabit(id);
    await refreshAll();
  }

  Future<void> markHabitDone(int habitId) async {
    await hteService.markHabitDone(habitId);
    await refreshAll();
  }

  Future<List<HabitHistoryData>> getHabitHistory(int habitId) {
    return hteService.getHabitHistory(habitId);
  }

  // ---------- Notifications ----------

  Future<void> logNotificationFired({
    required String sourceType,
    required int sourceId,
    required String title,
    required String body,
  }) async {
    await hteService.logNotificationFired(
      userId: userId,
      sourceType: sourceType,
      sourceId: sourceId,
      title: title,
      body: body,
    );
    await refreshAll();
  }

  List<TodosEvent> getUpcomingEvents(
  List<TodosEvent> items,
) {
  final now = DateTime.now();

  final upcoming = items.where((item) {
    if (item.type.trim().toUpperCase() != 'EVENT' ||
        item.date == null) {
      return false;
    }

    final date = DateTime.tryParse(item.date!);

    if (date == null) {
      return false;
    }

    var hour = 23;
    var minute = 59;

    if (item.time != null &&
        item.time!.trim().isNotEmpty) {
      final parts = item.time!.split(':');

      if (parts.length >= 2) {
        hour = int.tryParse(parts[0]) ?? 23;
        minute = int.tryParse(parts[1]) ?? 59;
      }
    }

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    return dateTime.isAfter(now);
  }).toList();

  upcoming.sort((a, b) {
    DateTime parse(TodosEvent item) {
      final date = DateTime.parse(item.date!);

      var hour = 23;
      var minute = 59;

      if (item.time != null &&
          item.time!.trim().isNotEmpty) {
        final parts = item.time!.split(':');

        if (parts.length >= 2) {
          hour = int.tryParse(parts[0]) ?? 23;
          minute = int.tryParse(parts[1]) ?? 59;
        }
      }

      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    }

    return parse(a).compareTo(parse(b));
  });

  return upcoming.take(3).toList();
}

  List<TodosEvent> getUpcomingTodos(
  List<TodosEvent> items,
) {
  final now = DateTime.now();

  final upcoming = items.where((item) {
    if (item.type.trim().toUpperCase() != 'TODO' ||
        item.date == null) {
      return false;
    }

    final date = DateTime.tryParse(item.date!);

    if (date == null) {
      return false;
    }

    var hour = 23;
    var minute = 59;

    if (item.time != null &&
        item.time!.trim().isNotEmpty) {
      final parts = item.time!.split(':');

      if (parts.length >= 2) {
        hour = int.tryParse(parts[0]) ?? 23;
        minute = int.tryParse(parts[1]) ?? 59;
      }
    }

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    return dateTime.isAfter(now);
  }).toList();

  upcoming.sort((a, b) {
    DateTime parse(TodosEvent item) {
      final date = DateTime.parse(item.date!);

      var hour = 23;
      var minute = 59;

      if (item.time != null &&
          item.time!.trim().isNotEmpty) {
        final parts = item.time!.split(':');

        if (parts.length >= 2) {
          hour = int.tryParse(parts[0]) ?? 23;
          minute = int.tryParse(parts[1]) ?? 59;
        }
      }

      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    }

    return parse(a).compareTo(parse(b));
  });

  return upcoming.take(3).toList();
}
}