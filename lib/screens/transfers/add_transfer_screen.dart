import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos/screens/transfers/widget/cashbook_transfer_account_field.dart';
import 'package:lifeos/screens/transfers/widget/cashbook_transfer_date_field.dart';
import 'package:lifeos/screens/transfers/widget/cashbook_transfer_description_field.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';

class AddTransferScreen extends StatefulWidget {
  const AddTransferScreen({super.key});

  @override
  State<AddTransferScreen> createState() => _AddTransferScreenState();
}

class _AddTransferScreenState extends State<AddTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Account? _fromAccount;
  Account? _toAccount;
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

    if (_fromAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select from account')),
      );
      return;
    }

    if (_toAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select to account')),
      );
      return;
    }

    // From and To account cannot be the same
    if (_fromAccount!.id == _toAccount!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('From and to accounts must be different'),
        ),
      );
      return;
    }

    final txProvider = context.read<TransactionProvider?>();
    if (txProvider == null) return;

    try {
      final amount = int.parse(_amountController.text.trim());
      final description = _descriptionController.text.trim();

      // From account must have enough balance
      if (_fromAccount!.openingBalance < amount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Insufficient balance. Available: ₹${_fromAccount!.openingBalance}',
            ),
          ),
        );
        return;
      }

      final success = await txProvider.createTransaction(
        type: 'TRANSFER',
        amount: amount,
        accountId: _fromAccount!.id,
        toAccountId: _toAccount!.id,
        contactId: null,
        categoryId: null,
        description: description.isEmpty ? null : description,
        transactionDate: _selectedDate.toUtc(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(txProvider.error ?? 'Unable to save')),
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
        title: const Text(
          'Add Transfer',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
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
              32,
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppTheme.violetGlowGradient,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.glassBorderStrong,
                  ),
                  boxShadow: AppTheme.violetGlow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.violet.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.violetBright.withOpacity(0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppTheme.violetBright,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transfer Money',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Move money between your accounts',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontFamily: 'Outfit',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const _SectionLabel(
                icon: Icons.account_balance_wallet_rounded,
                label: 'ACCOUNTS',
              ),

              const SizedBox(height: 10),

              StreamBuilder<List<Account>>(
                stream: accountProvider?.accountsStream,
                builder: (context, snapshot) {
                  final accounts = snapshot.data ?? [];

                  Account? dropdownValue;
                  if (_fromAccount != null) {
                    final matches =
                        accounts.where((a) => a.id == _fromAccount!.id);
                    dropdownValue =
                        matches.isNotEmpty ? matches.first : null;
                  }

                  return CashbookTransferAccountField(
                    label: 'From Account *',
                    value: dropdownValue,
                    accounts: accounts,
                    onChanged: (value) =>
                        setState(() => _fromAccount = value),
                    validator: (v) =>
                        v == null ? 'Select from account' : null,
                  );
                },
              ),

              const SizedBox(height: 14),

              StreamBuilder<List<Account>>(
                stream: accountProvider?.accountsStream,
                builder: (context, snapshot) {
                  final accounts = snapshot.data ?? [];

                  Account? dropdownValue;
                  if (_toAccount != null) {
                    final matches =
                        accounts.where((a) => a.id == _toAccount!.id);
                    dropdownValue =
                        matches.isNotEmpty ? matches.first : null;
                  }

                  return CashbookTransferAccountField(
                    label: 'To Account *',
                    value: dropdownValue,
                    accounts: accounts,
                    onChanged: (value) =>
                        setState(() => _toAccount = value),
                    validator: (v) =>
                        v == null ? 'Select to account' : null,
                  );
                },
              ),

              const SizedBox(height: 24),

              const _SectionLabel(
                icon: Icons.payments_rounded,
                label: 'TRANSFER DETAILS',
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _amountController,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount *',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: 'Outfit',
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: AppTheme.violetBright,
                    fontFamily: 'Outfit',
                  ),
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                    color: AppTheme.violetBright,
                    fontFamily: 'Outfit',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  filled: true,
                  fillColor: AppTheme.cardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.cardBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.cardBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.violetBright,
                      width: 1.4,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.expense,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.expense,
                      width: 1.4,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    color: AppTheme.expense,
                    fontFamily: 'Outfit',
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

              const SizedBox(height: 14),

              CashbookTransferDateField(
                selectedDate: _selectedDate,
                onTap: _pickDate,
              ),

              const SizedBox(height: 14),

              CashbookTransferDescriptionField(
                controller: _descriptionController,
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: AppTheme.buttonHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: isSubmitting
                        ? null
                        : AppTheme.buttonGradient,
                    color: isSubmitting
                        ? AppTheme.surface
                        : null,
                    borderRadius: BorderRadius.circular(
                      AppTheme.radiusMedium,
                    ),
                    boxShadow: isSubmitting
                        ? null
                        : AppTheme.violetGlow,
                  ),
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppTheme.textPrimary,
                      disabledForegroundColor: AppTheme.textMuted,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.violetBright,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.swap_horiz_rounded,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Save Transfer',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
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

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionLabel({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 2),
        Icon(
          icon,
          size: 14,
          color: AppTheme.violetBright,
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}