import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';

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
        const SnackBar(content: Text('Please select an account')),
      );
      return;
    }

    final txProvider = context.read<TransactionProvider?>();
    if (txProvider == null) return;

    try {
      final amount = int.parse(_amountController.text.trim());
      final description = _descriptionController.text.trim();

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
          SnackBar(content: Text(txProvider.error ?? 'Unable to save')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
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
        title: Text(widget.type == 'GAVE' ? 'Add Gave' : 'Add Got'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Amount is required';
                  final n = int.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Enter valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              StreamBuilder<List<Account>>(
                stream: accountProvider?.accountsStream,
                builder: (context, snapshot) {
                  final accounts = snapshot.data ?? [];
                  return DropdownButtonFormField<Account>(
                    value: _selectedAccount,
                    decoration: const InputDecoration(
                      labelText: 'Account *',
                      border: OutlineInputBorder(),
                    ),
                    items: accounts.map((a) {
                      return DropdownMenuItem(
                        value: a,
                        child: Text('${a.name} (₹${a.openingBalance})'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedAccount = value),
                    validator: (v) => v == null ? 'Select an account' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.type == 'GAVE' ? Colors.red : Colors.green,
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
                      : Text(
                          widget.type == 'GAVE' ? 'Save Gave' : 'Save Got',
                          style: const TextStyle(fontSize: 16),
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
