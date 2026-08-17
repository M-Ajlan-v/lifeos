import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class LoginTextField
    extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)?
      validator;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontFamily: 'Outfit',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,

        filled: true,

        fillColor:
            Colors.white.withOpacity(
          0.025,
        ),

        prefixIcon:
            Container(
          margin:
              const EdgeInsets.only(
            left: 8,
            right: 7,
            top: 8,
            bottom: 8,
          ),
          width: 38,
          height: 38,
          decoration:
              BoxDecoration(
            color: AppTheme.violet
                .withOpacity(
              0.075,
            ),
            borderRadius:
                BorderRadius.circular(
              10,
            ),
            border:
                Border.all(
              color: AppTheme
                  .violetBright
                  .withOpacity(
                0.10,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: AppTheme
                .violetBright,
            size: 18,
          ),
        ),

        prefixIconConstraints:
            const BoxConstraints(
          minWidth: 54,
          minHeight: 50,
        ),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color: AppTheme
                .glassBorderStrong,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color: AppTheme
                .glassBorderStrong,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                AppTheme.violetBright,
            width: 1.4,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                AppTheme.expense,
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                AppTheme.expense,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}