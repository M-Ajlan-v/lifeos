import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final int index;
  final VoidCallback onTap;

  const AccountCard({
    super.key,
    required this.account,
    required this.index,
    required this.onTap,
  });

  LinearGradient _gradientForIndex() {
    const gradients = [
      AppTheme.violetOrangeGradient,
      AppTheme.violetBrightGradient,
      AppTheme.orangeBrightGradient,
      AppTheme.midnightBlueGradient,
      AppTheme.purpleBlackGradient,
      AppTheme.orangeGlowGradient,
    ];

    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final balanceColor = account.openingBalance >= 0
        ? AppTheme.income
        : AppTheme.expense;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: Colors.white.withOpacity(0.06),
        highlightColor: Colors.white.withOpacity(0.03),
        child: Container(
          height: 185,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.42),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 11),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: _gradientForIndex(),
              border: Border.all(
                color: Colors.white.withOpacity(0.20),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  // =========================================================
                  // UPPER-LEFT LIGHT
                  // =========================================================
                  Positioned(
                    left: -75,
                    top: -105,
                    child: Container(
                      width: 250,
                      height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.20),
                            Colors.white.withOpacity(0.06),
                            Colors.transparent,
                          ],
                          stops: const [
                            0.0,
                            0.45,
                            1.0,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =========================================================
                  // LARGE DECORATIVE CIRCLE
                  // Similar to the reference card's upper-right shape.
                  // =========================================================
                  Positioned(
                    right: -65,
                    top: -75,
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.025),
                        ),
                      ),
                    ),
                  ),

                  // =========================================================
                  // LOWER-RIGHT DEPTH
                  // =========================================================
                  Positioned(
                    right: -90,
                    bottom: -100,
                    child: Container(
                      width: 240,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.black.withOpacity(0.25),
                            Colors.black.withOpacity(0.08),
                            Colors.transparent,
                          ],
                          stops: const [
                            0.0,
                            0.50,
                            1.0,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =========================================================
                  // GLOSSY HIGHLIGHT
                  // =========================================================
                  Positioned(
                    left: -100,
                    top: -20,
                    child: Transform.rotate(
                      angle: -0.22,
                      child: Container(
                        width: 430,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.025),
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.025),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =========================================================
                  // TOP EDGE HIGHLIGHT
                  // =========================================================
                  Positioned(
                    left: 1,
                    right: 1,
                    top: 1,
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.28),
                            Colors.white.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =========================================================
                  // CARD CONTENT
                  // =========================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      17,
                      20,
                      17,
                    ),
                    child: Column(
                      children: [
                        // ===================================================
                        // TOP SECTION
                        // ===================================================
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // -------------------------------
                            // BALANCE
                            // -------------------------------
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CURRENT BALANCE',
                                    style: TextStyle(
                                      color:
                                          Colors.white.withOpacity(0.58),
                                      fontFamily: 'Outfit',
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${account.openingBalance}',
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: balanceColor,
                                      fontFamily: 'Outfit',
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.1,
                                      shadows: [
                                        Shadow(
                                          color: balanceColor
                                              .withOpacity(0.30),
                                          blurRadius: 9,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // -------------------------------
                            // ACCOUNT TYPE
                            // -------------------------------
                            Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 7,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(11),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.19),
        Colors.white.withOpacity(0.06),
      ],
    ),
    border: Border.all(
      color: Colors.white.withOpacity(0.16),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.14),
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Text(
    account.type,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      color: Colors.white,
      fontFamily: 'Outfit',
      fontSize: 16,
      fontWeight: FontWeight.w800,
    ),
  ),
),
                          ],
                        ),

                        // ===================================================
                        // MIDDLE SECTION
                        // ===================================================
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _CreditCardChip(),
                          ),
                        ),

                        // ===================================================
                        // BOTTOM SECTION
                        // ===================================================
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            // -------------------------------
                            // CARD HOLDER
                            // -------------------------------
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ACCOUNT NAME',
                                    style: TextStyle(
                                      color:
                                          Colors.white.withOpacity(0.48),
                                      fontFamily: 'Outfit',
                                      fontSize: 7,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    account.name.toUpperCase(),
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Outfit',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // =========================================================
                  // CONTACTLESS ICON
                  // =========================================================
                  Positioned(
                    right: 20,
                    top: 65,
                    child: Icon(
                      Icons.contactless_rounded,
                      color: Colors.white.withOpacity(0.38),
                      size: 20,
                    ),
                  ),

                  // =========================================================
                  // CARD BRANDING / DECORATION
                  // =========================================================
                  Positioned(
                    right: 20,
                    bottom: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 19,
                          height: 19,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.13),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          width: 19,
                          height: 19,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// CREDIT CARD CHIP
// ===========================================================================

class _CreditCardChip extends StatelessWidget {
  const _CreditCardChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF6D76A).withOpacity(0.95),
            const Color(0xFFC99C28).withOpacity(0.90),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ChipPainter(),
      ),
    );
  }
}

// ===========================================================================
// CHIP PATTERN
// ===========================================================================

class _ChipPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.22)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    canvas.drawLine(
      Offset(centerX, 2),
      Offset(centerX, size.height - 2),
      paint,
    );

    canvas.drawLine(
      Offset(2, centerY),
      Offset(size.width - 2, centerY),
      paint,
    );

    canvas.drawArc(
      Rect.fromLTWH(
        5,
        4,
        size.width - 10,
        size.height - 8,
      ),
      -1.57,
      3.14,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromLTWH(
        10,
        7,
        size.width - 20,
        size.height - 14,
      ),
      1.57,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}