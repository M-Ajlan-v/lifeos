import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
      appBar: AppBar(
        title: const Text('Add Transfer'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // From Account
              StreamBuilder<List<Account>>(
                stream: accountProvider?.accountsStream,
                builder: (context, snapshot) {
                  final accounts = snapshot.data ?? [];
                  return DropdownButtonFormField<Account>(
                    value: _fromAccount,
                    decoration: const InputDecoration(
                      labelText: 'From Account *',
                      border: OutlineInputBorder(),
                    ),
                    items: accounts.map((a) {
                      return DropdownMenuItem(
                        value: a,
                        child: Text(
                          '${a.name} (₹${a.openingBalance})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _fromAccount = value),
                    validator: (v) =>
                        v == null ? 'Select from account' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // To Account
              StreamBuilder<List<Account>>(
                stream: accountProvider?.accountsStream,
                builder: (context, snapshot) {
                  final accounts = snapshot.data ?? [];
                  return DropdownButtonFormField<Account>(
                    value: _toAccount,
                    decoration: const InputDecoration(
                      labelText: 'To Account *',
                      border: OutlineInputBorder(),
                    ),
                    items: accounts.map((a) {
                      return DropdownMenuItem(
                        value: a,
                        child: Text(
                          '${a.name} (₹${a.openingBalance})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _toAccount = value),
                    validator: (v) =>
                        v == null ? 'Select to account' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
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

              // Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Transfer',
                          style: TextStyle(fontSize: 16),
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