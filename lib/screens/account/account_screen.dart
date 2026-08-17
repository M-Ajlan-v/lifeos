import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'add_account_screen.dart';
import 'edit_account_screen.dart';
import 'widget/account_card.dart';
import 'widget/account_action_sheet.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider?>();

    if (accountProvider == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
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
      body: StreamBuilder<List<Account>>(
        stream: accountProvider.accountsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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

          final accounts = snapshot.data ?? [];

          if (accounts.isEmpty) {
            return const Center(
              child: Text(
                'No accounts yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  fontFamily: 'Outfit',
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              100,
            ),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AccountCard(
                  account: account,
                  index: index,
                  onTap: () {
                    _showOptions(
                      context,
                      account,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.violet,
        foregroundColor: AppTheme.textPrimary,
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAccountScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
    );
  }

  void _showOptions(
    BuildContext context,
    Account account,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.72),
      builder: (ctx) {
        return AccountActionSheet(
          onEdit: () {
            Navigator.pop(ctx);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditAccountScreen(
                  account: account,
                ),
              ),
            );
          },
          onDelete: () {
            Navigator.pop(ctx);
            _confirmDelete(
              context,
              account,
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Account account,
  ) async {
    final provider = context.read<AccountProvider?>();

    if (provider == null) return;

    // First check balance
    if (account.openingBalance != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cannot delete account with non-zero balance',
          ),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.cardElevated,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Delete Account?',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${account.name}"?\n\n'
            'This action cannot be undone.',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontFamily: 'Outfit',
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.expense,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final success = await provider.deactivateAccount(
      account.id,
    );

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Unable to delete account',
          ),
        ),
      );
    }
  }
}