import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/screens/contact/give_got_screen.dart';
import 'package:lifeos/screens/transactions/transaction_detail_screen.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/contact/widget/contact_details_body.dart';

import 'edit_contact_screen.dart';

class ContactDetailsScreen extends StatefulWidget {
  final int contactId;

  const ContactDetailsScreen({
    super.key,
    required this.contactId,
  });

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  // Used only to force a rebuild of streams when we come back from edit / delete
  int _refreshKey = 0;

  void _forceRefresh() {
    setState(() {
      _refreshKey++;
    });
  }

  Future<void> _openEdit(Contact contact) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditContactScreen(contact: contact),
      ),
    );

    if (updated == true && mounted) {
      _forceRefresh();
    }
  }

  Future<void> _confirmDeactivate(ContactProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(
            color: AppTheme.glassBorderStrong,
          ),
        ),
        title: const Text(
          'Deactivate Contact?',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'This contact will be hidden from the list.\n'
          'All past transactions will remain safe.\n\n'
          'You can create a new contact with the same phone number later.',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontFamily: 'Outfit',
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.expense,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final success = await provider.deactivateContact(widget.contactId);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact deactivated'),
        ),
      );
    } else {
      final error = provider.error ?? 'Unable to deactivate contact';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    }
  }

  Future<void> _openQuickTransaction(String type) async {
    final refreshed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GiveGotScreen(
          type: type,
          contactId: widget.contactId,
        ),
      ),
    );

    if (refreshed == true && mounted) {
      _forceRefresh();
    }
  }

  Future<void> _openTransactionDetail(int transactionId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionDetailScreen(
          transactionId: transactionId,
        ),
      ),
    );

    // Always refresh when coming back (delete or just viewing)
    if (mounted) {
      _forceRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider?>();
    final contactService = context.read<ContactService>();

    if (contactProvider == null) {
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
  body: StreamBuilder<Contact?>(
    key: ValueKey('contact-$_refreshKey'),
    stream: contactService.watchContact(
      userId: contactProvider.userId,
      contactId: widget.contactId,
    ),
    builder: (context, contactSnapshot) {
      if (contactSnapshot.connectionState == ConnectionState.waiting &&
          !contactSnapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppTheme.violetBright,
            strokeWidth: 2.5,
          ),
        );
      }

      if (contactSnapshot.hasError) {
        return Center(
          child: Text(
            'Error: ${contactSnapshot.error}',
            style: const TextStyle(
              color: AppTheme.expense,
              fontFamily: 'Outfit',
            ),
          ),
        );
      }

      final contact = contactSnapshot.data;

      if (contact == null) {
        return const Center(
          child: Text(
            'Contact not found',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontFamily: 'Outfit',
            ),
          ),
        );
      }

      return Column(
        children: [
          AppBar(
            backgroundColor: AppTheme.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
              leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.textPrimary,
                size: 20,
              ),
            ),
            title: const Text(
              'Contact Details',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
            
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppTheme.textSecondary,
                ),
                tooltip: 'Edit Contact',
                onPressed: () => _openEdit(contact),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppTheme.textSecondary,
                ),
                tooltip: 'Deactivate Contact',
                onPressed: () => _confirmDeactivate(contactProvider),
              ),
            ],
          ),

          Expanded(
            child: RefreshIndicator(
              color: AppTheme.violetBright,
              backgroundColor: AppTheme.cardElevated,
              onRefresh: () async {
                _forceRefresh();

                await Future.delayed(
                  const Duration(milliseconds: 400),
                );
              },
              child: ContactDetailsBody(
                contact: contact,
                onQuickTransaction: _openQuickTransaction,
                onOpenTransaction: _openTransactionDetail,
                onEdit: () => _openEdit(contact),
              ),
            ),
          ),
        ],
      );
    },
  ),

  bottomNavigationBar: SafeArea(
    minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () => _openQuickTransaction('GAVE'),
              icon: const Icon(Icons.north_east_rounded),
              label: const Text('Give'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.expense,
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: AppTheme.expense.withOpacity(0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () => _openQuickTransaction('GOT'),
              icon: const Icon(Icons.south_west_rounded),
              label: const Text('Got'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.income,
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: AppTheme.income.withOpacity(0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
  }
}