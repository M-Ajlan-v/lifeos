import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/database/app_database.dart';

class TotalBalanceCard extends StatefulWidget {
  const TotalBalanceCard({
    super.key,
  });

  @override
  State<TotalBalanceCard> createState() =>
      _TotalBalanceCardState();
}

class _TotalBalanceCardState
    extends State<TotalBalanceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _effectController;

  @override
  void initState() {
    super.initState();

    _effectController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 5200,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _effectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider =
        context.watch<AccountProvider?>();

    if (accountProvider == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<Account>>(
      stream: accountProvider.accountsStream,
      builder: (context, snapshot) {
        final accounts =
            snapshot.data ?? [];

        final total = accounts.fold<int>(
          0,
          (sum, a) =>
              sum + a.openingBalance,
        );

        return AnimatedBuilder(
          animation: _effectController,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (
                context,
                constraints,
              ) {
                final progress =
                    _effectController.value;

                final sheenPosition =
                    -160 +
                    ((constraints.maxWidth + 320) *
                        progress);

                return Container(
                  width: double.infinity,

                  // =====================================================
                  // ANIMATED METALLIC OUTER EDGE
                  // =====================================================
                  padding: const EdgeInsets.all(
                    1.2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(27),
                    gradient: SweepGradient(
                      transform:
                          GradientRotation(
                        progress *
                            math.pi *
                            2,
                      ),
                      colors: [
                        Colors.white
                            .withOpacity(0.08),
                        AppTheme.violetBright
                            .withOpacity(0.40),
                        Colors.white
                            .withOpacity(0.12),
                        AppTheme.orangeBright
                            .withOpacity(0.35),
                        Colors.white
                            .withOpacity(0.08),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.violet
                            .withOpacity(0.16),
                        blurRadius: 30,
                        offset:
                            const Offset(
                          0,
                          14,
                        ),
                      ),
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.34),
                        blurRadius: 24,
                        offset:
                            const Offset(
                          0,
                          12,
                        ),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      26,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.88,

                      child: Stack(
                        children: [
                          // =================================================
                          // CARD BASE
                          // =================================================
                          Positioned.fill(
                            child: Container(
                              decoration:
                                  const BoxDecoration(
                                gradient:
                                    LinearGradient(
                                  begin:
                                      Alignment
                                          .topLeft,
                                  end:
                                      Alignment
                                          .bottomRight,
                                  colors: [
                                    Color(
                                      0xFF5122A8,
                                    ),
                                    Color(
                                      0xFF7437DA,
                                    ),
                                    Color(
                                      0xFFC34A60,
                                    ),
                                    Color(
                                      0xFFE46724,
                                    ),
                                  ],
                                  stops: [
                                    0,
                                    0.36,
                                    0.72,
                                    1,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // =================================================
                          // DARK DEPTH OVERLAY
                          // =================================================
                          Positioned.fill(
                            child: Container(
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    LinearGradient(
                                  begin:
                                      Alignment
                                          .topCenter,
                                  end:
                                      Alignment
                                          .bottomCenter,
                                  colors: [
                                    Colors.black
                                        .withOpacity(
                                      0.02,
                                    ),
                                    Colors.black
                                        .withOpacity(
                                      0.19,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // =================================================
                          // LARGE GLASS RING - TOP RIGHT
                          // =================================================
                          Positioned(
                            right: -72,
                            top: -94,
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape.circle,
                                border:
                                    Border.all(
                                  color:
                                      Colors.white
                                          .withOpacity(
                                    0.08,
                                  ),
                                  width: 24,
                                ),
                              ),
                            ),
                          ),

                          // =================================================
                          // SECOND RING
                          // =================================================
                          Positioned(
                            right: -23,
                            top: -35,
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape.circle,
                                border:
                                    Border.all(
                                  color:
                                      Colors.white
                                          .withOpacity(
                                    0.055,
                                  ),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),

                          // =================================================
                          // ABSTRACT CARD CIRCLES
                          // =================================================
                          Positioned(
                            right: 17,
                            bottom: 14,
                            child: Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    color:
                                        Colors.white
                                            .withOpacity(
                                      0.12,
                                    ),
                                    border:
                                        Border.all(
                                      color:
                                          Colors.white
                                              .withOpacity(
                                        0.10,
                                      ),
                                    ),
                                  ),
                                ),

                                Transform.translate(
                                  offset:
                                      const Offset(
                                    -12,
                                    0,
                                  ),
                                  child:
                                      Container(
                                    width: 35,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      shape:
                                          BoxShape
                                              .circle,
                                      color: Colors
                                          .black
                                          .withOpacity(
                                        0.10,
                                      ),
                                      border:
                                          Border.all(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                          0.10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // =================================================
                          // SUBTLE REFLECTIVE LINES
                          // =================================================
                          Positioned(
                            left: -20,
                            bottom: 42,
                            child:
                                Transform.rotate(
                              angle: -0.15,
                              child: Container(
                                width: 210,
                                height: 1,
                                color: Colors.white
                                    .withOpacity(
                                  0.055,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            left: 20,
                            bottom: 32,
                            child:
                                Transform.rotate(
                              angle: -0.15,
                              child: Container(
                                width: 130,
                                height: 1,
                                color: Colors.white
                                    .withOpacity(
                                  0.035,
                                ),
                              ),
                            ),
                          ),

                          // =================================================
                          // MOVING HOLOGRAPHIC SHEEN
                          // =================================================
                          Positioned(
                            left: sheenPosition,
                            top: -100,
                            bottom: -100,
                            child:
                                IgnorePointer(
                              child:
                                  Transform.rotate(
                                angle: -0.28,
                                child:
                                    Container(
                                  width: 85,
                                  decoration:
                                      BoxDecoration(
                                    gradient:
                                        LinearGradient(
                                      begin:
                                          Alignment
                                              .topCenter,
                                      end:
                                          Alignment
                                              .bottomCenter,
                                      colors: [
                                        Colors
                                            .transparent,
                                        Colors
                                            .white
                                            .withOpacity(
                                          0.015,
                                        ),
                                        Colors
                                            .white
                                            .withOpacity(
                                          0.11,
                                        ),
                                        AppTheme
                                            .lavender
                                            .withOpacity(
                                          0.075,
                                        ),
                                        Colors
                                            .white
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
                          ),

                          // =================================================
                          // CONTENT
                          // =================================================
                          Padding(
                            padding:
                                const EdgeInsets
                                    .fromLTRB(
                              19,
                              18,
                              19,
                              17,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                // =============================================
                                // TOP
                                // =============================================
                                Row(
                                  children: [
                                    // =========================================
                                    // WALLET EMBLEM
                                    // =========================================
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                          0.11,
                                        ),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          13,
                                        ),
                                        border:
                                            Border.all(
                                          color: Colors
                                              .white
                                              .withOpacity(
                                            0.15,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors
                                                .white
                                                .withOpacity(
                                              0.04,
                                            ),
                                            blurRadius:
                                                12,
                                          ),
                                        ],
                                      ),
                                      child:
                                          Stack(
                                        alignment:
                                            Alignment
                                                .center,
                                        children: [
                                          const Icon(
                                            Icons
                                                .account_balance_wallet_rounded,
                                            color:
                                                Colors
                                                    .white,
                                            size: 20,
                                          ),

                                          // tiny moving reflection
                                          Positioned(
                                            top:
                                                7 +
                                                (progress *
                                                    8),
                                            right:
                                                7,
                                            child:
                                                Container(
                                              width:
                                                  4,
                                              height:
                                                  4,
                                              decoration:
                                                  BoxDecoration(
                                                shape:
                                                    BoxShape
                                                        .circle,
                                                color: Colors
                                                    .white
                                                    .withOpacity(
                                                  0.35,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 11,
                                    ),

                                    const Expanded(
                                      child: Text(
                                        'Total Balance',
                                        style:
                                            TextStyle(
                                          color:
                                              Colors
                                                  .white70,
                                          fontFamily:
                                              'Outfit',
                                          fontSize:
                                              13,
                                          fontWeight:
                                              FontWeight
                                                  .w500,
                                        ),
                                      ),
                                    ),

                                    // =========================================
                                    // ACCOUNT COUNT
                                    // =========================================
                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal:
                                            10,
                                        vertical:
                                            5,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .black
                                            .withOpacity(
                                          0.13,
                                        ),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          20,
                                        ),
                                        border:
                                            Border.all(
                                          color: Colors
                                              .white
                                              .withOpacity(
                                            0.08,
                                          ),
                                        ),
                                      ),
                                      child:
                                          Text(
                                        '${accounts.length} ${accounts.length == 1 ? 'ACCOUNT' : 'ACCOUNTS'}',
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors
                                                  .white70,
                                          fontFamily:
                                              'Outfit',
                                          fontSize:
                                              8,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                          letterSpacing:
                                              0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // =============================================
                                // LABEL
                                // =============================================
                                Text(
                                  'AVAILABLE BALANCE',
                                  style:
                                      TextStyle(
                                    color: Colors
                                        .white
                                        .withOpacity(
                                      0.55,
                                    ),
                                    fontFamily:
                                        'Outfit',
                                    fontSize: 8,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    letterSpacing:
                                        1.25,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                // =============================================
                                // AMOUNT
                                // =============================================
                                Text(
                                  '₹$total',
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
                                    fontSize: 34,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                    height: 1,
                                    letterSpacing:
                                        -0.6,
                                    shadows: [
                                      Shadow(
                                        color:
                                            Color(
                                          0x42000000,
                                        ),
                                        blurRadius:
                                            12,
                                        offset:
                                            Offset(
                                          0,
                                          4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 7,
                                ),

                                const Text(
                                  'Across all your accounts',
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white70,
                                    fontFamily:
                                        'Outfit',
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight
                                            .w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // =================================================
                          // TOP GLASS HIGHLIGHT
                          // =================================================
                          Positioned(
                            left: 20,
                            right: 20,
                            top: 0,
                            child: Container(
                              height: 1,
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    LinearGradient(
                                  colors: [
                                    Colors
                                        .transparent,
                                    Colors.white
                                        .withOpacity(
                                      0.28,
                                    ),
                                    Colors
                                        .transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}