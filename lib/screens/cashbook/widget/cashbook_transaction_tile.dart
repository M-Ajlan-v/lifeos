import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/screens/transactions/transaction_detail_screen.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class CashbookTransactionTile extends StatelessWidget {
  final Transaction transaction;

  const CashbookTransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'INCOME';
    final color = isIncome
        ? AppTheme.income
        : AppTheme.expense;
    final sign = isIncome ? '+' : '-';

    final txProvider = context.watch<TransactionProvider?>();
    final categoryService = context.read<CategoryService>();

    final categoryFuture = transaction.categoryId == null
        ? Future.value(null)
        : categoryService.getCategoryById(
            userId: txProvider?.userId ?? 0,
            categoryId: transaction.categoryId!,
          );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.glassBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransactionDetailScreen(
                  transactionId: transaction.id,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              13,
              13,
              14,
              13,
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: color.withOpacity(0.16),
                    ),
                  ),
                  child: Icon(
                    isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: color,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<Category?>(
                        future: categoryFuture,
                        builder: (context, snapshot) {
                          final categoryName =
                              snapshot.data?.name ?? 'No category';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                isIncome ? 'INCOME' : 'EXPENSE',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${transaction.transactionDate.day}/'
                                '${transaction.transactionDate.month}/'
                                '${transaction.transactionDate.year}',
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontFamily: 'Outfit',
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$sign₹${transaction.amount}',
                      style: TextStyle(
                        color: color,
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.textMuted,
                      size: 19,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}