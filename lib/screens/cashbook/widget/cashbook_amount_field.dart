import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class CashbookAmountField extends StatelessWidget {
  final TextEditingController controller;
  final Color accentColor;

  const CashbookAmountField({
    super.key,
    required this.controller,
    required this.accentColor,
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
      cursorColor: accentColor,
      decoration: InputDecoration(
        labelText: 'Amount *',
        labelStyle: const TextStyle(
          color: AppTheme.textSecondary,
        ),
        floatingLabelStyle: TextStyle(
          color: accentColor,
        ),
        prefixText: '₹ ',
        prefixStyle: TextStyle(
          color: accentColor,
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          Icons.currency_rupee_rounded,
          color: accentColor,
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
          borderSide: BorderSide(
            color: accentColor,
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
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Amount is required';
        }

        final n = int.tryParse(v.trim());

        if (n == null || n <= 0) {
          return 'Enter valid amount';
        }

        return null;
      },
    );
  }
}