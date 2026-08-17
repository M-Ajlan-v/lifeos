import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/transaction_service.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/services/contact_service.dart';
import '../transaction_detail_screen.dart';

class CashbookTransactionTile extends StatelessWidget {
  final Transaction transaction;

  const CashbookTransactionTile({
    super.key,
    required this.transaction,
  });

  Color _getAmountColor(String type) {
    if (type == 'TRANSFER') {
      return AppTheme.transfer;
    } else if (type == 'EXPENSE' || type == 'GAVE') {
      return AppTheme.expense;
    } else if (type == 'INCOME' || type == 'GOT') {
      return AppTheme.income;
    }

    return AppTheme.textPrimary;
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

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'INCOME':
        return Icons.south_west_rounded;
      case 'EXPENSE':
        return Icons.north_east_rounded;
      case 'GAVE':
        return Icons.arrow_upward_rounded;
      case 'GOT':
        return Icons.arrow_downward_rounded;
      case 'TRANSFER':
        return Icons.swap_horiz_rounded;
      default:
        return Icons.receipt_long_rounded;
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

    final amountColor = _getAmountColor(
      transaction.type,
    );

    final typeLabel = _getTypeLabel(
      transaction.type,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.glassBorder,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
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
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: FutureBuilder<String>(
              future: _getDetailText(
                accountService,
                categoryService,
                contactService,
              ),
              builder: (context, snapshot) {
                final detailText =
                    snapshot.data ?? 'Loading...';

                return Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    // -------------------------------------------------
                    // TYPE ICON
                    // -------------------------------------------------
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: amountColor.withOpacity(0.11),
                        borderRadius:
                            BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              amountColor.withOpacity(0.16),
                        ),
                      ),
                      child: Icon(
                        _getTypeIcon(
                          transaction.type,
                        ),
                        color: amountColor,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 13),

                    // -------------------------------------------------
                    // DETAILS
                    // -------------------------------------------------
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            typeLabel,
                            style: const TextStyle(
                              color:
                                  AppTheme.textPrimary,
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            detailText,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:
                                  AppTheme.textSecondary,
                              fontFamily: 'Outfit',
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                color: AppTheme.textMuted,
                                size: 12,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _formatDate(
                                  transaction
                                      .transactionDate,
                                ),
                                style: const TextStyle(
                                  color:
                                      AppTheme.textMuted,
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // -------------------------------------------------
                    // AMOUNT
                    // -------------------------------------------------
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${transaction.amount}',
                          style: TextStyle(
                            color: amountColor,
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.textMuted,
                          size: 19,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
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
        final contact =
            await contactService.getContactById(
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
        final category =
            await categoryService.getCategoryById(
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
        final toAccount =
            await accountService.getAccountById(
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
      final fromAccount =
          await accountService.getAccountById(
        userId: transaction.userId,
        accountId: transaction.accountId,
      );

      return fromAccount?.name ?? 'Unknown account';
    } catch (e) {
      return 'Account';
    }
  }
}