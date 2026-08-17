import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class RegisterBrandMark extends StatelessWidget {
  const RegisterBrandMark({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // =============================================
            // SOFT DEPTH SHADOW
            // =============================================
            Positioned(
              left: 8,
              right: 8,
              bottom: -7,
              child: Container(
                height: 15,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.violet
                          .withOpacity(0.26),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),

            // =============================================
            // LOGO BODY
            // =============================================
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient:
                    AppTheme.violetOrangeGradient,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppTheme.violet.withOpacity(
                      0.24,
                    ),
                    blurRadius: 21,
                    offset: const Offset(
                      -5,
                      8,
                    ),
                  ),
                  BoxShadow(
                    color:
                        AppTheme.orange.withOpacity(
                      0.10,
                    ),
                    blurRadius: 18,
                    offset: const Offset(
                      6,
                      7,
                    ),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    begin: Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                    colors: [
                      Color(0xFF292039),
                      Color(0xFF17141F),
                      Color(0xFF0D0D13),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color:
                        Colors.white.withOpacity(
                      0.09,
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.violetBright
                                .withOpacity(
                              0.20,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    const Icon(
                      Icons
                          .person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 27,
                    ),

                    Positioned(
                      right: 9,
                      bottom: 9,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.orangeBright,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme
                                  .orangeBright
                                  .withOpacity(
                                0.55,
                              ),
                              blurRadius: 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =============================================
            // LIGHT REFLECTION
            // =============================================
            Positioned(
              top: 7,
              left: 11,
              child: Transform.rotate(
                angle: -0.35,
                child: Container(
                  width: 21,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(
                          0.30,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 13),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  const LinearGradient(
                colors: [
                  AppTheme.textPrimary,
                  AppTheme.violetBright,
                  AppTheme.orangeBright,
                ],
              ).createShader(bounds),
              child: const Text(
                'LifeOS',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            const SizedBox(height: 2),

            const Text(
              'BUILD YOUR PERSONAL OS',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontFamily: 'Outfit',
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}