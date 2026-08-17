import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/database/app_database.dart';

class ThisMonthCard extends StatelessWidget {
  const ThisMonthCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final txProvider =
        context.watch<TransactionProvider?>();

    if (txProvider == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<Transaction>>(
      stream: txProvider.cashbookStream,
      builder: (context, snapshot) {
        final now = DateTime.now();

        final transactions =
            (snapshot.data ?? []).where((tx) {
          return tx.transactionDate.year == now.year &&
              tx.transactionDate.month == now.month;
        }).toList();

        int income = 0;
        int expense = 0;

        for (final tx in transactions) {
          if (tx.type == 'INCOME') {
            income += tx.amount;
          } else if (tx.type == 'EXPENSE') {
            expense += tx.amount;
          }
        }

        final net = income - expense;

        return TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0,
            end: 1,
          ),
          duration: const Duration(
            milliseconds: 350,
          ),
          curve: Curves.easeOutCubic,
          builder: (
            context,
            value,
            child,
          ) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(
                  0,
                  5 * (1 - value),
                ),
                child: child,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(19),
              border: Border.all(
                color:
                    AppTheme.glassBorderStrong,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(
                    0.22,
                  ),
                  blurRadius: 18,
                  offset: const Offset(
                    0,
                    8,
                  ),
                ),
                BoxShadow(
                  color:
                      AppTheme.violet.withOpacity(
                    0.035,
                  ),
                  blurRadius: 20,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(19),
              child: Stack(
                children: [
                  // =================================================
                  // BASE
                  // =================================================
                  Positioned.fill(
                    child: Container(
                      decoration:
                          const BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end:
                              Alignment.bottomRight,
                          colors: [
                            AppTheme.cardElevated,
                            AppTheme.card,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // VIOLET LIGHT
                  // =================================================
                  Positioned(
                    left: -45,
                    top: -55,
                    child: IgnorePointer(
                      child: Container(
                        width: 115,
                        height: 115,
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
                                0.10,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // ORANGE LIGHT
                  // =================================================
                  Positioned(
                    right: -45,
                    bottom: -60,
                    child: IgnorePointer(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration:
                            BoxDecoration(
                          shape:
                              BoxShape.circle,
                          gradient:
                              RadialGradient(
                            colors: [
                              AppTheme.orange
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
                  // CONTENT
                  // =================================================
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      15,
                      13,
                      15,
                      13,
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        // =============================================
                        // HEADER
                        // =============================================
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration:
                                  BoxDecoration(
                                color: AppTheme
                                    .violetBright
                                    .withOpacity(
                                  0.10,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  9,
                                ),
                                border:
                                    Border.all(
                                  color: AppTheme
                                      .violetBright
                                      .withOpacity(
                                    0.14,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme
                                        .violetBright
                                        .withOpacity(
                                      0.08,
                                    ),
                                    blurRadius:
                                        10,
                                  ),
                                ],
                              ),
                              child:
                                  const Icon(
                                Icons
                                    .calendar_month_rounded,
                                size: 16,
                                color: AppTheme
                                    .violetBright,
                              ),
                            ),

                            const SizedBox(
                              width: 9,
                            ),

                            const Expanded(
                              child: Text(
                                'This Month',
                                style:
                                    TextStyle(
                                  color: AppTheme
                                      .textPrimary,
                                  fontFamily:
                                      'Outfit',
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.035,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  8,
                                ),
                                border:
                                    Border.all(
                                  color: AppTheme
                                      .glassBorder,
                                ),
                              ),
                              child: Text(
                                '${transactions.length} TXNS',
                                style:
                                    const TextStyle(
                                  color: AppTheme
                                      .textSecondary,
                                  fontFamily:
                                      'Outfit',
                                  fontSize: 9,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  letterSpacing:
                                      0.6,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // =============================================
                        // METRICS
                        // =============================================
                        Row(
                          children: [
                            Expanded(
                              child:
                                  _MonthItem(
                                label:
                                    'Income',
                                amount:
                                    income,
                                color:
                                    AppTheme
                                        .income,
                                icon: Icons
                                    .south_west_rounded,
                              ),
                            ),

                            const _VerticalDivider(),

                            Expanded(
                              child:
                                  _MonthItem(
                                label:
                                    'Expense',
                                amount:
                                    expense,
                                color:
                                    AppTheme
                                        .expense,
                                icon: Icons
                                    .north_east_rounded,
                              ),
                            ),

                            const _VerticalDivider(),

                            Expanded(
                              child:
                                  _MonthItem(
                                label: 'Net',
                                amount: net,
                                color: net >= 0
                                    ? AppTheme
                                        .income
                                    : AppTheme
                                        .expense,
                                icon: Icons
                                    .account_balance_wallet_outlined,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 11,
                        ),

                        // =============================================
                        // SMALL ACCENT EFFECT
                        // =============================================
                        Container(
                          height: 2,
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
                                AppTheme.income
                                    .withOpacity(
                                  0.40,
                                ),
                                AppTheme
                                    .violetBright
                                    .withOpacity(
                                  0.28,
                                ),
                                AppTheme.expense
                                    .withOpacity(
                                  0.40,
                                ),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme
                                    .violetBright
                                    .withOpacity(
                                  0.08,
                                ),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =================================================
                  // TOP LIGHT REFLECTION
                  // =================================================
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 0,
                    child: Container(
                      height: 1,
                      decoration:
                          BoxDecoration(
                        gradient:
                            LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white
                                .withOpacity(
                              0.17,
                            ),
                            Colors.transparent,
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
  }
}

class _MonthItem extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;
  final IconData icon;

  const _MonthItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration:
                    BoxDecoration(
                  color:
                      color.withOpacity(
                    0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    7,
                  ),
                  border: Border.all(
                    color:
                        color.withOpacity(
                      0.12,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          color.withOpacity(
                        0.07,
                      ),
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 13,
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color: AppTheme
                        .textSecondary,
                    fontFamily:
                        'Outfit',

                    // increased
                    fontSize: 11,

                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment:
                Alignment.centerLeft,
            child: Text(
              '₹$amount',
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontFamily: 'Outfit',

                // increased
                fontSize: 17,

                fontWeight:
                    FontWeight.w800,
                height: 1,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider
    extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 43,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end:
              Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppTheme.divider,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}