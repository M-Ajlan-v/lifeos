import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class LoginActionButton
    extends StatelessWidget {
  final Animation<double> animation;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginActionButton({
    super.key,
    required this.animation,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (
        context,
        child,
      ) {
        return LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final shineX =
                -80 +
                ((constraints.maxWidth +
                        160) *
                    animation.value);

            return Container(
              height:
                  AppTheme.buttonHeight,
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.violet
                        .withOpacity(
                      0.26,
                    ),
                    blurRadius: 18,
                    offset:
                        const Offset(
                      0,
                      8,
                    ),
                  ),
                  BoxShadow(
                    color: AppTheme.orange
                        .withOpacity(
                      0.07,
                    ),
                    blurRadius: 18,
                    offset:
                        const Offset(
                      7,
                      8,
                    ),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration:
                            const BoxDecoration(
                          gradient:
                              AppTheme
                                  .buttonGradient,
                        ),
                      ),
                    ),

                    // =========================================
                    // DARK DEPTH
                    // =========================================
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child:
                          Container(
                        height: 7,
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            begin: Alignment
                                .topCenter,
                            end: Alignment
                                .bottomCenter,
                            colors: [
                              Colors
                                  .transparent,
                              Colors.black
                                  .withOpacity(
                                0.16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // =========================================
                    // MOVING REFLECTION
                    // =========================================
                    Positioned(
                      left: shineX,
                      top: -30,
                      bottom: -30,
                      child:
                          IgnorePointer(
                        child:
                            Transform.rotate(
                          angle: -0.24,
                          child:
                              Container(
                            width: 42,
                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                colors: [
                                  Colors
                                      .transparent,
                                  Colors.white
                                      .withOpacity(
                                    0.11,
                                  ),
                                  Colors
                                      .transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child:
                          ElevatedButton(
                        onPressed:
                            onPressed,
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              Colors
                                  .transparent,
                          disabledBackgroundColor:
                              Colors
                                  .transparent,
                          foregroundColor:
                              Colors.white,
                          disabledForegroundColor:
                              Colors.white70,
                          shadowColor:
                              Colors
                                  .transparent,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2.2,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        style:
                                            TextStyle(
                                          fontFamily:
                                              'Outfit',
                                          fontSize:
                                              15,
                                          fontWeight:
                                              FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            8,
                                      ),
                                      Icon(
                                        Icons
                                            .arrow_forward_rounded,
                                        size:
                                            17,
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}