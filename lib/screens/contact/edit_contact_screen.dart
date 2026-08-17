import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/contact/widget/edit_contact_profile_form.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  const EditContactScreen({
    super.key,
    required this.contact,
  });

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _descriptionController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.contact.name,
    );

    _phoneController = TextEditingController(
      text: widget.contact.phone,
    );

    _descriptionController = TextEditingController(
      text: widget.contact.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final contactService = context.read<ContactService>();
    final contactProvider = context.read<ContactProvider?>();

    if (contactProvider == null) {
      setState(() => _isSubmitting = false);
      return;
    }

    final newName = _nameController.text.trim();
    final newPhone = _phoneController.text.trim();
    final newDescription = _descriptionController.text.trim();

    try {
      await contactService.updateContactProfile(
        userId: contactProvider.userId,
        contactId: widget.contact.id,
        name: newName,
        phone: newPhone,
        description: newDescription.isEmpty ? null : newDescription,
      );

      if (!mounted) return;

      Navigator.pop(context, true); // success
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Edit Contact',
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
              EditContactProfileForm(
                nameController: _nameController,
                phoneController: _phoneController,
                descriptionController: _descriptionController,
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _isSubmitting
                        ? null
                        : AppTheme.buttonGradient,
                    color: _isSubmitting
                        ? AppTheme.surface
                        : null,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: _isSubmitting
                        ? null
                        : [
                            BoxShadow(
                              color: AppTheme.violet.withOpacity(0.24),
                              blurRadius: 18,
                              spreadRadius: -4,
                              offset: const Offset(0, 7),
                            ),
                          ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppTheme.textPrimary,
                      disabledForegroundColor: AppTheme.textMuted,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.textPrimary,
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
                                'Save Changes',
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