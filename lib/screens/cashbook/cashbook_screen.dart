import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/screens/transactions/transaction_detail_screen.dart';
import 'add_income_expense_screen.dart';

class CashbookScreen extends StatelessWidget {
  const CashbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();

    if (txProvider == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      body: StreamBuilder<List<Transaction>>(
        stream: txProvider.cashbookStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final transactions = snapshot.data ?? [];

          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                'No income or expense yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return _TransactionTile(transaction: tx);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.green),
                title: const Text('Add Income'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddIncomeExpenseScreen(type: 'INCOME'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.red),
                title: const Text('Add Expense'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddIncomeExpenseScreen(type: 'EXPENSE'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'INCOME';
    final color = isIncome ? Colors.green : Colors.red;
    final sign = isIncome ? '+' : '-';
    final txProvider = context.watch<TransactionProvider?>();
    final categoryService = context.read<CategoryService>();

    final categoryFuture = transaction.categoryId == null
        ? Future.value(null)
        : categoryService.getCategoryById(
            userId: txProvider?.userId ?? 0,
            categoryId: transaction.categoryId!,
          );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transactionId: transaction.id),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
          ),
        ),
        title: Text(
          transaction.description?.isNotEmpty == true
              ? transaction.description!
              : (isIncome ? 'Income' : 'Expense'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: FutureBuilder<Category?>(
          future: categoryFuture,
          builder: (context, snapshot) {
            final categoryName = snapshot.data?.name ?? 'No category';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: $categoryName'),
                Text(
                  '${transaction.transactionDate.day}/${transaction.transactionDate.month}/${transaction.transactionDate.year}',
                ),
              ],
            );
          },
        ),
        trailing: Text(
          '$sign₹${transaction.amount}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}