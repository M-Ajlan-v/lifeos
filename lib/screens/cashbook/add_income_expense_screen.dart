import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/category_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/database/app_database.dart';

class AddIncomeExpenseScreen extends StatefulWidget {
  final String type; // 'INCOME' or 'EXPENSE'

  const AddIncomeExpenseScreen({super.key, required this.type});

  @override
  State<AddIncomeExpenseScreen> createState() => _AddIncomeExpenseScreenState();
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
        const SnackBar(content: Text('Please select an account')),
      );
      return;
    }

    final categoryName = _categoryController.text.trim();
    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category')),
      );
      return;
    }

    final txProvider = context.read<TransactionProvider?>();
    final categoryProvider = context.read<CategoryProvider?>();
    final authUserId = context.read<TransactionProvider?>()?.userId;

    if (txProvider == null || authUserId == null || categoryProvider == null) return;

    try {
      // 1. Get or create category
      final categoryId = await categoryProvider.getOrCreateCategory(
        type: widget.type,
        name: categoryName,
      );

      // 2. Create transaction
      final amount = int.parse(_amountController.text.trim());
      final description = _descriptionController.text.trim();

      if (widget.type == 'EXPENSE' && _selectedAccount != null && amount > _selectedAccount!.openingBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot add expense. This expense is ₹$amount, but the selected account balance is ₹${_selectedAccount!.openingBalance}.',
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
    final categoryProvider = context.watch<CategoryProvider?>();
    final isSubmitting = txProvider?.isSubmitting ?? false;
    final userId = txProvider?.userId;

    final isIncome = widget.type == 'INCOME';

    return Scaffold(
      appBar: AppBar(
        title: Text(isIncome ? 'Add Income' : 'Add Expense'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Amount
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

              // Account
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

              // Category (with suggestions)
              if (userId != null && categoryProvider != null)
                StreamBuilder<List<Category>>(
                  stream: categoryProvider.categoriesStream(widget.type),
                  builder: (context, snapshot) {
                    final categories = snapshot.data ?? [];

                    return Autocomplete<String>(
                      optionsBuilder: (textEditingValue) {
                        final query = textEditingValue.text.trim().toLowerCase();

                        final filtered = categories.where((c) {
                          final name = c.name.toLowerCase();
                          if (query.isEmpty) return true;
                          return name.contains(query);
                        }).toList();

                        filtered.sort((a, b) {
                          final aName = a.name.toLowerCase();
                          final bName = b.name.toLowerCase();

                          if (query.isEmpty) {
                            return aName.compareTo(bName);
                          }

                          final aRank = aName.startsWith(query)
                              ? 0
                              : (aName.contains(query) ? 1 : 2);
                          final bRank = bName.startsWith(query)
                              ? 0
                              : (bName.contains(query) ? 1 : 2);

                          if (aRank != bRank) {
                            return aRank.compareTo(bRank);
                          }

                          final aIndex = aName.indexOf(query);
                          final bIndex = bName.indexOf(query);

                          if (aIndex != bIndex) {
                            final aPos = aIndex == -1 ? 999 : aIndex;
                            final bPos = bIndex == -1 ? 999 : bIndex;
                            return aPos.compareTo(bPos);
                          }

                          final aLen = aName.length;
                          final bLen = bName.length;

                          if (aLen != bLen) {
                            return aLen.compareTo(bLen);
                          }

                          return aName.compareTo(bName);
                        });

                        return filtered.map((c) => c.name).toList();
                      },
                      onSelected: (value) {
                        _categoryController.text = value;
                        _selectedCategoryName = value;
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 220),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        controller.text = _categoryController.text;
                        controller.selection = _categoryController.selection;

                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Category *',
                            border: OutlineInputBorder(),
                            hintText: 'Type a category or select one',
                          ),
                          textCapitalization: TextCapitalization.words,
                          onChanged: (value) {
                            _categoryController.text = value;
                            _categoryController.selection = TextSelection.collapsed(
                              offset: value.length,
                            );
                          },
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Category is required';
                            }
                            return null;
                          },
                        );
                      },
                    );
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

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isIncome ? Colors.green : Colors.red,
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
                          isIncome ? 'Save Income' : 'Save Expense',
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