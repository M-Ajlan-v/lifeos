import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class GiveGotDateField extends StatelessWidget {
  final DateTime selectedDate;
  final Color accentColor;
  final VoidCallback onTap;

  const GiveGotDateField({
    super.key,
    required this.selectedDate,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: AppTheme.cardElevated,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: AppTheme.glassBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: accentColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Transaction date',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}