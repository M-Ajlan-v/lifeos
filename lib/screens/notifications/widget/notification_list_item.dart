import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationLogData log;

  const NotificationListItem({
    super.key,
    required this.log,
  });

  IconData get _icon {
    switch (log.sourceType) {
      case 'TODO':
        return Icons.task_alt_rounded;
      case 'EVENT':
        return Icons.event_rounded;
      case 'HABIT':
        return Icons.repeat_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get _color {
    switch (log.sourceType) {
      case 'TODO':
        return AppTheme.violetBright;
      case 'EVENT':
        return AppTheme.orangeBright;
      case 'HABIT':
        return AppTheme.income;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firedAt = log.firedAt != null
        ? DateFormat(
            'dd MMM, HH:mm',
          ).format(log.firedAt!)
        : 'Unknown time';

    final title =
        log.title ?? 'Notification';

    final hasBody =
        log.body != null &&
        log.body!.isNotEmpty;

    final source =
        log.sourceType ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          // =========================================================
          // ICON
          // =========================================================
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _color.withOpacity(0.08),
              borderRadius:
                  BorderRadius.circular(10),
              border: Border.all(
                color:
                    _color.withOpacity(0.15),
              ),
            ),
            child: Icon(
              _icon,
              color: _color,
              size: 16,
            ),
          ),

          const SizedBox(width: 10),

          // =========================================================
          // CONTENT - MAXIMUM 2 ROWS
          // =========================================================
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------
                // ROW 1
                // TITLE + SOURCE
                // ---------------------------------------------------
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color:
                              AppTheme.textPrimary,
                          fontFamily:
                              'Outfit',
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ),

                    if (source.isNotEmpty) ...[
                      const SizedBox(
                        width: 8,
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              _color.withOpacity(
                            0.07,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            6,
                          ),
                          border: Border.all(
                            color:
                                _color.withOpacity(
                              0.13,
                            ),
                          ),
                        ),
                        child: Text(
                          source,
                          style: TextStyle(
                            color: _color,
                            fontFamily:
                                'Outfit',
                            fontSize: 9,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing:
                                0.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 4),

                // ---------------------------------------------------
                // ROW 2
                // BODY + TIME
                // ---------------------------------------------------
                Row(
                  children: [
                    if (hasBody)
                      Expanded(
                        child: Text(
                          log.body!,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            color: AppTheme
                                .textSecondary,
                            fontFamily:
                                'Outfit',
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w400,
                            height: 1.15,
                          ),
                        ),
                      )
                    else
                      const Spacer(),

                    const SizedBox(width: 8),

                    const Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color:
                          AppTheme.textMuted,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      firedAt,
                      maxLines: 1,
                      style:
                          const TextStyle(
                        color:
                            AppTheme.textMuted,
                        fontFamily:
                            'Outfit',
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}