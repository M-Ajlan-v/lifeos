import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class NotificationEmptyState
    extends StatelessWidget {
  const NotificationEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
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
                    AppTheme.violetGlow,
              ),
              child: const Icon(
                Icons
                    .notifications_none_rounded,
                color:
                    AppTheme.violetBright,
                size: 33,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No notifications yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    AppTheme.textPrimary,
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Notifications from your tasks, events and habits will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    AppTheme.textSecondary,
                fontFamily: 'Outfit',
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}