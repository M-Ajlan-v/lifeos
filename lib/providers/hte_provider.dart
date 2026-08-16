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

  HteProvider({
    required this.hteService,
    required this.userId,
  }) {
    refreshAll();
  }

  Future<void> refreshAll() async {
    await hteService.processMissedHabitDays(userId);
    await hteService.syncFiredNotifications(userId);   // ← new line
    _todosEvents = await hteService.getTodosEvents(userId);
    _habits = await hteService.getActiveHabits(userId);
    _firedNotifications = await hteService.getFiredNotifications(userId);
    notifyListeners();
  }

  // ---------- Todos & Events ----------

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
    await refreshAll();
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
}