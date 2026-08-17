import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/hte_provider.dart';

import '../add_edit_event_screen.dart';

class EventTile extends StatelessWidget {
  final TodosEvent item;

  const EventTile({
    super.key,
    required this.item,
  });

  bool get isPast {
    if (item.date == null || item.time == null) {
      return false;
    }

    final dt = DateTime.parse(
      '${item.date} ${item.time}',
    );

    return dt.isBefore(
      DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.read<HteProvider?>();

    final hasDescription =
        item.description != null &&
        item.description!.isNotEmpty;

    final hasDate = item.date != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isPast
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddEditEventScreen(
                      existing: item,
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
            gradient: isPast
                ? AppTheme.surfaceGradient
                : AppTheme.midnightBlueGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isPast
                  ? AppTheme.expense.withOpacity(0.16)
                  : AppTheme.glassBorderStrong,
            ),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // =========================================================
              // EVENT DATE / ICON AREA
              // =========================================================
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPast
                      ? AppTheme.expense.withOpacity(0.09)
                      : AppTheme.violetSoft,
                  borderRadius:
                      BorderRadius.circular(15),
                  border: Border.all(
                    color: isPast
                        ? AppTheme.expense
                            .withOpacity(0.15)
                        : AppTheme.violet
                            .withOpacity(0.16),
                  ),
                ),
                child: Icon(
                  isPast
                      ? Icons.history_rounded
                      : Icons.event_rounded,
                  color: isPast
                      ? AppTheme.expense
                      : AppTheme.violetBright,
                  size: 22,
                ),
              ),

              const SizedBox(width: 13),

              // =========================================================
              // EVENT INFORMATION
              // =========================================================
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isPast
                                  ? AppTheme
                                      .textSecondary
                                  : AppTheme
                                      .textPrimary,
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ),

                        if (isPast) ...[
                          const SizedBox(width: 8),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.expense
                                  .withOpacity(0.09),
                              borderRadius:
                                  BorderRadius.circular(7),
                              border: Border.all(
                                color: AppTheme.expense
                                    .withOpacity(0.15),
                              ),
                            ),
                            child: const Text(
                              'PAST',
                              style: TextStyle(
                                color: AppTheme.expense,
                                fontFamily: 'Outfit',
                                fontSize: 8,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    if (hasDescription) ...[
                      const SizedBox(height: 5),

                      Text(
                        item.description!,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isPast
                              ? AppTheme.textMuted
                              : AppTheme.textSecondary,
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],

                    if (hasDate) ...[
                      const SizedBox(height: 10),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isPast
                              ? AppTheme.expense
                                  .withOpacity(0.07)
                              : AppTheme.orangeSoft,
                          borderRadius:
                              BorderRadius.circular(9),
                          border: Border.all(
                            color: isPast
                                ? AppTheme.expense
                                    .withOpacity(0.13)
                                : AppTheme.orange
                                    .withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              isPast
                                  ? Icons
                                      .history_rounded
                                  : Icons
                                      .schedule_rounded,
                              color: isPast
                                  ? AppTheme.expense
                                  : AppTheme.orangeBright,
                              size: 13,
                            ),

                            const SizedBox(width: 5),

                            Flexible(
                              child: Text(
                                '${item.date} ${item.time ?? ''}',
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isPast
                                      ? AppTheme.expense
                                      : AppTheme
                                          .orangeBright,
                                  fontFamily:
                                      'Outfit',
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight.w600,
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
              // DELETE ACTION
              // =========================================================
              _EventDeleteButton(
                onTap: () async {
                  final confirm =
                      await showDialog<bool>(
                    context: context,
                    builder: (ctx) =>
                        AlertDialog(
                      backgroundColor:
                          AppTheme.cardElevated,
                      surfaceTintColor:
                          Colors.transparent,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),
                      ),
                      title: const Row(
                        children: [
                          Icon(
                            Icons
                                .delete_outline_rounded,
                            color:
                                AppTheme.expense,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Delete Event',
                              style: TextStyle(
                                color: AppTheme
                                    .textPrimary,
                                fontFamily:
                                    'Outfit',
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
                              fontFamily:
                                  'Outfit',
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
                              fontFamily:
                                  'Outfit',
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
                    await provider
                        .deleteTodoEvent(
                      item.id,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventDeleteButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _EventDeleteButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.expense.withOpacity(0.08),
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
              color:
                  AppTheme.expense.withOpacity(
                0.16,
              ),
            ),
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: AppTheme.expense,
            size: 18,
          ),
        ),
      ),
    );
  }
}