import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/transaction_service.dart';
import 'package:lifeos/screens/transactions/widget/transaction_tile.dart';
import 'package:lifeos/screens/transactions/widget/transaction_empty.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  int _refreshKey = 0;

  void _forceRefresh() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();

    if (txProvider == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const Center(
          child: Text(
            'Please login first',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _TransactionListBody(
        key: ValueKey(_refreshKey),
        txProvider: txProvider,
        onRefresh: () async {
          _forceRefresh();
          await Future.delayed(
            const Duration(milliseconds: 400),
          );
        },
      ),
    );
  }
}

class _TransactionListBody extends StatelessWidget {
  final TransactionProvider txProvider;
  final Future<void> Function() onRefresh;

  const _TransactionListBody({
    super.key,
    required this.txProvider,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final txService = context.read<TransactionService>();

    return Container(
      color: AppTheme.background,
      child: RefreshIndicator(
        backgroundColor: AppTheme.cardElevated,
        color: AppTheme.violetBright,
        onRefresh: onRefresh,
        child: StreamBuilder<List<Transaction>>(
          stream: txService.watchActiveTransactions(
            txProvider.userId,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.violetBright,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: 'Outfit',
                  ),
                ),
              );
            }

            final transactions = snapshot.data ?? [];

            if (transactions.isEmpty) {
              return const CashbookTransactionEmpty();
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                28,
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];

                return CashbookTransactionTile(
                  transaction: tx,
                );
              },
            );
          },
        ),
      ),
    );
  }
}