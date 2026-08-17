import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/hte_provider.dart';

import '../habit_detail_screen.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HteProvider?>();

    final hasDescription =
        habit.description != null &&
        habit.description!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HabitDetailScreen(
                habit: habit,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(22),
        splashColor: AppTheme.violetSoft,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: AppTheme.surfaceGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.glassBorderStrong,
            ),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // HABIT ICON
              // =========================================================
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.purpleBlackGradient,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppTheme.violet.withOpacity(0.18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.violet.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.repeat_rounded,
                  color: AppTheme.violetBright,
                  size: 22,
                ),
              ),

              const SizedBox(width: 13),

              // =========================================================
              // HABIT INFO
              // =========================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),

                    if (hasDescription) ...[
                      const SizedBox(height: 5),
                      Text(
                        habit.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.orangeSoft,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: AppTheme.orange.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: AppTheme.orangeBright,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Daily at ${habit.time}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.orangeBright,
                                fontFamily: 'Outfit',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // =========================================================
              // ACTIONS
              // =========================================================
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HabitActionButton(
                    icon: Icons.check_rounded,
                    color: AppTheme.income,
                    tooltip: 'Mark Done today',
                    onTap: () async {
                      if (provider != null) {
                        await provider.markHabitDone(
                          habit.id,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
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

                  const SizedBox(height: 7),

                  _HabitActionButton(
                    icon: Icons.delete_outline_rounded,
                    color: AppTheme.expense,
                    tooltip: 'Delete',
                    onTap: () async {
                      final confirm =
                          await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor:
                              AppTheme.cardElevated,
                          surfaceTintColor:
                              Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(22),
                          ),
                          title: const Row(
                            children: [
                              Icon(
                                Icons
                                    .delete_outline_rounded,
                                color: AppTheme.expense,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Delete Habit',
                                  style: TextStyle(
                                    color:
                                        AppTheme.textPrimary,
                                    fontFamily: 'Outfit',
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          content: const Text(
                            'This will permanently deactivate the habit.\n'
                            'History will be kept but hidden.',
                            style: TextStyle(
                              color:
                                  AppTheme.textSecondary,
                              fontFamily: 'Outfit',
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  ctx,
                                  false,
                                );
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppTheme
                                      .textSecondary,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  ctx,
                                  true,
                                );
                              },
                              style:
                                  TextButton.styleFrom(
                                foregroundColor:
                                    AppTheme.expense,
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true &&
                          provider != null) {
                        await provider.deleteHabit(
                          habit.id,
                        );
                      }
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

class _HabitActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _HabitActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: color.withOpacity(0.16),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}