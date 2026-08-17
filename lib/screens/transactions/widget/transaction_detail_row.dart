import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class TransactionDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const TransactionDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  IconData _iconForLabel() {
    switch (label) {
      case 'Transaction Type':
        return Icons.swap_vert_rounded;
      case 'Amount':
        return Icons.currency_rupee_rounded;
      case 'From Account':
        return Icons.account_balance_wallet_outlined;
      case 'To Account':
        return Icons.account_balance_wallet_rounded;
      case 'Account':
        return Icons.account_balance_wallet_outlined;
      case 'Transaction Date':
        return Icons.calendar_today_outlined;
      case 'Contact Name':
        return Icons.person_outline_rounded;
      case 'Contact Phone':
        return Icons.phone_outlined;
      case 'Category':
        return Icons.category_outlined;
      case 'Description':
        return Icons.notes_rounded;
      case 'Created At':
        return Icons.schedule_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.violetSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppTheme.violetBright,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}