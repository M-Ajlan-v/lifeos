import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/providers/category_provider.dart';
import 'package:lifeos/database/app_database.dart';

class TopExpensesCard extends StatelessWidget {
  const TopExpensesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();
    final categoryProvider = context.watch<CategoryProvider?>();

    if (txProvider == null || categoryProvider == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<Transaction>>(
      stream: txProvider.cashbookStream,
      builder: (context, txSnapshot) {
        final now = DateTime.now();
        final expenses = (txSnapshot.data ?? []).where((tx) {
          return tx.type == 'EXPENSE' &&
              tx.transactionDate.year == now.year &&
              tx.transactionDate.month == now.month &&
              tx.categoryId != null;
        }).toList();

        // Group by categoryId
        final Map<int, int> totals = {};
        for (final tx in expenses) {
          totals[tx.categoryId!] = (totals[tx.categoryId!] ?? 0) + tx.amount;
        }

        final sorted = totals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final top = sorted.take(5).toList();

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Expenses (This Month)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (top.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No expenses this month',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ...top.map((entry) {
                    return StreamBuilder<List<Category>>(
                      stream: categoryProvider.categoriesStream('EXPENSE'),
                      builder: (context, catSnapshot) {
                        final categories = catSnapshot.data ?? [];
                        final category = categories
                            .where((c) => c.id == entry.key)
                            .firstOrNull;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  category?.name ?? 'Unknown',
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '₹${entry.value}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}