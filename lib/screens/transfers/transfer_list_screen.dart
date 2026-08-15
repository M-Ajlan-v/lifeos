import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/transaction_service.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/screens/transactions/transaction_detail_screen.dart';
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
        appBar: AppBar(title: const Text('Transfers')),
        body: const Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      body: _TransferListBody(
        key: ValueKey(_refreshKey),
        txProvider: txProvider,
        onRefresh: () async {
          _forceRefresh();
          await Future.delayed(const Duration(milliseconds: 400));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransfer,
        tooltip: 'Add Transfer',
        child: const Icon(Icons.add),
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

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: StreamBuilder<List<Transaction>>(
        stream: txService.watchTransferTransactions(txProvider.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final transfers = snapshot.data ?? [];

          if (transfers.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      'No transfers yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final tx = transfers[index];
              return _TransferTile(transfer: tx);
            },
          );
        },
      ),
    );
  }
}

class _TransferTile extends StatelessWidget {
  final Transaction transfer;

  const _TransferTile({required this.transfer});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final accountService = context.read<AccountService>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: FutureBuilder<Account?>(
        future: accountService.getAccountById(
          userId: transfer.userId,
          accountId: transfer.accountId,
        ),
        builder: (context, fromSnapshot) {
          final fromAccount = fromSnapshot.data;

          return FutureBuilder<Account?>(
            future: transfer.toAccountId != null
                ? accountService.getAccountById(
                    userId: transfer.userId,
                    accountId: transfer.toAccountId!,
                  )
                : Future.value(null),
            builder: (context, toSnapshot) {
              final toAccount = toSnapshot.data;

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionDetailScreen(
                        transactionId: transfer.id,
                      ),
                    ),
                  );
                },
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.swap_horiz,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  '₹${transfer.amount}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fromAccount?.name ?? "..."} → ${toAccount?.name ?? "..."}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      _formatDate(transfer.transactionDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (transfer.description != null &&
                        transfer.description!.isNotEmpty)
                      Text(
                        transfer.description!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}