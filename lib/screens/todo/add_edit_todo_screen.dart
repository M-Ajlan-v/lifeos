import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';

import 'widget/todo_text_field.dart';
import 'widget/todo_notification_toggle.dart';
import 'widget/todo_schedule_field.dart';
import 'widget/todo_save_button.dart';

class AddEditTodoScreen extends StatefulWidget {
  final TodosEvent? existing;

  const AddEditTodoScreen({
    super.key,
    this.existing,
  });

  @override
  State<AddEditTodoScreen> createState() =>
      _AddEditTodoScreenState();
}

class _AddEditTodoScreenState
    extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  bool _notificationEnabled = false;

  DateTime? _selectedDate;
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

    _notificationEnabled =
        widget.existing?.notificationEnabled == 1;

    if (widget.existing?.date != null) {
      _selectedDate = DateTime.parse(
        widget.existing!.date!,
      );
    }

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

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(
        const Duration(days: 365 * 2),
      ),
    );

    if (picked != null) {
      setState(
        () => _selectedDate = picked,
      );
    }
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

    if (_notificationEnabled) {
      if (_selectedDate == null ||
          _selectedTime == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Please select date and time',
            ),
          ),
        );

        return;
      }

      final now = DateTime.now();

      final scheduled = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      if (scheduled.isBefore(now)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Time must be in the future',
            ),
          ),
        );

        return;
      }
    }

    final provider =
        context.read<HteProvider?>();

    if (provider == null) return;

    final dateStr = _selectedDate != null
        ? DateFormat('yyyy-MM-dd')
            .format(_selectedDate!)
        : null;

    final timeStr = _selectedTime != null
        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
        : null;

    if (widget.existing == null) {
      await provider.createTodoEvent(
        type: 'TODO',
        title: _titleCtrl.text.trim(),
        description:
            _descCtrl.text.trim().isEmpty
                ? null
                : _descCtrl.text.trim(),
        notificationEnabled:
            _notificationEnabled,
        date: dateStr,
        time: timeStr,
      );
    } else {
      await provider.updateTodoEvent(
        id: widget.existing!.id,
        title: _titleCtrl.text.trim(),
        description:
            _descCtrl.text.trim().isEmpty
                ? null
                : _descCtrl.text.trim(),
        notificationEnabled:
            _notificationEnabled,
        date: dateStr,
        time: timeStr,
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        surfaceTintColor: Colors.transparent,
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
          isEdit ? 'Edit Todo' : 'New Todo',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
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
              // =========================================================
              // HEADER
              // =========================================================
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
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient:
                            AppTheme.violetBrightGradient,
                        borderRadius:
                            BorderRadius.circular(14),
                        boxShadow:
                            AppTheme.violetGlow,
                      ),
                      child: const Icon(
                        Icons.task_alt_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            isEdit
                                ? 'Update your task'
                                : 'Create a new task',
                            style:
                                const TextStyle(
                              color: AppTheme
                                  .textPrimary,
                              fontFamily:
                                  'Outfit',
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                              height: 3),
                          Text(
                            isEdit
                                ? 'Change the task details or reminder.'
                                : 'Add details and optionally schedule a reminder.',
                            style:
                                const TextStyle(
                              color: AppTheme
                                  .textSecondary,
                              fontFamily:
                                  'Outfit',
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // =========================================================
              // DETAILS
              // =========================================================
              const Text(
                'Task Details',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 11),

              TodoTextField(
                controller: _titleCtrl,
                label: 'Title *',
                hint: 'Enter task title',
                icon:
                    Icons.title_rounded,
                validator: (v) =>
                    v == null ||
                            v.trim().isEmpty
                        ? 'Title is required'
                        : null,
              ),

              const SizedBox(height: 12),

              TodoTextField(
                controller: _descCtrl,
                label:
                    'Description (optional)',
                hint:
                    'Add more details about this task',
                icon: Icons
                    .notes_rounded,
                maxLines: 4,
              ),

              const SizedBox(height: 22),

              // =========================================================
              // REMINDER
              // =========================================================
              const Text(
                'Reminder',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 11),

              TodoNotificationToggle(
                value: _notificationEnabled,
                onChanged: (v) {
                  setState(
                    () =>
                        _notificationEnabled =
                            v,
                  );
                },
              ),

              if (_notificationEnabled) ...[
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child:
                          TodoScheduleField(
                        label: 'Date',
                        value:
                            _selectedDate ==
                                    null
                                ? 'Select date'
                                : DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(
                                    _selectedDate!,
                                  ),
                        icon: Icons
                            .calendar_month_rounded,
                        onTap: _pickDate,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child:
                          TodoScheduleField(
                        label: 'Time',
                        value:
                            _selectedTime ==
                                    null
                                ? 'Select time'
                                : _selectedTime!
                                    .format(
                                      context,
                                    ),
                        icon: Icons
                            .schedule_rounded,
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 28),

              TodoSaveButton(
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