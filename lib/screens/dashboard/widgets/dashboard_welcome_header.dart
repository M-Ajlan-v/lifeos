import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class DashboardWelcomeHeader extends StatefulWidget {
  final String userName;

  const DashboardWelcomeHeader({
    super.key,
    required this.userName,
  });

  @override
  State<DashboardWelcomeHeader> createState() =>
      _DashboardWelcomeHeaderState();
}

class _DashboardWelcomeHeaderState
    extends State<DashboardWelcomeHeader>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _ambientController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // =========================================================
    // ENTRANCE
    // =========================================================
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 650,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(
        0,
        0.12,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    // =========================================================
    // AMBIENT ANIMATION
    // =========================================================
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 4200,
      ),
    );

    _entranceController.forward();
    _ambientController.repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ambientController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedBuilder(
          animation: _ambientController,
          builder: (context, child) {
            final value =
                _ambientController.value;

            final wave =
                math.sin(
                  value * math.pi * 2,
                );

            final wave2 =
                math.cos(
                  value * math.pi * 2,
                );

            return SizedBox(
              width: double.infinity,
              height: 88,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  // =================================================
                  // SOFT VIOLET AMBIENT LIGHT
                  // NO CARD / NO CONTAINER BACKGROUND
                  // =================================================
                  Positioned(
                    left: -25 + (wave * 5),
                    top: -45 + (wave2 * 4),
                    child: IgnorePointer(
                      child: Container(
                        width: 145,
                        height: 145,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.violetBright
                                  .withOpacity(
                                0.13,
                              ),
                              AppTheme.violet
                                  .withOpacity(
                                0.055,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // SMALL ORANGE LIGHT
                  // =================================================
                  Positioned(
                    right: 10 + (wave2 * 6),
                    top: 3 + (wave * 3),
                    child: IgnorePointer(
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.orange
                                  .withOpacity(
                                0.07,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // MAIN CONTENT
                  // =================================================
                  Row(
                    children: [
                      // =================================================
                      // FLOATING IOS-LIKE PROFILE
                      // =================================================
                      Transform.translate(
                        offset: Offset(
                          0,
                          wave * 1.5,
                        ),
                        child: Transform.scale(
                          scale:
                              1 +
                              (wave * 0.015),
                          child: Stack(
                            clipBehavior:
                                Clip.none,
                            children: [
                              // GLOW
                              Positioned.fill(
                                child:
                                    Transform.scale(
                                  scale: 1.22,
                                  child: Container(
                                    decoration:
                                        BoxDecoration(
                                      shape:
                                          BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme
                                              .violetBright
                                              .withOpacity(
                                            0.17,
                                          ),
                                          blurRadius:
                                              24,
                                          spreadRadius:
                                              2,
                                        ),
                                        BoxShadow(
                                          color: AppTheme
                                              .orange
                                              .withOpacity(
                                            0.07,
                                          ),
                                          blurRadius:
                                              18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // GRADIENT BORDER
                              Container(
                                width: 58,
                                height: 58,
                                padding:
                                    const EdgeInsets.all(
                                  2,
                                ),
                                decoration:
                                    const BoxDecoration(
                                  shape:
                                      BoxShape.circle,
                                  gradient:
                                      AppTheme
                                          .violetOrangeGradient,
                                ),
                                child: Container(
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    color: AppTheme
                                        .backgroundSecondary,
                                    border:
                                        Border.all(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        0.08,
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    alignment:
                                        Alignment.center,
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
                                                  .violet
                                                  .withOpacity(
                                                0.17,
                                              ),
                                              Colors
                                                  .transparent,
                                            ],
                                          ),
                                        ),
                                      ),

                                      const Icon(
                                        Icons
                                            .person_rounded,
                                        color:
                                            AppTheme
                                                .textPrimary,
                                        size: 26,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // =================================================
                              // LIVE DOT
                              // =================================================
                              Positioned(
                                right: 0,
                                bottom: 2,
                                child: Container(
                                  width: 13,
                                  height: 13,
                                  padding:
                                      const EdgeInsets
                                          .all(
                                    2.5,
                                  ),
                                  decoration:
                                      const BoxDecoration(
                                    color: AppTheme
                                        .background,
                                    shape:
                                        BoxShape.circle,
                                  ),
                                  child: Container(
                                    decoration:
                                        BoxDecoration(
                                      color: AppTheme
                                          .income,
                                      shape:
                                          BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme
                                              .income
                                              .withOpacity(
                                            0.50,
                                          ),
                                          blurRadius:
                                              7,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      // =================================================
                      // TEXT
                      // =================================================
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // =============================================
                            // WELCOME
                            // =============================================
                            Row(
                              children: [
                                const Text(
                                  'Welcome back',
                                  style:
                                      TextStyle(
                                    color: AppTheme
                                        .textSecondary,
                                    fontFamily:
                                        'Outfit',
                                    fontSize:
                                        13,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                    letterSpacing:
                                        0.1,
                                  ),
                                ),

                                const SizedBox(
                                  width: 5,
                                ),

                                Transform.rotate(
                                  angle:
                                      wave *
                                      0.07,
                                  child:
                                      Transform.translate(
                                    offset:
                                        Offset(
                                      0,
                                      -wave *
                                          1.2,
                                    ),
                                    child:
                                        const Text(
                                      '👋',
                                      style:
                                          TextStyle(
                                        fontSize:
                                            15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 2,
                            ),

                            // =============================================
                            // ANIMATED GRADIENT USERNAME
                            // =============================================
                            ShaderMask(
                              blendMode:
                                  BlendMode.srcIn,
                              shaderCallback:
                                  (bounds) {
                                final shift =
                                    wave * 0.20;

                                return LinearGradient(
                                  begin:
                                      Alignment(
                                    -1 + shift,
                                    0,
                                  ),
                                  end:
                                      Alignment(
                                    1 + shift,
                                    0,
                                  ),
                                  colors:
                                      const [
                                    AppTheme
                                        .textPrimary,
                                    AppTheme
                                        .textPrimary,
                                    AppTheme
                                        .violetBright,
                                    AppTheme
                                        .lavender,
                                    AppTheme
                                        .amberLight,
                                  ],
                                  stops:
                                      const [
                                    0,
                                    0.35,
                                    0.62,
                                    0.82,
                                    1,
                                  ],
                                ).createShader(
                                  bounds,
                                );
                              },
                              child: Text(
                                widget.userName,
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontFamily:
                                      'Outfit',
                                  fontSize: 23,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                  height: 1.15,
                                  letterSpacing:
                                      -0.35,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            // =============================================
                            // IOS-STYLE THIN ACCENT
                            // =============================================
                            Row(
                              children: [
                                Container(
                                  width:
                                      27 +
                                      ((wave + 1) *
                                          4),
                                  height: 2,
                                  decoration:
                                      BoxDecoration(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                    gradient:
                                        AppTheme
                                            .violetOrangeGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme
                                            .violetBright
                                            .withOpacity(
                                          0.28,
                                        ),
                                        blurRadius:
                                            7,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  width: 5,
                                ),

                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    color: AppTheme
                                        .orangeBright,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme
                                            .orangeBright
                                            .withOpacity(
                                          0.45,
                                        ),
                                        blurRadius:
                                            6,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      // =================================================
                      // FLOATING SPARKLE — NO BUTTON / NO CARD
                      // =================================================
                      Transform.translate(
                        offset: Offset(
                          0,
                          wave2 * 3,
                        ),
                        child: Transform.rotate(
                          angle:
                              value *
                              math.pi *
                              0.08,
                          child: ShaderMask(
                            blendMode:
                                BlendMode.srcIn,
                            shaderCallback:
                                (bounds) {
                              return const LinearGradient(
                                colors: [
                                  AppTheme
                                      .violetBright,
                                  AppTheme
                                      .lavender,
                                  AppTheme
                                      .orangeBright,
                                ],
                              ).createShader(
                                bounds,
                              );
                            },
                            child: Icon(
                              Icons
                                  .auto_awesome_rounded,
                              color:
                                  Colors.white,
                              size:
                                  20 +
                                  (wave *
                                      0.6),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}