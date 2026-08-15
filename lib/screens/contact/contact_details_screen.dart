import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'package:lifeos/services/contact_service.dart';
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
  late Future<Contact?> _contactFuture;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  void _loadContact() {
    final contactProvider = context.read<ContactProvider?>();
    final contactService = context.read<ContactService>();

    if (contactProvider == null) {
      _contactFuture = Future.value(null);
      return;
    }

    _contactFuture = contactService.getContactById(
      userId: contactProvider.userId,
      contactId: widget.contactId,
    );
  }

  Future<void> _openEdit(Contact contact) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditContactScreen(contact: contact),
      ),
    );

    if (updated == true && mounted) {
      setState(() {
        _loadContact(); // reload fresh data
      });
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

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider?>();

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
              final contact = await _contactFuture;
              if (contact != null && mounted) {
                await _openEdit(contact);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Deactivate Contact',
            onPressed: () => _confirmDeactivate(contactProvider),
          ),
        ],
      ),
      body: FutureBuilder<Contact?>(
        future: _contactFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final contact = snapshot.data;

          if (contact == null) {
            return const Center(child: Text('Contact not found'));
          }

          return _ContactDetailsBody(contact: contact);
        },
      ),
    );
  }
}

class _ContactDetailsBody extends StatelessWidget {
  final Contact contact;

  const _ContactDetailsBody({required this.contact});

  @override
  Widget build(BuildContext context) {
    final isWillGet = contact.currentType == ContactBalanceType.willGet;
    final isWillGive = contact.currentType == ContactBalanceType.willGive;

    Color statusColor = Colors.grey;
    String statusText = 'Settled';

    if (isWillGet) {
      statusColor = Colors.green;
      statusText = 'Will Get ₹${contact.currentAmount}';
    } else if (isWillGive) {
      statusColor = Colors.red;
      statusText = 'Will Give ₹${contact.currentAmount}';
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
        const Text(
          'Transaction History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Center(
              child: Text(
                'Transaction history will appear here\nwhen GAVE / GOT is ready',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}