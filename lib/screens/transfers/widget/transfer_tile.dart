import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/screens/transactions/transaction_detail_screen.dart';

class TransferTile extends StatelessWidget {
  final Transaction transfer;

  const TransferTile({
    super.key,
    required this.transfer,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final accountService = context.read<AccountService>();

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
          borderRadius: BorderRadius.circular(18),
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

                  return Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.transfer
                                .withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: AppTheme.transfer
                                  .withOpacity(0.20),
                            ),
                          ),
                          child: const Icon(
                            Icons.swap_horiz_rounded,
                            color: AppTheme.transfer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹${transfer.amount}',
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontFamily: 'Outfit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      fromAccount?.name ?? '...',
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color:
                                            AppTheme.textSecondary,
                                        fontFamily: 'Outfit',
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(
                                      horizontal: 7,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color:
                                          AppTheme.transfer,
                                      size: 14,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      toAccount?.name ?? '...',
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color:
                                            AppTheme.textSecondary,
                                        fontFamily: 'Outfit',
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    color: AppTheme.textMuted,
                                    size: 11,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _formatDate(
                                      transfer.transactionDate,
                                    ),
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontFamily: 'Outfit',
                                      fontSize: 11,
                                    ),
                                  ),
                                  if (transfer.description !=
                                          null &&
                                      transfer.description!
                                          .isNotEmpty) ...[
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.notes_rounded,
                                      color:
                                          AppTheme.textMuted,
                                      size: 11,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        transfer.description!,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color:
                                              AppTheme.textMuted,
                                          fontFamily: 'Outfit',
                                          fontSize: 11,
                                          fontStyle:
                                              FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.textMuted,
                          size: 20,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}