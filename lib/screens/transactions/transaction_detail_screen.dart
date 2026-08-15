import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/transaction_service.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/providers/transaction_provider.dart';

class TransactionDetailScreen extends StatelessWidget {
  final int transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  String _typeLabel(String type) {
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

  Future<void> _confirmAndDelete(BuildContext context) async {
    final txProvider = context.read<TransactionProvider?>();
    if (txProvider == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction?\n\n'
          'Account balances will be reversed and this cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await txProvider.softDeleteTransaction(transactionId);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(txProvider.error ?? 'Failed to delete')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final txService = context.read<TransactionService>();
    final accountService = context.read<AccountService>();
    final contactService = context.read<ContactService>();
    final categoryService = context.read<CategoryService>();
    final txProvider = context.read<TransactionProvider?>();

    if (txProvider == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: const Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: () => _confirmAndDelete(context),
          ),
        ],
      ),
      body: FutureBuilder<Transaction?>(
        future: txService.getTransactionById(
          userId: txProvider.userId,
          transactionId: transactionId,
        ),
        builder: (context, txSnapshot) {
          if (txSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (txSnapshot.hasError) {
            return Center(child: Text('Error: ${txSnapshot.error}'));
          }

          final transaction = txSnapshot.data;
          if (transaction == null) {
            return const Center(child: Text('Transaction not found'));
          }

          if (transaction.isActive == 0) {
            return const Center(
              child: Text(
                'This transaction has already been deleted.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final fromAccountFuture = accountService.getAccountById(
            userId: transaction.userId,
            accountId: transaction.accountId,
          );

          final toAccountFuture = transaction.toAccountId == null
              ? Future<Account?>.value(null)
              : accountService.getAccountById(
                  userId: transaction.userId,
                  accountId: transaction.toAccountId!,
                );

          final contactFuture = transaction.contactId == null
              ? Future<Contact?>.value(null)
              : contactService.getContactById(
                  userId: transaction.userId,
                  contactId: transaction.contactId!,
                );

          final categoryFuture = transaction.categoryId == null
              ? Future<Category?>.value(null)
              : categoryService.getCategoryById(
                  userId: transaction.userId,
                  categoryId: transaction.categoryId!,
                );

          return FutureBuilder(
            future: Future.wait([
              fromAccountFuture,
              toAccountFuture,
              contactFuture,
              categoryFuture,
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final values = snapshot.data as List<dynamic>? ?? const [];
              final fromAccount = values.isNotEmpty ? values[0] as Account? : null;
              final toAccount = values.length > 1 ? values[1] as Account? : null;
              final contact = values.length > 2 ? values[2] as Contact? : null;
              final category = values.length > 3 ? values[3] as Category? : null;

              final rows = <_DetailRow>[];

              rows.add(_DetailRow(
                label: 'Transaction Type',
                value: _typeLabel(transaction.type),
              ));
              rows.add(_DetailRow(
                label: 'Amount',
                value: '₹${transaction.amount}',
              ));

              if (transaction.type == 'TRANSFER') {
                rows.add(_DetailRow(
                  label: 'From Account',
                  value: fromAccount?.name ?? 'Unknown account',
                ));
                rows.add(_DetailRow(
                  label: 'To Account',
                  value: toAccount?.name ?? 'Unknown account',
                ));
              } else {
                rows.add(_DetailRow(
                  label: 'Account',
                  value: fromAccount?.name ?? 'Unknown account',
                ));
              }

              rows.add(_DetailRow(
                label: 'Transaction Date',
                value: _formatDate(transaction.transactionDate),
              ));

              if (transaction.type == 'GAVE' || transaction.type == 'GOT') {
                rows.add(_DetailRow(
                  label: 'Contact Name',
                  value: contact?.name ?? 'Unknown contact',
                ));
                rows.add(_DetailRow(
                  label: 'Contact Phone',
                  value: contact?.phone ?? 'No phone available',
                ));
              } else if (transaction.type == 'INCOME' ||
                  transaction.type == 'EXPENSE') {
                rows.add(_DetailRow(
                  label: 'Category',
                  value: category?.name ?? 'Unknown category',
                ));
              }

              if (transaction.description != null &&
                  transaction.description!.trim().isNotEmpty) {
                rows.add(_DetailRow(
                  label: 'Description',
                  value: transaction.description!,
                ));
              }

              rows.add(_DetailRow(
                label: 'Created At',
                value: _formatDate(transaction.createdAt),
              ));

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return ListTile(
                    title: Text(row.label),
                    subtitle: Text(
                      row.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});
}