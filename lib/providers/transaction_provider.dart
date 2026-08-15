import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService;
  final int userId;

  TransactionProvider({
    required TransactionService transactionService,
    required this.userId,
  }) : _transactionService = transactionService;

  bool _isSubmitting = false;
  String? _error;

  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Stream<List<Transaction>> get transactionsStream {
    return _transactionService.watchActiveTransactions(userId);
  }
  Stream<List<Transaction>> get cashbookStream {
    return _transactionService.watchCashbookTransactions(userId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> createTransaction({
    required String type,
    required int amount,
    required int accountId,
    int? toAccountId,
    int? contactId,
    int? categoryId,
    String? description,
    required DateTime transactionDate,
  }) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _transactionService.createTransaction(
        userId: userId,
        type: type,
        amount: amount,
        accountId: accountId,
        toAccountId: toAccountId,
        contactId: contactId,
        categoryId: categoryId,
        description: description,
        transactionDate: transactionDate,
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

  Future<bool> softDeleteTransaction(int transactionId) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _transactionService.softDeleteTransaction(
        userId: userId,
        transactionId: transactionId,
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