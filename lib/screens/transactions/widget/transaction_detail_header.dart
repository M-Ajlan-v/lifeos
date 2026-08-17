import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class TransactionDetailHeader extends StatelessWidget {
  final String type;
  final String typeLabel;
  final int amount;

  const TransactionDetailHeader({
    super.key,
    required this.type,
    required this.typeLabel,
    required this.amount,
  });

  Color _accentColor() {
    switch (type) {
      case 'INCOME':
      case 'GOT':
        return AppTheme.income;

      case 'EXPENSE':
      case 'GAVE':
        return AppTheme.expense;

      case 'TRANSFER':
        return AppTheme.transfer;

      default:
        return AppTheme.violetBright;
    }
  }

  IconData _icon() {
    switch (type) {
      case 'INCOME':
        return Icons.south_west_rounded;
      case 'EXPENSE':
        return Icons.north_east_rounded;
      case 'GAVE':
        return Icons.arrow_upward_rounded;
      case 'GOT':
        return Icons.arrow_downward_rounded;
      case 'TRANSFER':
        return Icons.swap_horiz_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accent.withOpacity(0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.08),
            blurRadius: 28,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withOpacity(0.22),
              ),
            ),
            child: Icon(
              _icon(),
              color: accent,
              size: 29,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            typeLabel,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '₹$amount',
            style: TextStyle(
              color: accent,
              fontFamily: 'Outfit',
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}