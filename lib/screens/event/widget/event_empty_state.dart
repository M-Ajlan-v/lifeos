import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class EventEmptyState extends StatelessWidget {
  const EventEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient:
                    AppTheme.midnightBlueGradient,
                borderRadius:
                    BorderRadius.circular(25),
                border: Border.all(
                  color:
                      AppTheme.glassBorderStrong,
                ),
                boxShadow:
                    AppTheme.violetGlow,
              ),
              child: const Icon(
                Icons.event_available_rounded,
                color:
                    AppTheme.violetBright,
                size: 35,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No events yet',
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
              'Create events and keep track of what is coming up.',
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