import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';

class UpcomingEventCard extends StatelessWidget {
  final List<TodosEvent> events;

  const UpcomingEventCard({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final upcoming = events.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.midnightBlueGradient,
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
              _EventHeaderIcon(),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Upcoming Events',
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
                  'No upcoming events',
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
              final event = entry.value;

              final details = [
                if (event.date != null) event.date!,
                if (event.time != null) event.time!,
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
                            AppTheme.violetBright.withOpacity(0.11),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.event_outlined,
                        color: AppTheme.violetBright,
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
                            event.title,
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

class _EventHeaderIcon extends StatelessWidget {
  const _EventHeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppTheme.violetSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.event_rounded,
        color: AppTheme.violetBright,
        size: 18,
      ),
    );
  }
}