import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/constants/contact_balance_type.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/contact/widget/opening_type_selector.dart';

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
          const SnackBar(
            content: Text('Please select Got or Gave'),
          ),
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
        SnackBar(
          content: Text(error),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider?>();
    final isSubmitting = contactProvider?.isSubmitting ?? false;

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
          'Add Contact',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
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
                  gradient: AppTheme.violetGlowGradient,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppTheme.glassBorderStrong,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppTheme.violetBright,
                      size: 26,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Add a new contact and optionally record an opening balance.',
                        style: TextStyle(
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

              // ---------- Name ----------
              TextFormField(
                controller: _nameController,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                ),
                cursorColor: AppTheme.violetBright,
                decoration: InputDecoration(
                  labelText: 'Name *',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: AppTheme.violetBright,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppTheme.textSecondary,
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
                    borderSide: const BorderSide(
                      color: AppTheme.violet,
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
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                ),
                cursorColor: AppTheme.violetBright,
                decoration: InputDecoration(
                  labelText: 'Phone *',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: AppTheme.violetBright,
                  ),
                  hintText: '10 digit mobile number',
                  hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                  ),
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: AppTheme.textSecondary,
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
                    borderSide: const BorderSide(
                      color: AppTheme.violet,
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
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppTheme.violetBright,
                decoration: InputDecoration(
                  labelText: 'Opening Amount (optional)',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: AppTheme.violetBright,
                  ),
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppTheme.textSecondary,
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
                    borderSide: const BorderSide(
                      color: AppTheme.violet,
                      width: 1.2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onAmountChanged,
              ),

              const SizedBox(height: 16),

              // ---------- Opening Type ----------
              if (_typeEnabled) ...[
                OpeningTypeSelector(
                  openingType: _openingType,
                  onChanged: (value) {
                    setState(() {
                      _openingType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              // ---------- Description ----------
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                ),
                cursorColor: AppTheme.violetBright,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: AppTheme.violetBright,
                  ),
                  hintText: 'Add a note about this opening balance',
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
                    borderSide: const BorderSide(
                      color: AppTheme.violet,
                      width: 1.2,
                    ),
                  ),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 30),

              // ---------- Save Button ----------
              SizedBox(
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: isSubmitting
                        ? null
                        : AppTheme.buttonGradient,
                    color: isSubmitting
                        ? AppTheme.surface
                        : null,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: isSubmitting
                        ? null
                        : [
                            BoxShadow(
                              color: AppTheme.violet.withOpacity(0.25),
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
                              color: AppTheme.textPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Save Contact',
                                style: TextStyle(
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