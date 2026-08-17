import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/contact/widget/contact_transaction_tile.dart';

class ContactTransactionHistory extends StatelessWidget {
  final int contactId;
  final void Function(int transactionId) onOpenTransaction;

  const ContactTransactionHistory({
    super.key,
    required this.contactId,
    required this.onOpenTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final contactService = context.read<ContactService>();
    final contactProvider = context.watch<ContactProvider?>();

    if (contactProvider == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<Transaction>>(
      stream: contactService.watchContactTransactions(
        userId: contactProvider.userId,
        contactId: contactId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.violetBright,
                strokeWidth: 2.5,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(
                color: AppTheme.expense,
                fontFamily: 'Outfit',
                fontSize: 14,
              ),
            ),
          );
        }

        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: AppTheme.cardElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.glassBorder,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 36,
                    color: AppTheme.textMuted,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontFamily: 'Outfit',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.glassBorder,
            ),
          ),
          child: Column(
            children: transactions.asMap().entries.map((entry) {
              final index = entry.key;
              final tx = entry.value;

              return ContactTransactionTile(
                transaction: tx,
                onTap: () => onOpenTransaction(tx.id),
                showDivider: index != transactions.length - 1,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}