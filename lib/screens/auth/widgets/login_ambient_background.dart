import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class LoginAmbientBackground
    extends StatelessWidget {
  final Animation<double> animation;

  const LoginAmbientBackground({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (
        context,
        child,
      ) {
        final value =
            animation.value;

        final wave = math.sin(
          value *
              math.pi *
              2,
        );

        final wave2 = math.cos(
          value *
              math.pi *
              2,
        );

        return Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(
                color:
                    AppTheme.background,
              ),
            ),

            // =============================================
            // VIOLET DEPTH LIGHT
            // =============================================
            Positioned(
              top:
                  -190 +
                  (wave * 18),
              right:
                  -160 +
                  (wave2 * 14),
              child:
                  IgnorePointer(
                child: Container(
                  width: 430,
                  height: 430,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    gradient:
                        RadialGradient(
                      colors: [
                        AppTheme
                            .violetBright
                            .withOpacity(
                          0.15,
                        ),
                        AppTheme.violet
                            .withOpacity(
                          0.055,
                        ),
                        Colors
                            .transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // =============================================
            // ORANGE DEPTH LIGHT
            // =============================================
            Positioned(
              bottom:
                  -200 +
                  (wave2 * 15),
              left:
                  -180 +
                  (wave * 12),
              child:
                  IgnorePointer(
                child: Container(
                  width: 420,
                  height: 420,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    gradient:
                        RadialGradient(
                      colors: [
                        AppTheme.orange
                            .withOpacity(
                          0.095,
                        ),
                        AppTheme.orange
                            .withOpacity(
                          0.025,
                        ),
                        Colors
                            .transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // =============================================
            // CENTER VIOLET HAZE
            // =============================================
            Positioned(
              left:
                  -110 +
                  (wave2 * 10),
              top: MediaQuery.of(
                        context,
                      ).size.height *
                      0.37 +
                  (wave * 8),
              child:
                  IgnorePointer(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    gradient:
                        RadialGradient(
                      colors: [
                        AppTheme.violet
                            .withOpacity(
                          0.045,
                        ),
                        Colors
                            .transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // =============================================
            // SUBTLE TOP EDGE LIGHT
            // =============================================
            Positioned(
              top: 0,
              left: 30,
              right: 30,
              child: Container(
                height: 1,
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppTheme
                          .violetBright
                          .withOpacity(
                        0.14,
                      ),
                      AppTheme.orange
                          .withOpacity(
                        0.08,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}