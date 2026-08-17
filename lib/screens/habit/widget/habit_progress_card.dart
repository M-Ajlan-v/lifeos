import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class HabitProgressCard
    extends StatelessWidget {
  final double completionPercent;
  final String reminderTime;

  const HabitProgressCard({
    super.key,
    required this.completionPercent,
    required this.reminderTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient:
            AppTheme.purpleBlackGradient,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color:
              AppTheme.glassBorderStrong,
        ),
        boxShadow:
            AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme
                  .glassSurface,
              border: Border.all(
                color: AppTheme
                    .violetBright
                    .withOpacity(0.30),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.violet
                      .withOpacity(0.18),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${completionPercent.toStringAsFixed(0)}%',
                style:
                    const TextStyle(
                  color: AppTheme
                      .textPrimary,
                  fontFamily:
                      'Outfit',
                  fontSize: 19,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Completion Rate',
                  style:
                      TextStyle(
                    color: AppTheme
                        .textPrimary,
                    fontFamily:
                        'Outfit',
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                    height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .schedule_rounded,
                      color: AppTheme
                          .orangeBright,
                      size: 15,
                    ),

                    const SizedBox(
                        width: 6),

                    Expanded(
                      child: Text(
                        'Daily reminder at $reminderTime',
                        style:
                            const TextStyle(
                          color: AppTheme
                              .textSecondary,
                          fontFamily:
                              'Outfit',
                          fontSize: 11,
                        ),
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