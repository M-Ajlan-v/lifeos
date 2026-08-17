import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class EventTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const EventTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      cursorColor: AppTheme.violetBright,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontFamily: 'Outfit',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        labelStyle: const TextStyle(
          color: AppTheme.textSecondary,
          fontFamily: 'Outfit',
          fontSize: 12,
        ),

        hintStyle: const TextStyle(
          color: AppTheme.textMuted,
          fontFamily: 'Outfit',
          fontSize: 12,
        ),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 14,
            right: 11,
          ),
          child: Container(
            width: 34,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.violetSoft,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              color: AppTheme.violetBright,
              size: 15,
            ),
          ),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 59,
          minHeight: 42,
        ),

        filled: true,
        fillColor: AppTheme.cardElevated,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
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
            width: 1.3,
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
            width: 1.3,
          ),
        ),

        errorStyle: const TextStyle(
          color: AppTheme.expense,
          fontFamily: 'Outfit',
          fontSize: 11,
        ),
      ),
    );
  }
}