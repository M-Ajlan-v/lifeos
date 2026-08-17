import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/contact/widget/give_got_account_field.dart';
import 'package:lifeos/screens/contact/widget/give_got_date_field.dart';

class GiveGotScreen extends StatefulWidget {
  final String type; // 'GAVE' or 'GOT'
  final int contactId;

  const GiveGotScreen({
    super.key,
    required this.type,
    required this.contactId,
  });

  @override
  State<GiveGotScreen> createState() => _GiveGotScreenState();
}

class _GiveGotScreenState extends State<GiveGotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Account? _selectedAccount;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
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

    final txProvider = context.read<TransactionProvider?>();
    if (txProvider == null) return;

    try {
      final amount = int.parse(_amountController.text.trim());
      final description = _descriptionController.text.trim();

      // GAVE validation:
      // The amount being given cannot be greater than the
      // current balance of the selected account.
      if (widget.type == 'GAVE' &&
          amount > _selectedAccount!.openingBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot add Gave. This amount is ₹$amount, '
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
        contactId: widget.contactId,
        categoryId: null,
        toAccountId: null,
        description: description.isEmpty ? null : description,
        transactionDate: _selectedDate.toUtc(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
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
    final isSubmitting = txProvider?.isSubmitting ?? false;

    final isGave = widget.type == 'GAVE';
    final accentColor = isGave
        ? AppTheme.expense
        : AppTheme.income;

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
                isGave
                    ? Icons.north_east_rounded
                    : Icons.south_west_rounded,
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isGave ? 'Add Gave' : 'Add Got',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: AppTheme.textPrimary,
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
              // ---------- Header ----------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: isGave
                      ? LinearGradient(
                          colors: [
                            AppTheme.expenseDark,
                            AppTheme.cardElevated,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            AppTheme.incomeDark,
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
                        isGave
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isGave
                            ? 'Record money you gave to this contact.'
                            : 'Record money you got from this contact.',
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

              // ---------- Amount ----------
              TextFormField(
                controller: _amountController,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: accentColor,
                decoration: InputDecoration(
                  labelText: 'Amount *',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: accentColor,
                  ),
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(
                    color: accentColor,
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: Icon(
                    Icons.currency_rupee_rounded,
                    color: accentColor,
                  ),
                  filled: true,
                  fillColor: AppTheme.cardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppTheme.glassBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppTheme.glassBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(
                      color: accentColor,
                      width: 1.2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppTheme.expense,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppTheme.expense,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Amount is required';
                  }

                  final n = int.tryParse(v.trim());

                  if (n == null || n <= 0) {
                    return 'Enter valid amount';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ---------- Account ----------
              GiveGotAccountField(
                accountStream: accountProvider?.accountsStream,
                selectedAccount: _selectedAccount,
                onChanged: (value) {
                  setState(() => _selectedAccount = value);
                },
              ),

              const SizedBox(height: 16),

              // ---------- Date ----------
              GiveGotDateField(
                selectedDate: _selectedDate,
                accentColor: accentColor,
                onTap: _pickDate,
              ),

              const SizedBox(height: 16),

              // ---------- Description ----------
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                ),
                cursorColor: accentColor,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: accentColor,
                  ),
                  hintText: 'Add a note about this transaction',
                  hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Icon(
                      Icons.notes_rounded,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: AppTheme.cardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppTheme.glassBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppTheme.glassBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(
                      color: accentColor,
                      width: 1.2,
                    ),
                  ),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 30),

              // ---------- Save ----------
              SizedBox(
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: isSubmitting
                        ? null
                        : LinearGradient(
                            colors: isGave
                                ? [
                                    AppTheme.expenseDark,
                                    AppTheme.expense,
                                  ]
                                : [
                                    AppTheme.incomeDark,
                                    AppTheme.income,
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
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                isGave
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                size: 19,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isGave
                                    ? 'Save Gave'
                                    : 'Save Got',
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