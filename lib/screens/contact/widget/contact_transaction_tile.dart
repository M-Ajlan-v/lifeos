import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';

class ContactTransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;
  final bool showDivider;

  const ContactTransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.showDivider,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isGave = transaction.type == 'GAVE';

    final color = isGave
        ? AppTheme.expense
        : AppTheme.income;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              child: Row(
                children: [
                  // ---------- Transaction Icon ----------
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.15),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isGave
                          ? Icons.north_east_rounded
                          : Icons.south_west_rounded,
                      color: color,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ---------- Transaction Info ----------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isGave ? 'Gave' : 'Got',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(
                            transaction.transactionDate,
                          ),
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontFamily: 'Outfit',
                            fontSize: 12,
                          ),
                        ),
                        if (transaction.description != null &&
                            transaction.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              transaction.description!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ---------- Amount ----------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isGave ? '-' : '+'}₹${transaction.amount}',
                        style: TextStyle(
                          color: color,
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.textMuted,
                        size: 19,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Divider(
              height: 1,
              color: AppTheme.divider,
            ),
          ),
      ],
    );
  }
}