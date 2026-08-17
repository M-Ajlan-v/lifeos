import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos/screens/account/widget/account_balance_field.dart';
import 'package:lifeos/screens/account/widget/account_type_selector.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/account_provider.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  String _selectedType = 'CASH';

  final List<String> _types = ['CASH', 'BANK', 'UPI', 'OTHER'];

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AccountProvider?>();
    if (provider == null) return;

    final name = _nameController.text.trim();
    final balanceText = _balanceController.text.trim();
    final balance = balanceText.isEmpty ? 0 : int.parse(balanceText);

    final success = await provider.createAccount(
      name: name,
      type: _selectedType,
      openingBalance: balance,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Unable to create account',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider?>();
    final isSubmitting = provider?.isSubmitting ?? false;

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
          'Add Account',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 21,
            fontWeight: FontWeight.w700,
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
              // Header
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
                        Icons.account_balance_wallet_rounded,
                        color: AppTheme.violetBright,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add a new account to your cashbook',
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

              const SizedBox(height: 26),

              const _SectionLabel(
                icon: Icons.edit_rounded,
                label: 'ACCOUNT DETAILS',
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  labelText: 'Account Name *',
                  hintText: 'e.g. Cash, SBI, Paytm',
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: 'Outfit',
                  ),
                  hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                    fontFamily: 'Outfit',
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: AppTheme.violetBright,
                    fontFamily: 'Outfit',
                  ),
                  filled: true,
                  fillColor: AppTheme.cardElevated,
                  prefixIcon: const Icon(
                    Icons.account_balance_rounded,
                    color: AppTheme.violetBright,
                    size: 20,
                  ),
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
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              const _SectionLabel(
                icon: Icons.category_rounded,
                label: 'ACCOUNT TYPE',
              ),

              const SizedBox(height: 10),

              AccountTypeSelector(
                types: _types,
                selectedType: _selectedType,
                onSelected: (type) {
                  setState(() => _selectedType = type);
                },
              ),

              const SizedBox(height: 24),

              const _SectionLabel(
                icon: Icons.payments_rounded,
                label: 'OPENING BALANCE',
              ),

              const SizedBox(height: 10),

              AccountBalanceField(
                controller: _balanceController,
              ),

              const SizedBox(height: 30),

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
                                Icons.add_rounded,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Save Account',
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