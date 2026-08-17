import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class LifeOSWordmark extends StatelessWidget {
  final Animation<double> glowAnimation;

  const LifeOSWordmark({
    super.key,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (context, child) {
        final glow = glowAnimation.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 175 + (glow * 30),
              height: 70 + (glow * 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.violet.withOpacity(
                      0.12 + glow * 0.05,
                    ),
                    blurRadius: 50 + glow * 15,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: AppTheme.orange.withOpacity(
                      0.07 + glow * 0.035,
                    ),
                    blurRadius: 45 + glow * 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.violet,
                        AppTheme.violetBright,
                        AppTheme.lavender,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Life',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 47,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.8,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ),

                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.orange,
                        AppTheme.orangeBright,
                        AppTheme.amber,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'OS',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 47,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.8,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}