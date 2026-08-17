import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lifeos/constants/theme/app_theme.dart';

class HabitCalendar extends StatelessWidget {
  final DateTime visibleMonth;
  final String Function(String date) statusForDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const HabitCalendar({
    super.key,
    required this.visibleMonth,
    required this.statusForDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(
      visibleMonth.year,
      visibleMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;

    final leadingEmpty = firstDay.weekday % 7;

    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final cellCount = rows * 7;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            14,
            16,
            14,
            18,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.075),
                AppTheme.violet.withOpacity(0.045),
                Colors.white.withOpacity(0.025),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: AppTheme.glassBorderStrong,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppTheme.violet.withOpacity(0.08),
                blurRadius: 26,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: -80,
                top: -80,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.violetBright.withOpacity(0.20),
                        AppTheme.violet.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -90,
                bottom: -120,
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.orange.withOpacity(0.07),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      _CalendarNavButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: onPreviousMonth,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            DateFormat('MMMM yyyy').format(
                              visibleMonth,
                            ),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      _CalendarNavButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: onNextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Row(
                    children: [
                      _WeekLabel('SUN'),
                      _WeekLabel('MON'),
                      _WeekLabel('TUE'),
                      _WeekLabel('WED'),
                      _WeekLabel('THU'),
                      _WeekLabel('FRI'),
                      _WeekLabel('SAT'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cellCount,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 7,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final day = index - leadingEmpty + 1;

                      if (day < 1 || day > daysInMonth) {
                        return const SizedBox();
                      }

                      final date = DateTime(
                        visibleMonth.year,
                        visibleMonth.month,
                        day,
                      );

                      final dateString =
                          DateFormat('yyyy-MM-dd').format(date);

                      final status = statusForDate(
                        dateString,
                      );

                      return _CalendarDay(
                        date: date,
                        status: status,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final DateTime date;
  final String status;

  const _CalendarDay({
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final currentDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final isFuture = currentDate.isAfter(today);

    final isToday = currentDate == today;

    final isDone =
        !isFuture &&
        status == 'DONE';

    final hasHistoryStatus =
        !isFuture &&
        status != 'DONE' &&
        status != 'PENDING' &&
        status != '—';

    final isMissed = hasHistoryStatus;

    // =========================================================
    // DONE
    // =========================================================
    if (isDone) {
      return _StatusDay(
        day: date.day,
        color: AppTheme.income,
        glowColor: AppTheme.income,
        isToday: isToday,
      );
    }

    // =========================================================
    // MISSED
    // =========================================================
    if (isMissed) {
      return _StatusDay(
        day: date.day,
        color: AppTheme.expense,
        glowColor: AppTheme.expense,
        isToday: isToday,
      );
    }

    // =========================================================
    // TODAY - PENDING / NORMAL
    // Blue border only
    // =========================================================
    if (isToday) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textPrimary,
            width: 2.3,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    // =========================================================
    // FUTURE / NO HISTORY
    // =========================================================
    return Center(
      child: Text(
        '${date.day}',
        style: TextStyle(
          color: isFuture
              ? AppTheme.textMuted
              : AppTheme.textSecondary,
          fontFamily: 'Outfit',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatusDay extends StatelessWidget {
  final int day;
  final Color color;
  final Color glowColor;
  final bool isToday;

  const _StatusDay({
    required this.day,
    required this.color,
    required this.glowColor,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.70),
            color.withOpacity(0.28),
          ],
        ),
        border: Border.all(
          color: isToday
              ? AppTheme.violetBright
              : Colors.white.withOpacity(0.16),
          width: isToday ? 2.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.26),
            blurRadius: 10,
          ),
          if (isToday)
            BoxShadow(
              color: AppTheme.textPrimary.withOpacity(0.40),
              blurRadius: 2,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            left: -8,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.13),
              ),
            ),
          ),
          Center(
            child: Text(
              '$day',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CalendarNavButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.045),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          child: Icon(
            icon,
            color: AppTheme.violetBright,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _WeekLabel extends StatelessWidget {
  final String label;

  const _WeekLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontFamily: 'Outfit',
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}