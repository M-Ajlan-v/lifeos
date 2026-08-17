import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/hte_provider.dart';

import '../add_edit_todo_screen.dart';

class TodoTile extends StatelessWidget {
  final TodosEvent item;

  const TodoTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HteProvider?>();

    final hasDescription =
        item.description != null &&
        item.description!.isNotEmpty;

    final hasReminder =
        item.notificationEnabled == 1 &&
        item.date != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTodoScreen(
                existing: item,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: AppTheme.violetSoft,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: AppTheme.surfaceGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.glassBorderStrong,
            ),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // TODO ICON
              // =========================================================
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.violetSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.violet.withOpacity(0.15),
                  ),
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  color: AppTheme.violetBright,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              // =========================================================
              // TODO INFORMATION
              // =========================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
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
                        item.description!,
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

                    if (hasReminder) ...[
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
                              Icons.notifications_active_outlined,
                              color: AppTheme.orangeBright,
                              size: 13,
                            ),

                            const SizedBox(width: 5),

                            Flexible(
                              child: Text(
                                '${item.date} ${item.time ?? ''}',
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
                  _TodoActionButton(
                    icon: Icons.check_rounded,
                    color: AppTheme.income,
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
                                    .check_circle_outline_rounded,
                                color: AppTheme.income,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Complete Todo',
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
                            'Mark as completed and delete?',
                            style: TextStyle(
                              color:
                                  AppTheme.textSecondary,
                              fontFamily: 'Outfit',
                              fontSize: 13,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(
                                ctx,
                                false,
                              ),
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
                              onPressed: () =>
                                  Navigator.pop(
                                ctx,
                                true,
                              ),
                              style:
                                  TextButton.styleFrom(
                                foregroundColor:
                                    AppTheme.income,
                              ),
                              child: const Text(
                                'Complete',
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
                        await provider.completeTodo(
                          item.id,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 7),

                  _TodoActionButton(
                    icon: Icons.delete_outline_rounded,
                    color: AppTheme.expense,
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
                                  'Delete Todo',
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
                            'Are you sure?',
                            style: TextStyle(
                              color:
                                  AppTheme.textSecondary,
                              fontFamily: 'Outfit',
                              fontSize: 13,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(
                                ctx,
                                false,
                              ),
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
                              onPressed: () =>
                                  Navigator.pop(
                                ctx,
                                true,
                              ),
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
                        await provider.deleteTodoEvent(
                          item.id,
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

class _TodoActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TodoActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
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
    );
  }
}