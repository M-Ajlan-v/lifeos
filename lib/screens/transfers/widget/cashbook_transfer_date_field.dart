import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class CashbookTransferDateField extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const CashbookTransferDateField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.cardElevated,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 68,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.cardBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.violetSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppTheme.violetBright,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: 'Outfit',
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}