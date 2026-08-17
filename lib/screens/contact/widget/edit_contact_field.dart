import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class EditContactField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool alignLabelWithHint;
  final bool phoneInput;

  const EditContactField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.inputFormatters = const [],
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.maxLines = 1,
    this.alignLabelWithHint = false,
    this.phoneInput = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputFormatters = phoneInput
        ? [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ]
        : this.inputFormatters;

    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontFamily: 'Outfit',
        fontSize: 14,
      ),
      cursorColor: AppTheme.violetBright,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppTheme.textSecondary,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppTheme.violetBright,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            bottom: maxLines != null && maxLines! > 1 ? 24 : 0,
          ),
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
          ),
        ),
        filled: true,
        fillColor: AppTheme.cardElevated,
        alignLabelWithHint: alignLabelWithHint,
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
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      validator: validator,
      maxLines: maxLines,
    );
  }
}