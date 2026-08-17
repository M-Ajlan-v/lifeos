import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class LoginBrandMark
    extends StatelessWidget {
  final Animation<double> animation;

  const LoginBrandMark({
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

        return Row(
          children: [
            // =============================================
            // 3D EMBLEM
            // =============================================
            Transform(
              alignment:
                  Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(
                      3,
                      2,
                      0.0012,
                    )
                    ..rotateX(
                      -0.05 +
                          wave *
                              0.018,
                    )
                    ..rotateY(
                      wave *
                          0.075,
                    ),
              child:
                  Stack(
                clipBehavior:
                    Clip.none,
                alignment:
                    Alignment.center,
                children: [
                  // =========================================
                  // DEPTH SHADOW
                  // =========================================
                  Positioned(
                    bottom: -8,
                    child:
                        Transform.scale(
                      scaleX:
                          0.82,
                      child:
                          Container(
                        width: 57,
                        height: 15,
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            100,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme
                                  .violetBright
                                  .withOpacity(
                                0.28,
                              ),
                              blurRadius:
                                  22,
                              spreadRadius:
                                  2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =========================================
                  // OUTER BODY
                  // =========================================
                  Container(
                    width: 68,
                    height: 68,
                    padding:
                        const EdgeInsets
                            .all(
                      2,
                    ),
                    decoration:
                        BoxDecoration(
                      gradient: AppTheme
                          .violetOrangeGradient,
                      borderRadius:
                          BorderRadius
                              .circular(
                        21,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme
                              .violet
                              .withOpacity(
                            0.32,
                          ),
                          blurRadius:
                              24,
                          offset:
                              const Offset(
                            -6,
                            9,
                          ),
                        ),
                        BoxShadow(
                          color: AppTheme
                              .orange
                              .withOpacity(
                            0.15,
                          ),
                          blurRadius:
                              20,
                          offset:
                              const Offset(
                            7,
                            6,
                          ),
                        ),
                      ],
                    ),
                    child:
                        Container(
                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          begin:
                              Alignment
                                  .topLeft,
                          end:
                              Alignment
                                  .bottomRight,
                          colors: [
                            Color(
                              0xFF292039,
                            ),
                            Color(
                              0xFF15131D,
                            ),
                            Color(
                              0xFF0C0C12,
                            ),
                          ],
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          19,
                        ),
                        border:
                            Border.all(
                          color: Colors
                              .white
                              .withOpacity(
                            0.09,
                          ),
                        ),
                      ),
                      child:
                          Stack(
                        alignment:
                            Alignment
                                .center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration:
                                BoxDecoration(
                              shape:
                                  BoxShape
                                      .circle,
                              gradient:
                                  RadialGradient(
                                colors: [
                                  AppTheme
                                      .violetBright
                                      .withOpacity(
                                    0.22,
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

                          const Icon(
                            Icons
                                .auto_awesome_rounded,
                            color:
                                Colors.white,
                            size:
                                27,
                          ),

                          // small orange depth point
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child:
                                Container(
                              width: 7,
                              height: 7,
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape
                                        .circle,
                                color:
                                    AppTheme
                                        .orangeBright,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme
                                        .orangeBright
                                        .withOpacity(
                                      0.55,
                                    ),
                                    blurRadius:
                                        8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // =========================================
                  // GLASS GLINT
                  // =========================================
                  Positioned(
                    top: 7,
                    left: 12,
                    child:
                        Transform.rotate(
                      angle: -0.35,
                      child:
                          Container(
                        width: 23,
                        height: 4,
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                          gradient:
                              LinearGradient(
                            colors: [
                              Colors.white
                                  .withOpacity(
                                0.32,
                              ),
                              Colors
                                  .transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 13,
            ),

            // =============================================
            // BRAND
            // =============================================
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  blendMode:
                      BlendMode.srcIn,
                  shaderCallback:
                      (bounds) =>
                          const LinearGradient(
                    colors: [
                      AppTheme
                          .textPrimary,
                      AppTheme
                          .violetBright,
                      AppTheme
                          .orangeBright,
                    ],
                  ).createShader(
                    bounds,
                  ),
                  child:
                      const Text(
                    'LifeOS',
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontFamily:
                          'Outfit',
                      fontSize:
                          20,
                      fontWeight:
                          FontWeight
                              .w800,
                      letterSpacing:
                          -0.25,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                const Text(
                  'YOUR PERSONAL OS',
                  style:
                      TextStyle(
                    color: AppTheme
                        .textMuted,
                    fontFamily:
                        'Outfit',
                    fontSize:
                        8,
                    fontWeight:
                        FontWeight
                            .w600,
                    letterSpacing:
                        1.25,
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