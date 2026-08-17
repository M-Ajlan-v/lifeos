import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class TransferEmpty extends StatelessWidget {
  const TransferEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppTheme.violetSoft,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.glassBorderStrong,
                      ),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: AppTheme.violetBright,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'No transfers yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Transfers between your accounts will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontFamily: 'Outfit',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}