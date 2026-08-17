import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/providers/category_provider.dart';
import 'package:lifeos/database/app_database.dart';

class TopExpensesCard extends StatelessWidget {
  const TopExpensesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final txProvider =
        context.watch<TransactionProvider?>();

    final categoryProvider =
        context.watch<CategoryProvider?>();

    if (txProvider == null ||
        categoryProvider == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<Transaction>>(
      stream: txProvider.cashbookStream,
      builder: (context, txSnapshot) {
        final now = DateTime.now();

        final expenses =
            (txSnapshot.data ?? []).where((tx) {
          return tx.type == 'EXPENSE' &&
              tx.transactionDate.year == now.year &&
              tx.transactionDate.month == now.month &&
              tx.categoryId != null;
        }).toList();

        final Map<int, int> totals = {};

        for (final tx in expenses) {
          totals[tx.categoryId!] =
              (totals[tx.categoryId!] ?? 0) +
                  tx.amount;
        }

        final sorted =
            totals.entries.toList()
              ..sort(
                (a, b) =>
                    b.value.compareTo(a.value),
              );

        final top =
            sorted.take(5).toList();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(26),
            border: Border.all(
              color:
                  AppTheme.glassBorderStrong,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.34,
                ),
                blurRadius: 30,
                offset: const Offset(
                  0,
                  16,
                ),
              ),
              BoxShadow(
                color: AppTheme.expense
                    .withOpacity(0.055),
                blurRadius: 34,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(26),
            child: Stack(
              children: [
                // =============================================
                // MAIN BACKGROUND
                // =============================================
                Positioned.fill(
                  child: Container(
                    decoration:
                        const BoxDecoration(
                      gradient: LinearGradient(
                        begin:
                            Alignment.topLeft,
                        end:
                            Alignment.bottomRight,
                        colors: [
                          AppTheme.cardElevated,
                          AppTheme.card,
                          AppTheme.surfaceDeep,
                        ],
                      ),
                    ),
                  ),
                ),

                // =============================================
                // RED GLOW
                // =============================================
                Positioned(
                  right: -70,
                  top: -90,
                  child: IgnorePointer(
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,
                        gradient:
                            RadialGradient(
                          colors: [
                            AppTheme.expense
                                .withOpacity(
                              0.14,
                            ),
                            AppTheme.expense
                                .withOpacity(
                              0.035,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================
                // VIOLET GLOW
                // =============================================
                Positioned(
                  left: -80,
                  bottom: -110,
                  child: IgnorePointer(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,
                        gradient:
                            RadialGradient(
                          colors: [
                            AppTheme.violet
                                .withOpacity(
                              0.075,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================
                // CONTENT
                // =============================================
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    17,
                    17,
                    17,
                    18,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // =========================================
                      // HEADER
                      // =========================================
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                begin: Alignment
                                    .topLeft,
                                end: Alignment
                                    .bottomRight,
                                colors: [
                                  AppTheme.expense
                                      .withOpacity(
                                    0.22,
                                  ),
                                  AppTheme.expense
                                      .withOpacity(
                                    0.06,
                                  ),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                13,
                              ),
                              border:
                                  Border.all(
                                color:
                                    AppTheme.expense
                                        .withOpacity(
                                  0.20,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme
                                          .expense
                                          .withOpacity(
                                    0.12,
                                  ),
                                  blurRadius:
                                      16,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons
                                  .trending_down_rounded,
                              color:
                                  AppTheme.expense,
                              size: 21,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Top Expenses',
                                  style:
                                      TextStyle(
                                    color: AppTheme
                                        .textPrimary,
                                    fontFamily:
                                        'Outfit',
                                    fontSize:
                                        17,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    height: 1.1,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Your highest spending categories',
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      TextStyle(
                                    color: AppTheme
                                        .textMuted,
                                    fontFamily:
                                        'Outfit',
                                    fontSize:
                                        10,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  AppTheme.expense
                                      .withOpacity(
                                0.07,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                9,
                              ),
                              border:
                                  Border.all(
                                color:
                                    AppTheme.expense
                                        .withOpacity(
                                  0.15,
                                ),
                              ),
                            ),
                            child: const Text(
                              'THIS MONTH',
                              style:
                                  TextStyle(
                                color:
                                    AppTheme.expense,
                                fontFamily:
                                    'Outfit',
                                fontSize: 8,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                letterSpacing:
                                    0.8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 17,
                      ),

                      Container(
                        height: 1,
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.divider
                                  .withOpacity(
                                0.95,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 13,
                      ),

                      // =========================================
                      // EMPTY STATE
                      // =========================================
                      if (top.isEmpty)
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                            vertical: 24,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons
                                      .receipt_long_outlined,
                                  color: AppTheme
                                      .textMuted,
                                  size: 26,
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  'No expenses this month',
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                      // =========================================
                      // EXPENSE LIST
                      // =========================================
                      else
                        ...top
                            .asMap()
                            .entries
                            .map(
                          (item) {
                            final index =
                                item.key;

                            final entry =
                                item.value;

                            return StreamBuilder<
                                List<Category>>(
                              stream: categoryProvider
                                  .categoriesStream(
                                'EXPENSE',
                              ),
                              builder: (
                                context,
                                catSnapshot,
                              ) {
                                final categories =
                                    catSnapshot
                                            .data ??
                                        [];

                                final category =
                                    categories
                                        .where(
                                          (c) =>
                                              c.id ==
                                              entry
                                                  .key,
                                        )
                                        .firstOrNull;

                                return _ExpenseItem(
                                  index: index,
                                  categoryName:
                                      category?.name ??
                                          'Unknown',
                                  amount:
                                      entry.value,
                                  isLast:
                                      index ==
                                          top.length -
                                              1,
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final int index;
  final String categoryName;
  final int amount;
  final bool isLast;

  const _ExpenseItem({
    required this.index,
    required this.categoryName,
    required this.amount,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isLast ? 0 : 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.expense.withOpacity(
              index == 0 ? 0.075 : 0.035,
            ),
            Colors.white.withOpacity(
              0.025,
            ),
          ],
        ),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: index == 0
              ? AppTheme.expense.withOpacity(
                  0.16,
                )
              : AppTheme.glassBorder,
        ),
      ),
      child: Row(
        children: [
          // =============================================
          // RANK
          // =============================================
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: index == 0
                  ? AppTheme.expense.withOpacity(
                      0.14,
                    )
                  : Colors.white.withOpacity(
                      0.035,
                    ),
              borderRadius:
                  BorderRadius.circular(10),
              border: Border.all(
                color: index == 0
                    ? AppTheme.expense
                        .withOpacity(0.20)
                    : AppTheme.glassBorder,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: index == 0
                    ? AppTheme.expense
                    : AppTheme.textSecondary,
                fontFamily: 'Outfit',
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 11),

          // =============================================
          // CATEGORY
          // =============================================
          Expanded(
            child: Text(
              categoryName,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color:
                    AppTheme.textPrimary,
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // =============================================
          // AMOUNT
          // =============================================
          Flexible(
            flex: 0,
            child: Text(
              '₹$amount',
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.expense,
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}