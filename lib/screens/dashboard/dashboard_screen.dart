import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'widgets/total_balance_card.dart';
import 'widgets/this_month_card.dart';
import 'widgets/top_expenses_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();

    if (txProvider == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Streams will update automatically
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: const [
            TotalBalanceCard(),
            SizedBox(height: 16),
            ThisMonthCard(),
            SizedBox(height: 16),
            TopExpensesCard(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}