import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class EventScheduleField
    extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const EventScheduleField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.cardElevated,

      borderRadius:
          BorderRadius.circular(16),

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(16),

        child: Container(
          padding:
              const EdgeInsets.all(13),

          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(16),

            border: Border.all(
              color: AppTheme.cardBorder,
            ),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,

                    decoration: BoxDecoration(
                      color:
                          AppTheme.violetSoft,

                      borderRadius:
                          BorderRadius.circular(9),
                    ),

                    child: Icon(
                      icon,
                      color:
                          AppTheme.violetBright,
                      size: 16,
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons
                        .keyboard_arrow_down_rounded,
                    color:
                        AppTheme.textMuted,
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 11),

              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontFamily: 'Outfit',
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w600,
                  letterSpacing: 0.7,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,

                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}