import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class HabitDoneButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HabitDoneButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: AppTheme.emeraldGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.income.withOpacity(0.20),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                'Mark Done for Today',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}