import 'package:flutter/material.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/screens/contact/widget/contact_balance_item.dart';
import 'package:lifeos/screens/contact/widget/contact_transaction_history.dart';

class ContactDetailsBody extends StatelessWidget {
  final Contact contact;
  final void Function(String type) onQuickTransaction;
  final void Function(int transactionId) onOpenTransaction;
  final VoidCallback onEdit;

  const ContactDetailsBody({
    super.key,
    required this.contact,
    required this.onQuickTransaction,
    required this.onOpenTransaction,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isWillGet =
        contact.currentType == ContactBalanceType.willGet;

    final isWillGive =
        contact.currentType == ContactBalanceType.willGive;

    String statusText = 'Settled';
    Color statusColor = AppTheme.textSecondary;

    if (isWillGet) {
      statusText = 'You will Get';
      statusColor = AppTheme.income;
    } else if (isWillGive) {
      statusText = 'You will Give';
      statusColor = AppTheme.expense;
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        // ------------------------------------------------------------
        // PROFILE SECTION
        // ------------------------------------------------------------
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppTheme.surfaceGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.glassBorderStrong,
            ),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.violetGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.violet.withOpacity(0.28),
                      blurRadius: 20,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  contact.name.isNotEmpty
                      ? contact.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      contact.phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontFamily: 'Outfit',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.20),
                    ),
                  ),
                  child: Text(
                    statusText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: statusColor,
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // ------------------------------------------------------------
        // CURRENT BALANCE
        // ------------------------------------------------------------
        ContactBalanceItem(
          title: 'Current Balance',
          amount: contact.currentAmount,
          color: statusColor,
        ),

        const SizedBox(height: 24),

        Container(
          height: 1,
          color: AppTheme.divider,
        ),

        const SizedBox(height: 24),

        const Text(
          'Transaction History',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        ContactTransactionHistory(
          contactId: contact.id,
          onOpenTransaction: onOpenTransaction,
        ),
      ],
    );
  }
}