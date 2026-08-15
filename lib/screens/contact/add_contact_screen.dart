import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/constants/contact_balance_type.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _openingType; // WILL_GET or WILL_GIVE or null (Settled)
  bool _typeEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    final amount = int.tryParse(value.trim()) ?? 0;
    setState(() {
      _typeEnabled = amount > 0;
      if (!_typeEnabled) {
        _openingType = null; // force Settled when amount is 0
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final contactProvider = context.read<ContactProvider?>();
    if (contactProvider == null) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final amountText = _amountController.text.trim();
    final amount = amountText.isEmpty ? 0 : int.parse(amountText);
    final description = _descriptionController.text.trim();

    // Decide opening type
    String openingType;
    if (amount == 0) {
      openingType = ContactBalanceType.settled;
    } else {
      if (_openingType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Got or Gave')),
        );
        return;
      }
      openingType = _openingType!;
    }

    final success = await contactProvider.createContact(
      name: name,
      phone: phone,
      openingAmount: amount,
      openingType: openingType,
      description: description.isEmpty ? null : description,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context); // go back to Contact list
    } else {
      final error = contactProvider.error ?? 'Unable to save contact';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider?>();
    final isSubmitting = contactProvider?.isSubmitting ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---------- Name ----------
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------- Phone ----------
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone *',
                  border: OutlineInputBorder(),
                  hintText: '10 digit mobile number',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone is required';
                  }
                  if (value.trim().length != 10) {
                    return 'Enter valid 10 digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------- Opening Amount ----------
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Opening Amount (optional)',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onAmountChanged,
              ),
              const SizedBox(height: 16),

              // ---------- Opening Type (Got / Gave) ----------
              if (_typeEnabled) ...[
                const Text(
                  'Opening Type *',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Got (Will Get)'),
                        selected: _openingType == ContactBalanceType.willGet,
                        onSelected: (selected) {
                          setState(() {
                            _openingType = selected
                                ? ContactBalanceType.willGet
                                : null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Gave (Will Give)'),
                        selected: _openingType == ContactBalanceType.willGive,
                        onSelected: (selected) {
                          setState(() {
                            _openingType = selected
                                ? ContactBalanceType.willGive
                                : null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // ---------- Description ----------
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // ---------- Save Button ----------
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _save,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save Contact',
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