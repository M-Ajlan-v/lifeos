import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';

class CashbookTransferAccountField extends StatelessWidget {
  final String label;
  final Account? value;
  final List<Account> accounts;
  final ValueChanged<Account?> onChanged;
  final FormFieldValidator<Account>? validator;

  const CashbookTransferAccountField({
    super.key,
    required this.label,
    required this.value,
    required this.accounts,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Account>(
      value: value,
      dropdownColor: AppTheme.cardElevated,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppTheme.textSecondary,
      ),
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontFamily: 'Outfit',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppTheme.textSecondary,
          fontFamily: 'Outfit',
        ),
        floatingLabelStyle: const TextStyle(
          color: AppTheme.violetBright,
          fontFamily: 'Outfit',
        ),
        filled: true,
        fillColor: AppTheme.cardElevated,
        prefixIcon: const Icon(
          Icons.account_balance_wallet_rounded,
          color: AppTheme.violetBright,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.cardBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.cardBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.violetBright,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.expense,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.expense,
            width: 1.4,
          ),
        ),
        errorStyle: const TextStyle(
          color: AppTheme.expense,
          fontFamily: 'Outfit',
        ),
      ),
      items: accounts.map((a) {
        return DropdownMenuItem<Account>(
          value: a,
          child: Text(
            '${a.name} (₹${a.openingBalance})',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}