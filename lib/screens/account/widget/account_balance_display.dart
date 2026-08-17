import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class AccountBalanceDisplay extends StatelessWidget {
  final int balance;

  const AccountBalanceDisplay({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.cardBorder,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.orangeSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppTheme.orangeBright,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Text(
              'Current Balance',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '₹$balance',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}