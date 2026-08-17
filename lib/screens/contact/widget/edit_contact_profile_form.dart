import 'package:flutter/material.dart';
import 'package:lifeos/screens/contact/widget/edit_contact_field.dart';

class EditContactProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController descriptionController;

  const EditContactProfileForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditContactField(
          controller: nameController,
          label: 'Name *',
          icon: Icons.person_outline_rounded,
          textCapitalization: TextCapitalization.words,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        EditContactField(
          controller: phoneController,
          label: 'Phone *',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: const [],
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Phone is required';
            }

            if (v.trim().length != 10) {
              return 'Enter valid 10 digit number';
            }

            return null;
          },
          phoneInput: true,
        ),

        const SizedBox(height: 16),

        EditContactField(
          controller: descriptionController,
          label: 'Description (optional)',
          icon: Icons.notes_rounded,
          maxLines: 2,
          alignLabelWithHint: true,
        ),
      ],
    );
  }
}