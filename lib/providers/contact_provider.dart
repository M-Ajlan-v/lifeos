import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/constants/contact_balance_type.dart';

class ContactProvider with ChangeNotifier {
  final ContactService _contactService;
  final int userId;

  ContactProvider({
    required ContactService contactService,
    required this.userId,
  }) : _contactService = contactService;

  // ---------- UI State ----------
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedFilter; // null = ALL, or WILL_GET / WILL_GIVE / SETTLED
  bool _isSubmitting = false;

  // ---------- Getters ----------
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedFilter => _selectedFilter;
  bool get isSubmitting => _isSubmitting;

  // ---------- Stream for the list ----------
  Stream<List<Contact>> get contactsStream {
    return _contactService.watchActiveContacts(
      userId: userId,
      searchQuery: _searchQuery,
      filterType: _selectedFilter,
    );
  }

  // ---------- Search ----------
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ---------- Filter ----------
  void setFilter(String? filter) {
    // Accept only valid values or null
    if (filter == null ||
        filter == ContactBalanceType.willGet ||
        filter == ContactBalanceType.willGive ||
        filter == ContactBalanceType.settled) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }

  // ---------- Clear error ----------
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ---------- Create Contact ----------
  Future<bool> createContact({
    required String name,
    required String phone,
    required int openingAmount,
    required String openingType,
    String? description,
  }) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _contactService.createContact(
        userId: userId,
        name: name,
        phone: phone,
        openingAmount: openingAmount,
        openingType: openingType,
        description: description,
      );
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // ---------- Deactivate Contact ----------
  Future<bool> deactivateContact(int contactId) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _contactService.deactivateContact(
        userId: userId,
        contactId: contactId,
      );
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // ---------- Recalculate balance (will be used by transactions later) ----------
  Future<void> recalculateBalance(int contactId) async {
    await _contactService.recalculateContactBalance(
      userId: userId,
      contactId: contactId,
    );
  }
}