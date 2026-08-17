import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';

class UpcomingTodoCard extends StatelessWidget {
  final List<TodosEvent> todos;

  const UpcomingTodoCard({
    super.key,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    final upcoming = todos.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.purpleBlackGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.glassBorderStrong,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _TodoHeaderIcon(),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Upcoming Tasks',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (upcoming.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 14,
              ),
              child: Center(
                child: Text(
                  'No upcoming tasks',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: 'Outfit',
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...upcoming.asMap().entries.map((entry) {
              final index = entry.key;
              final todo = entry.value;

              final details = [
                if (todo.date != null) todo.date!,
                if (todo.time != null) todo.time!,
              ].join(' • ');

              return Container(
                margin: EdgeInsets.only(
                  bottom:
                      index == upcoming.length - 1 ? 0 : 8,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.035),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color:
                            AppTheme.orangeBright.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppTheme.orangeBright,
                        size: 19,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontFamily: 'Outfit',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          if (details.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              details,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontFamily: 'Outfit',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _TodoHeaderIcon extends StatelessWidget {
  const _TodoHeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppTheme.orangeSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.task_alt_rounded,
        color: AppTheme.orangeBright,
        size: 18,
      ),
    );
  }
}