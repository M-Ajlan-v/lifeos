import 'package:flutter/material.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class OpeningTypeSelector extends StatelessWidget {
  final String? openingType;
  final ValueChanged<String?> onChanged;

  const OpeningTypeSelector({
    super.key,
    required this.openingType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isGive = openingType == ContactBalanceType.willGet;
    final isGot = openingType == ContactBalanceType.willGive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opening Type *',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: _TypeOption(
                label: 'Give',
                icon: Icons.north_east_rounded,
                selected: isGive,
                color: AppTheme.expense,
                onTap: () {
                  onChanged(
                    isGive ? null : ContactBalanceType.willGet,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TypeOption(
                label: 'Got',
                icon: Icons.south_west_rounded,
                selected: isGot,
                color: AppTheme.income,
                onTap: () {
                  onChanged(
                    isGot ? null : ContactBalanceType.willGive,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      height: 58,
      decoration: BoxDecoration(
        color: selected
            ? color.withOpacity(0.12)
            : AppTheme.cardElevated,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: selected
              ? color.withOpacity(0.45)
              : AppTheme.glassBorder,
          width: selected ? 1.2 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: color.withOpacity(0.14),
                  blurRadius: 16,
                  spreadRadius: -4,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: selected ? 1.08 : 1,
                child: Icon(
                  icon,
                  size: 19,
                  color: selected
                      ? color
                      : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}