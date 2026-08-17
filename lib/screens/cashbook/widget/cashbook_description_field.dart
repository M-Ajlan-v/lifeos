import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class CashbookDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final Color accentColor;

  const CashbookDescriptionField({
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
        fontSize: 14,
      ),
      cursorColor: accentColor,
      decoration: InputDecoration(
        labelText: 'Description (optional)',
        labelStyle: const TextStyle(
          color: AppTheme.textSecondary,
        ),
        floatingLabelStyle: TextStyle(
          color: accentColor,
        ),
        hintText: 'Add a note about this transaction',
        hintStyle: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: 12,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: Icon(
            Icons.notes_rounded,
            color: AppTheme.textSecondary,
          ),
        ),
        alignLabelWithHint: true,
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
      ),
      maxLines: 2,
    );
  }
}