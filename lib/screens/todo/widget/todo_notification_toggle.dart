import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class TodoNotificationToggle
    extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TodoNotificationToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: value
              ? AppTheme.violet
                  .withOpacity(0.35)
              : AppTheme.cardBorder,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: value
                  ? AppTheme.violetSoft
                  : AppTheme.surface,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              value
                  ? Icons
                      .notifications_active_rounded
                  : Icons
                      .notifications_none_rounded,
              color: value
                  ? AppTheme.violetBright
                  : AppTheme.textSecondary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable Notification',
                  style: TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Get reminded at the selected date and time',
                  style: TextStyle(
                    color: AppTheme
                        .textSecondary,
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Switch(
            value: value,
            onChanged: onChanged,
            activeColor:
                AppTheme.violetBright,
            activeTrackColor:
                AppTheme.violet
                    .withOpacity(0.35),
            inactiveThumbColor:
                AppTheme.textSecondary,
            inactiveTrackColor:
                AppTheme.surface,
          ),
        ],
      ),
    );
  }
}