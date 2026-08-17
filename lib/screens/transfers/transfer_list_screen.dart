import 'package:flutter/material.dart';
import 'package:lifeos/screens/transfers/widget/transfer_empty.dart';
import 'package:lifeos/screens/transfers/widget/transfer_tile.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/transaction_service.dart';
import 'add_transfer_screen.dart';

class TransferListScreen extends StatefulWidget {
  const TransferListScreen({super.key});

  @override
  State<TransferListScreen> createState() => _TransferListScreenState();
}

class _TransferListScreenState extends State<TransferListScreen> {
  int _refreshKey = 0;

  void _forceRefresh() {
    setState(() {
      _refreshKey++;
    });
  }

  Future<void> _openAddTransfer() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransferScreen(),
      ),
    );

    if (result == true && mounted) {
      _forceRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();

    if (txProvider == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Transfers',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
      body: _TransferListBody(
        key: ValueKey(_refreshKey),
        txProvider: txProvider,
        onRefresh: () async {
          _forceRefresh();
          await Future.delayed(
            const Duration(milliseconds: 400),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransfer,
        tooltip: 'Add Transfer',
        backgroundColor: AppTheme.violet,
        foregroundColor: AppTheme.textPrimary,
        elevation: 8,
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
    );
  }
}

class _TransferListBody extends StatelessWidget {
  final TransactionProvider txProvider;
  final Future<void> Function() onRefresh;

  const _TransferListBody({
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
        onRefresh: onRefresh,
        backgroundColor: AppTheme.cardElevated,
        color: AppTheme.violetBright,
        child: StreamBuilder<List<Transaction>>(
          stream: txService.watchTransferTransactions(
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

            final transfers = snapshot.data ?? [];

            if (transfers.isEmpty) {
              return const TransferEmpty();
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                100,
              ),
              itemCount: transfers.length,
              itemBuilder: (context, index) {
                final tx = transfers[index];

                return TransferTile(
                  transfer: tx,
                );
              },
            );
          },
        ),
      ),
    );
  }
}