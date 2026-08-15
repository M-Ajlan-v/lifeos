import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/screens/contact/give_got_screen.dart';
import 'package:lifeos/screens/transactions/transaction_detail_screen.dart';
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
        title: const Text('Deactivate Contact?'),
        content: const Text(
          'This contact will be hidden from the list.\n'
          'All past transactions will remain safe.\n\n'
          'You can create a new contact with the same phone number later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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
        const SnackBar(content: Text('Contact deactivated')),
      );
    } else {
      final error = provider.error ?? 'Unable to deactivate contact';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
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
        body: Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Contact',
            onPressed: () async {
              // We need the latest contact, so we read it from the stream below
              // For simplicity we open edit from the body
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Deactivate Contact',
            onPressed: () => _confirmDeactivate(contactProvider),
          ),
        ],
      ),
      body: StreamBuilder<Contact?>(
        // Key forces the stream to restart when we call _forceRefresh
        key: ValueKey('contact-$_refreshKey'),
        stream: contactService.watchContact(
          userId: contactProvider.userId,
          contactId: widget.contactId,
        ),
        builder: (context, contactSnapshot) {
          if (contactSnapshot.connectionState == ConnectionState.waiting &&
              !contactSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (contactSnapshot.hasError) {
            return Center(child: Text('Error: ${contactSnapshot.error}'));
          }

          final contact = contactSnapshot.data;

          if (contact == null) {
            return const Center(child: Text('Contact not found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _forceRefresh();
              // Small delay so the indicator is visible
              await Future.delayed(const Duration(milliseconds: 400));
            },
            child: _ContactDetailsBody(
              contact: contact,
              onQuickTransaction: _openQuickTransaction,
              onOpenTransaction: _openTransactionDetail,
              onEdit: () => _openEdit(contact),
            ),
          );
        },
      ),
    );
  }
}

class _ContactDetailsBody extends StatelessWidget {
  final Contact contact;
  final void Function(String type) onQuickTransaction;
  final void Function(int transactionId) onOpenTransaction;
  final VoidCallback onEdit;

  const _ContactDetailsBody({
    required this.contact,
    required this.onQuickTransaction,
    required this.onOpenTransaction,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isWillGet = contact.currentType == ContactBalanceType.willGet;
    final isWillGive = contact.currentType == ContactBalanceType.willGive;

    Color statusColor = Colors.grey;
    String statusText = 'Settled';

    if (isWillGet) {
      statusColor = Colors.green;
      statusText = 'You Will Get ₹${contact.currentAmount}';
    } else if (isWillGive) {
      statusColor = Colors.red;
      statusText = 'You will Give ₹${contact.currentAmount}';
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(), // needed for RefreshIndicator
      padding: const EdgeInsets.all(16),
      children: [
        // Avatar + Name
        Center(
          child: CircleAvatar(
            radius: 40,
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            contact.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            contact.phone,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),

        // Current Balance Card
        Card(
          color: statusColor.withOpacity(0.12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Current Balance',
                  style: TextStyle(color: statusColor, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Gave / Got buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onQuickTransaction('GAVE'),
                icon: const Icon(Icons.arrow_upward),
                label: const Text('Gave'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onQuickTransaction('GOT'),
                icon: const Icon(Icons.arrow_downward),
                label: const Text('Got'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Contact Information
        const Text(
          'Contact Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Opening Balance'),
          trailing: Text(
            contact.openingAmount == 0
                ? 'Settled'
                : '${contact.openingType == ContactBalanceType.willGet ? "Got" : "Gave"} ₹${contact.openingAmount}',
          ),
        ),
        if (contact.description != null && contact.description!.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Description'),
            subtitle: Text(contact.description!),
          ),
        const SizedBox(height: 28),

        // Transaction History title
        const Text(
          'Transaction History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // Reactive transaction list
        _TransactionHistoryWidget(
          contactId: contact.id,
          onOpenTransaction: onOpenTransaction,
        ),
      ],
    );
  }
}

class _TransactionHistoryWidget extends StatelessWidget {
  final int contactId;
  final void Function(int transactionId) onOpenTransaction;

  const _TransactionHistoryWidget({
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
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Center(
                child: Text(
                  'No transactions yet',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          );
        }

        return Column(
          children: transactions.map((tx) {
            return _TransactionTile(
              transaction: tx,
              onTap: () => onOpenTransaction(tx.id),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.transaction,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isGave = transaction.type == 'GAVE';
    final color = isGave ? Colors.red : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            isGave ? Icons.arrow_upward : Icons.arrow_downward,
            color: color,
          ),
        ),
        title: Text(
          '${isGave ? 'Gave' : 'Got'} ₹${transaction.amount}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatDate(transaction.transactionDate)),
            if (transaction.description != null &&
                transaction.description!.isNotEmpty)
              Text(
                transaction.description!,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Text(
          isGave ? '-' : '+',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}