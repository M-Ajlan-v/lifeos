import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class CashbookTransferDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const CashbookTransferDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 2,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontFamily: 'Outfit',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: 'Description (optional)',
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
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: Icon(
            Icons.notes_rounded,
            color: AppTheme.violetBright,
            size: 20,
          ),
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
      ),
    );
  }
}