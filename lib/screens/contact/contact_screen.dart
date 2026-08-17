import 'package:flutter/material.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/screens/contact/widget/contact_filter_chip.dart';
import 'package:lifeos/screens/contact/widget/contact_tile.dart';
import 'package:provider/provider.dart';

import 'add_contact_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider?>();

    // Safety: if user is not logged in
    if (contactProvider == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Text(
            'Please login first',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Search Bar ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                ),
                cursorColor: AppTheme.violetBright,
                decoration: InputDecoration(
                  hintText: 'Search by name or phone',
                  hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                    fontFamily: 'Outfit',
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppTheme.cardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppTheme.glassBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppTheme.glassBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppTheme.violet,
                      width: 1.2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
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
                  ContactFilterChip(
                    label: 'All',
                    selected: contactProvider.selectedFilter == null,
                    onTap: () => contactProvider.setFilter(null),
                  ),
                  ContactFilterChip(
                    label: 'Will Get',
                    selected: contactProvider.selectedFilter ==
                        ContactBalanceType.willGet,
                    onTap: () => contactProvider.setFilter(
                      ContactBalanceType.willGet,
                    ),
                  ),
                  ContactFilterChip(
                    label: 'Will Give',
                    selected: contactProvider.selectedFilter ==
                        ContactBalanceType.willGive,
                    onTap: () => contactProvider.setFilter(
                      ContactBalanceType.willGive,
                    ),
                  ),
                  ContactFilterChip(
                    label: 'Settled',
                    selected: contactProvider.selectedFilter ==
                        ContactBalanceType.settled,
                    onTap: () => contactProvider.setFilter(
                      ContactBalanceType.settled,
                    ),
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
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.violetBright,
                        strokeWidth: 2.5,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(
                          color: AppTheme.expense,
                          fontFamily: 'Outfit',
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  final contacts = snapshot.data ?? [];

                  if (contacts.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 46,
                            color: AppTheme.textMuted,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No contacts found',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      100,
                    ),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      return ContactTile(
                        contact: contact,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ---------- Floating Action Button ----------
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.violet,
        foregroundColor: Colors.white,
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddContactScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add_rounded,
          size: 26,
        ),
      ),
    );
  }
}