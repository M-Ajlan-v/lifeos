import 'package:flutter/material.dart';
import 'package:lifeos/screens/cashbook/widget/cashbook_account_field.dart';
import 'package:lifeos/screens/cashbook/widget/cashbook_amount_field.dart';
import 'package:lifeos/screens/cashbook/widget/cashbook_category_field.dart';
import 'package:lifeos/screens/cashbook/widget/cashbook_date_field.dart';
import 'package:lifeos/screens/cashbook/widget/cashbook_description_field.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/category_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class AddIncomeExpenseScreen extends StatefulWidget {
  final String type; // 'INCOME', 'EXPENSE', 'GAVE', 'GOT'
  final int? contactId;

  const AddIncomeExpenseScreen({
    super.key,
    required this.type,
    this.contactId,
  });

  @override
  State<AddIncomeExpenseScreen> createState() =>
      _AddIncomeExpenseScreenState();
}

class _AddIncomeExpenseScreenState extends State<AddIncomeExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  Account? _selectedAccount;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryName;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an account'),
        ),
      );
      return;
    }

    final categoryName = _categoryController.text.trim();

    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category'),
        ),
      );
      return;
    }

    final txProvider = context.read<TransactionProvider?>();
    final categoryProvider = context.read<CategoryProvider?>();
    final authUserId = context.read<TransactionProvider?>()?.userId;

    if (txProvider == null ||
        authUserId == null ||
        categoryProvider == null) {
      return;
    }

    try {
      // 1. Get or create category
      final categoryId = await categoryProvider.getOrCreateCategory(
        type: widget.type,
        name: categoryName,
      );

      // 2. Create transaction
      final amount = int.parse(_amountController.text.trim());
      final description = _descriptionController.text.trim();

      if (widget.type == 'EXPENSE' &&
          _selectedAccount != null &&
          amount > _selectedAccount!.openingBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot add expense. This expense is ₹$amount, '
              'but the selected account balance is '
              '₹${_selectedAccount!.openingBalance}.',
            ),
          ),
        );
        return;
      }

      final success = await txProvider.createTransaction(
        type: widget.type,
        amount: amount,
        accountId: _selectedAccount!.id,
        categoryId: categoryId,
        description: description.isEmpty ? null : description,
        transactionDate: _selectedDate.toUtc(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              txProvider.error ?? 'Unable to save',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();
    final accountProvider = context.watch<AccountProvider?>();
    final categoryProvider = context.watch<CategoryProvider?>();

    final isSubmitting = txProvider?.isSubmitting ?? false;
    final userId = txProvider?.userId;

    final isIncome = widget.type == 'INCOME';
    final isContactTransaction =
        widget.type == 'GAVE' || widget.type == 'GOT';

    final accentColor = isIncome
        ? AppTheme.income
        : AppTheme.expense;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
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
        iconTheme: const IconThemeData(
          color: AppTheme.textPrimary,
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withOpacity(0.22),
                ),
              ),
              child: Icon(
                isIncome
                    ? Icons.south_west_rounded
                    : Icons.north_east_rounded,
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isIncome ? 'Add Income' : 'Add Expense',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              28,
            ),
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              // ---------------------------------------------------------
              // HEADER
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: isIncome
                      ? const LinearGradient(
                          colors: [
                            AppTheme.incomeDark,
                            AppTheme.cardElevated,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [
                            AppTheme.expenseDark,
                            AppTheme.cardElevated,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: accentColor.withOpacity(0.18),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isIncome
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isIncome
                            ? 'Record money coming into your account.'
                            : 'Record money spent from your account.',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ---------------------------------------------------------
              // AMOUNT
              // ---------------------------------------------------------
              CashbookAmountField(
                controller: _amountController,
                accentColor: accentColor,
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------
              // ACCOUNT
              // ---------------------------------------------------------
              CashbookAccountField(
                accountStream: accountProvider?.accountsStream,
                selectedAccount: _selectedAccount,
                onChanged: (value) {
                  setState(() => _selectedAccount = value);
                },
              ),

              // ---------------------------------------------------------
              // CATEGORY
              // ---------------------------------------------------------
              if (!isContactTransaction &&
                  userId != null &&
                  categoryProvider != null) ...[
                const SizedBox(height: 16),
                CashbookCategoryField(
                  categoryProvider: categoryProvider,
                  type: widget.type,
                  controller: _categoryController,
                  selectedCategoryName: _selectedCategoryName,
                  accentColor: accentColor,
                  onSelected: (value) {
                    _categoryController.text = value;
                    _selectedCategoryName = value;
                  },
                ),
              ],

              const SizedBox(height: 16),

              // ---------------------------------------------------------
              // DATE
              // ---------------------------------------------------------
              CashbookDateField(
                selectedDate: _selectedDate,
                accentColor: accentColor,
                onTap: _pickDate,
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------
              // DESCRIPTION
              // ---------------------------------------------------------
              CashbookDescriptionField(
                controller: _descriptionController,
                accentColor: accentColor,
              ),

              const SizedBox(height: 30),

              // ---------------------------------------------------------
              // SAVE
              // ---------------------------------------------------------
              SizedBox(
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: isSubmitting
                        ? null
                        : LinearGradient(
                            colors: isIncome
                                ? const [
                                    AppTheme.incomeDark,
                                    AppTheme.income,
                                  ]
                                : const [
                                    AppTheme.expenseDark,
                                    AppTheme.expense,
                                  ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                    color: isSubmitting
                        ? AppTheme.surface
                        : null,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: isSubmitting
                        ? null
                        : [
                            BoxShadow(
                              color: accentColor.withOpacity(0.22),
                              blurRadius: 18,
                              spreadRadius: -4,
                              offset: const Offset(0, 7),
                            ),
                          ],
                  ),
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: AppTheme.textMuted,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.textPrimary,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isIncome
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                size: 19,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isIncome
                                    ? 'Save Income'
                                    : 'Save Expense',
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}