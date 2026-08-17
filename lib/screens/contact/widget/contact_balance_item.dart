import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class ContactBalanceItem extends StatelessWidget {
  final String title;
  final dynamic amount;
  final Color color;

  const ContactBalanceItem({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.violetGlowGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 22,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₹$amount',
            style: TextStyle(
              color: color,
              fontFamily: 'Outfit',
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}