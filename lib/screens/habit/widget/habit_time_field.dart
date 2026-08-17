import 'package:flutter/material.dart';

import 'package:lifeos/constants/theme/app_theme.dart';

class HabitTimeField
    extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const HabitTimeField({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.cardElevated,
      borderRadius:
          BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color:
                  AppTheme.cardBorder,
            ),
            boxShadow:
                AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      AppTheme.orangeSoft,
                  borderRadius:
                      BorderRadius.circular(13),
                  border: Border.all(
                    color: AppTheme.orange
                        .withOpacity(0.14),
                  ),
                ),
                child: const Icon(
                  Icons
                      .schedule_rounded,
                  color:
                      AppTheme.orangeBright,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reminder Time',
                      style: TextStyle(
                        color:
                            AppTheme.textMuted,
                        fontFamily:
                            'Outfit',
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      value,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:
                            AppTheme.textPrimary,
                        fontFamily:
                            'Outfit',
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color:
                      AppTheme.surface,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons
                      .keyboard_arrow_down_rounded,
                  color:
                      AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}