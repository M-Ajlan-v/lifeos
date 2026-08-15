import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/transaction_service.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/services/contact_service.dart';
import 'transaction_detail_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
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
        appBar: AppBar(title: const Text('Transactions')),
        body: const Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
      ),
      body: _TransactionListBody(
        key: ValueKey(_refreshKey),
        txProvider: txProvider,
        onRefresh: () async {
          _forceRefresh();
          await Future.delayed(const Duration(milliseconds: 400));
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

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: StreamBuilder<List<Transaction>>(
        stream: txService.watchActiveTransactions(txProvider.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final transactions = snapshot.data ?? [];

          if (transactions.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      'No transactions yet',
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
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return _TransactionTile(transaction: tx);
            },
          );
        },
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  Color _getAmountColor(String type) {
    if (type == 'TRANSFER') {
      return Colors.black;
    } else if (type == 'EXPENSE' || type == 'GAVE') {
      return Colors.red;
    } else if (type == 'INCOME' || type == 'GOT') {
      return Colors.green;
    }
    return Colors.black;
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'INCOME':
        return 'Income';
      case 'EXPENSE':
        return 'Expense';
      case 'GAVE':
        return 'Gave';
      case 'GOT':
        return 'Got';
      case 'TRANSFER':
        return 'Transfer';
      default:
        return type;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final accountService = context.read<AccountService>();
    final categoryService = context.read<CategoryService>();
    final contactService = context.read<ContactService>();

    final amountColor = _getAmountColor(transaction.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder<String>(
            future: _getDetailText(
              accountService,
              categoryService,
              contactService,
            ),
            builder: (context, snapshot) {
              final detailText = snapshot.data ?? 'Loading...';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getTypeLabel(transaction.type),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '₹${transaction.amount}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: amountColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    detailText,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(transaction.transactionDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String> _getDetailText(
    AccountService accountService,
    CategoryService categoryService,
    ContactService contactService,
  ) async {
    // Priority: Contact > Category > To Account
    if (transaction.contactId != null) {
      try {
        final contact = await contactService.getContactById(
          userId: transaction.userId,
          contactId: transaction.contactId!,
        );
        return contact?.name ?? 'Unknown contact';
      } catch (e) {
        return 'Contact';
      }
    }

    if (transaction.categoryId != null) {
      try {
        final category = await categoryService.getCategoryById(
          userId: transaction.userId,
          categoryId: transaction.categoryId!,
        );
        return category?.name ?? 'Unknown category';
      } catch (e) {
        return 'Category';
      }
    }

    if (transaction.toAccountId != null) {
      try {
        final toAccount = await accountService.getAccountById(
          userId: transaction.userId,
          accountId: transaction.toAccountId!,
        );
        return 'to ${toAccount?.name ?? "Unknown"}';
      } catch (e) {
        return 'Transfer';
      }
    }

    // Fallback: get from account name
    try {
      final fromAccount = await accountService.getAccountById(
        userId: transaction.userId,
        accountId: transaction.accountId,
      );
      return fromAccount?.name ?? 'Unknown account';
    } catch (e) {
      return 'Account';
    }
  }
}