import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';

import 'widget/habit_text_field.dart';
import 'widget/habit_time_field.dart';
import 'widget/habit_save_button.dart';

class AddEditHabitScreen extends StatefulWidget {
  final Habit? existing;

  const AddEditHabitScreen({
    super.key,
    this.existing,
  });

  @override
  State<AddEditHabitScreen> createState() =>
      _AddEditHabitScreenState();
}

class _AddEditHabitScreenState
    extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(
      text: widget.existing?.title ?? '',
    );

    _descCtrl = TextEditingController(
      text: widget.existing?.description ?? '',
    );

    if (widget.existing?.time != null) {
      final parts =
          widget.existing!.time!.split(':');

      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(
        () => _selectedTime = picked,
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a daily reminder time',
          ),
        ),
      );

      return;
    }

    final provider =
        context.read<HteProvider?>();

    if (provider == null) return;

    final timeStr =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

    if (widget.existing == null) {
      await provider.createHabit(
        title: _titleCtrl.text.trim(),
        description:
            _descCtrl.text.trim().isEmpty
                ? null
                : _descCtrl.text.trim(),
        time: timeStr,
      );
    } else {
      await provider.updateHabit(
        id: widget.existing!.id,
        title: _titleCtrl.text.trim(),
        description:
            _descCtrl.text.trim().isEmpty
                ? null
                : _descCtrl.text.trim(),
        time: timeStr,
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit =
        widget.existing != null;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor:
            AppTheme.background,
        surfaceTintColor:
            Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textPrimary,
            size: 19,
          ),
        ),
        title: Text(
          isEdit
              ? 'Edit Habit'
              : 'New Habit',
          style: const TextStyle(
            color:
                AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
            padding:
                const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              32,
            ),
            children: [
              // -----------------------------------------------------------
              // HEADER
              // -----------------------------------------------------------
              Container(
                padding:
                    const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient:
                      AppTheme.purpleBlackGradient,
                  borderRadius:
                      BorderRadius.circular(22),
                  border: Border.all(
                    color:
                        AppTheme.glassBorderStrong,
                  ),
                  boxShadow:
                      AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient:
                            AppTheme.violetBrightGradient,
                        borderRadius:
                            BorderRadius.circular(15),
                        boxShadow:
                            AppTheme.violetGlow,
                      ),
                      child: const Icon(
                        Icons.repeat_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit
                                ? 'Update your habit'
                                : 'Build a new habit',
                            style:
                                const TextStyle(
                              color:
                                  AppTheme.textPrimary,
                              fontFamily:
                                  'Outfit',
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            isEdit
                                ? 'Change the habit details or daily reminder.'
                                : 'Create a routine and choose when you want to be reminded.',
                            style:
                                const TextStyle(
                              color:
                                  AppTheme.textSecondary,
                              fontFamily:
                                  'Outfit',
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // -----------------------------------------------------------
              // DETAILS TITLE
              // -----------------------------------------------------------
              const Text(
                'Habit Details',
                style: TextStyle(
                  color:
                      AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 11),

              HabitTextField(
                controller: _titleCtrl,
                label: 'Title *',
                hint:
                    'Enter habit title',
                icon:
                    Icons.edit_rounded,
                validator: (v) =>
                    v == null ||
                            v.trim().isEmpty
                        ? 'Title is required'
                        : null,
              ),

              const SizedBox(height: 12),

              HabitTextField(
                controller: _descCtrl,
                label:
                    'Description (optional)',
                hint:
                    'Add more details about this habit',
                icon:
                    Icons.notes_rounded,
                maxLines: 4,
              ),

              const SizedBox(height: 22),

              // -----------------------------------------------------------
              // DAILY REMINDER TITLE
              // -----------------------------------------------------------
              const Text(
                'Daily Reminder',
                style: TextStyle(
                  color:
                      AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 11),

              HabitTimeField(
                value: _selectedTime == null
                    ? 'Select Daily Reminder Time *'
                    : 'Daily at ${_selectedTime!.format(context)}',
                onTap: _pickTime,
              ),

              const SizedBox(height: 28),

              HabitSaveButton(
                label:
                    isEdit ? 'Update' : 'Create',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}