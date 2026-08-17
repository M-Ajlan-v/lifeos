import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class GiveGotAccountField extends StatelessWidget {
  final Stream<List<Account>>? accountStream;
  final Account? selectedAccount;
  final ValueChanged<Account?> onChanged;

  const GiveGotAccountField({
    super.key,
    required this.accountStream,
    required this.selectedAccount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Account>>(
      stream: accountStream,
      builder: (context, snapshot) {
        final accounts = snapshot.data ?? [];

        return DropdownButtonFormField<Account>(
          value: selectedAccount,
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
            labelText: 'Account *',
            labelStyle: const TextStyle(
              color: AppTheme.textSecondary,
            ),
            floatingLabelStyle: const TextStyle(
              color: AppTheme.violetBright,
            ),
            prefixIcon: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppTheme.textSecondary,
            ),
            filled: true,
            fillColor: AppTheme.cardElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: AppTheme.glassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: AppTheme.glassBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: AppTheme.violet,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: AppTheme.expense,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: AppTheme.expense,
              ),
            ),
          ),
          items: accounts.map((a) {
            return DropdownMenuItem<Account>(
              value: a,
              child: Text(
                '${a.name} (₹${a.openingBalance})',
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (v) =>
              v == null ? 'Select an account' : null,
        );
      },
    );
  }
}