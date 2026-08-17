import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class ContactFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ContactFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: selected ? AppTheme.violetGradient : null,
          color: selected ? null : AppTheme.cardElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppTheme.violetBright.withOpacity(0.30)
                : AppTheme.glassBorder,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.violet.withOpacity(0.18),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 9,
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : AppTheme.textSecondary,
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}