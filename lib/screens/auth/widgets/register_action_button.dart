import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class RegisterActionButton
    extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const RegisterActionButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.buttonHeight,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(14),
        gradient:
            AppTheme.buttonGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.violet
                .withOpacity(0.26),
            blurRadius: 18,
            offset:
                const Offset(0, 8),
          ),
          BoxShadow(
            color: AppTheme.orange
                .withOpacity(0.06),
            blurRadius: 16,
            offset:
                const Offset(6, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          // =============================================
          // TOP LIGHT
          // =============================================
          Positioned(
            left: 30,
            right: 30,
            top: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(
                      0.32,
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // =============================================
          // BOTTOM DEPTH
          // =============================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(
                    bottom:
                        Radius.circular(14),
                  ),
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.topCenter,
                    end:
                        Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(
                        0.13,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: ElevatedButton(
              onPressed: onPressed,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent,
                disabledBackgroundColor:
                    Colors.transparent,
                foregroundColor:
                    Colors.white,
                disabledForegroundColor:
                    Colors.white70,
                shadowColor:
                    Colors.transparent,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Icon(
                          Icons
                              .person_add_alt_1_rounded,
                          size: 17,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Create Account',
                          style:
                              TextStyle(
                            fontFamily:
                                'Outfit',
                            fontSize: 15,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}