import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.glassBorder,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.violetSoft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: AppTheme.violetBright,
                size: 21,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontFamily: 'Outfit',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (subtitle != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SOON',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontFamily: 'Outfit',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}