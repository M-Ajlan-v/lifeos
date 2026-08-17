import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class TodoSaveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const TodoSaveButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient:
            AppTheme.buttonGradient,
        borderRadius:
            BorderRadius.circular(16),
        boxShadow:
            AppTheme.violetStrongGlow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius:
              BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  label == 'Update'
                      ? Icons
                          .check_circle_outline_rounded
                      : Icons
                          .add_task_rounded,
                  color: Colors.white,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontFamily:
                        'Outfit',
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}