import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/database/app_database.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider?>();

    if (accountProvider == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<Account>>(
      stream: accountProvider.accountsStream,
      builder: (context, snapshot) {
        final accounts = snapshot.data ?? [];
        final total = accounts.fold<int>(0, (sum, a) => sum + a.openingBalance);
        final cash = accounts
            .where((a) => a.type == 'CASH')
            .fold<int>(0, (sum, a) => sum + a.openingBalance);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Cash: ₹$cash',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
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