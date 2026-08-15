import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/database/app_database.dart';

class ThisMonthCard extends StatelessWidget {
  const ThisMonthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();

    if (txProvider == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<Transaction>>(
      stream: txProvider.cashbookStream,
      builder: (context, snapshot) {
        final now = DateTime.now();
        final transactions = (snapshot.data ?? []).where((tx) {
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

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This Month',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MonthItem(
                        label: 'Income',
                        amount: income,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _MonthItem(
                        label: 'Expense',
                        amount: expense,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: _MonthItem(
                        label: 'Net',
                        amount: net,
                        color: net >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
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

  const _MonthItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '₹$amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}