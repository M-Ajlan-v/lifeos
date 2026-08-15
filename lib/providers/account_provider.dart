import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/account_service.dart';

class AccountProvider with ChangeNotifier {
  final AccountService _accountService;
  final int userId;

  AccountProvider({
    required AccountService accountService,
    required this.userId,
  }) : _accountService = accountService;

  bool _isSubmitting = false;
  String? _error;

  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Stream<List<Account>> get accountsStream {
    return _accountService.watchActiveAccounts(userId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> createAccount({
    required String name,
    required String type,
    required int openingBalance,
  }) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _accountService.createAccount(
        userId: userId,
        name: name,
        type: type,
        openingBalance: openingBalance,
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

  Future<bool> updateAccount({
    required int accountId,
    required String name,
    required String type,
  }) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _accountService.updateAccount(
        userId: userId,
        accountId: accountId,
        name: name,
        type: type,
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

  Future<bool> deactivateAccount(int accountId) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _accountService.deactivateAccount(
        userId: userId,
        accountId: accountId,
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
}