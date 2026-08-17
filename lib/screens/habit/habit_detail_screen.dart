import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';

import 'add_edit_habit_screen.dart';
import 'widget/habit_progress_card.dart';
import 'widget/habit_calendar.dart';
import 'widget/habit_done_button.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({
    super.key,
    required this.habit,
  });

  @override
  State<HabitDetailScreen> createState() =>
      _HabitDetailScreenState();
}

class _HabitDetailScreenState
    extends State<HabitDetailScreen> {
  List<HabitHistoryData> _history = [];
  bool _loading = true;

  DateTime _visibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final provider =
        context.read<HteProvider?>();

    if (provider == null) return;

    final list = await provider.getHabitHistory(
      widget.habit.id,
    );

    setState(() {
      _history = list;
      _loading = false;
    });
  }

  double get completionPercent {
    if (_history.isEmpty) return 0;

    final done = _history
        .where((h) => h.status == 'DONE')
        .length;

    final total = _history.length;

    return total == 0
        ? 0
        : (done / total) * 100;
  }

  String _statusForDate(String date) {
    final row = _history
        .where((h) => h.date == date)
        .firstOrNull;

    if (row == null) {
      final today = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());

      if (date == today) {
        return 'PENDING';
      }

      return '—';
    }

    return row.status;
  }

  void _previousMonth() {
    final previous = DateTime(
      _visibleMonth.year,
      _visibleMonth.month - 1,
    );

    final minimum =
        DateTime(2026, 1);

    if (previous.isBefore(minimum)) {
      return;
    }

    setState(() {
      _visibleMonth = previous;
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.read<HteProvider?>();

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor:
            AppTheme.background,
        surfaceTintColor:
            Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textPrimary,
            size: 19,
          ),
        ),

        title: Text(
          widget.habit.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          Padding(
            padding:
                const EdgeInsets.only(
              right: 10,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit_rounded,
                color:
                    AppTheme.violetBright,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddEditHabitScreen(
                      existing: widget.habit,
                    ),
                  ),
                ).then(
                  (_) => _loadHistory(),
                );
              },
            ),
          ),
        ],
      ),

      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color:
                    AppTheme.violetBright,
              ),
            )
          : ListView(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                110,
              ),
              children: [
                HabitProgressCard(
                  completionPercent:
                      completionPercent,
                  reminderTime:
                      widget.habit.time,
                ),

                const SizedBox(height: 16),

                HabitDoneButton(
                  onPressed: () async {
                    if (provider != null) {
                      await provider.markHabitDone(
                        widget.habit.id,
                      );

                      await _loadHistory();

                      if (mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Marked as Done for today',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),

                const SizedBox(height: 26),

                const Text(
                  'Activity',
                  style: TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Your habit consistency by day',
                  style: TextStyle(
                    color:
                        AppTheme.textSecondary,
                    fontFamily: 'Outfit',
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 14),

                HabitCalendar(
                  visibleMonth:
                      _visibleMonth,
                  statusForDate:
                      _statusForDate,
                  onPreviousMonth:
                      _previousMonth,
                  onNextMonth:
                      _nextMonth,
                ),

                const SizedBox(height: 14),

                const _CalendarLegend(),
              ],
            ),
    );
  }
}

class _CalendarLegend
    extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: const [
        _LegendItem(
          color: AppTheme.income,
          label: 'Done',
        ),
        SizedBox(width: 18),
        _LegendItem(
          color: AppTheme.expense,
          label: 'Missed',
        ),
        SizedBox(width: 18),
        _LegendItem(
          color: AppTheme.textMuted,
          label: 'No record',
        ),
      ],
    );
  }
}

class _LegendItem
    extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color:
                AppTheme.textSecondary,
            fontFamily: 'Outfit',
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}