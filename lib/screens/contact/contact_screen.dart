import 'package:flutter/material.dart';
import 'package:lifeos/screens/contact/contact_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'add_contact_screen.dart'; // we will create this next

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider?>();

    // Safety: if user is not logged in
    if (contactProvider == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // ---------- Search Bar ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or phone',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                contactProvider.setSearchQuery(value);
              },
            ),
          ),

          // ---------- Filter Chips ----------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: contactProvider.selectedFilter == null,
                  onTap: () => contactProvider.setFilter(null),
                ),
                _FilterChip(
                  label: 'Will Get',
                  selected: contactProvider.selectedFilter == ContactBalanceType.willGet,
                  onTap: () => contactProvider.setFilter(ContactBalanceType.willGet),
                ),
                _FilterChip(
                  label: 'Will Give',
                  selected: contactProvider.selectedFilter == ContactBalanceType.willGive,
                  onTap: () => contactProvider.setFilter(ContactBalanceType.willGive),
                ),
                _FilterChip(
                  label: 'Settled',
                  selected: contactProvider.selectedFilter == ContactBalanceType.settled,
                  onTap: () => contactProvider.setFilter(ContactBalanceType.settled),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ---------- Contact List ----------
          Expanded(
            child: StreamBuilder<List<Contact>>(
              stream: contactProvider.contactsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final contacts = snapshot.data ?? [];

                if (contacts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No contacts found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return _ContactTile(contact: contact);
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ---------- Floating Action Button ----------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =======================================================
// Small helper widgets (keep them in the same file for now)
// =======================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;

  const _ContactTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    final isWillGet = contact.currentType == ContactBalanceType.willGet;
    final isWillGive = contact.currentType == ContactBalanceType.willGive;

    Color amountColor = Colors.grey;
    String amountText = 'Settled';

    if (isWillGet) {
      amountColor = Colors.green;
      amountText = '₹${contact.currentAmount}';
    } else if (isWillGive) {
      amountColor = Colors.red;
      amountText = '₹${contact.currentAmount}';
    }

    return ListTile(
      leading: CircleAvatar(
        child: Text(
          contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
        ),
      ),
      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(contact.phone),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amountText,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (isWillGet)
            const Text('Will Get', style: TextStyle(fontSize: 12, color: Colors.green)),
          if (isWillGive)
            const Text('Will Give', style: TextStyle(fontSize: 12, color: Colors.red)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactDetailsScreen(contactId: contact.id),
          ),
        );
      },
    );
  }
}