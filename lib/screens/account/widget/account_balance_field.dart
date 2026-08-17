import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class AccountBalanceField extends StatelessWidget {
  final TextEditingController controller;

  const AccountBalanceField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontFamily: 'Outfit',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Opening Balance (optional)',
        labelStyle: const TextStyle(
          color: AppTheme.textSecondary,
          fontFamily: 'Outfit',
        ),
        floatingLabelStyle: const TextStyle(
          color: AppTheme.violetBright,
          fontFamily: 'Outfit',
        ),
        prefixText: '₹ ',
        prefixStyle: const TextStyle(
          color: AppTheme.violetBright,
          fontFamily: 'Outfit',
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        filled: true,
        fillColor: AppTheme.cardElevated,
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
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}