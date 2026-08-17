import 'package:flutter/material.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/screens/contact/contact_details_screen.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;

  const ContactTile({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final isWillGet =
        contact.currentType == ContactBalanceType.willGet;

    final isWillGive =
        contact.currentType == ContactBalanceType.willGive;

    Color amountColor = AppTheme.textSecondary;
    String amountText = 'Settled';

    if (isWillGet) {
      amountColor = AppTheme.income;
      amountText = '₹${contact.currentAmount}';
    } else if (isWillGive) {
      amountColor = AppTheme.expense;
      amountText = '₹${contact.currentAmount}';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContactDetailsScreen(
                  contactId: contact.id,
                ),
              ),
            );
          },
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.cardElevated,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.glassBorder,
              ),
              boxShadow: AppTheme.softShadow,
            ),
            child: Row(
              children: [
                // ---------- Avatar ----------
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.violetGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.violet.withOpacity(0.20),
                        blurRadius: 12,
                        spreadRadius: -2,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // ---------- Contact Info ----------
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontFamily: 'Outfit',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // ---------- Balance ----------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amountText,
                      style: TextStyle(
                        color: amountColor,
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isWillGet)
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Text(
                          'Will Get',
                          style: TextStyle(
                            color: AppTheme.income,
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (isWillGive)
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Text(
                          'Will Give',
                          style: TextStyle(
                            color: AppTheme.expense,
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 6),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}