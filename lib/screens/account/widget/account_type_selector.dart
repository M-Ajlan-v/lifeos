import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class AccountTypeSelector extends StatelessWidget {
  final List<String> types;
  final String selectedType;
  final ValueChanged<String> onSelected;

  const AccountTypeSelector({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final selected = selectedType == type;

        return ChoiceChip(
          label: Text(
            type,
            style: TextStyle(
              color: selected
                  ? AppTheme.textPrimary
                  : AppTheme.textSecondary,
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: selected,
          onSelected: (value) {
            if (value) {
              onSelected(type);
            }
          },
          backgroundColor: AppTheme.cardElevated,
          selectedColor: AppTheme.violet,
          side: BorderSide(
            color: selected
                ? AppTheme.violetBright
                : AppTheme.cardBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          checkmarkColor: AppTheme.textPrimary,
        );
      }).toList(),
    );
  }
}