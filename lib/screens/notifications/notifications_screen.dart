import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/reminder_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();
    final logs = reminderProvider.logs;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: logs.isEmpty
          ? const Center(child: Text('No notifications yet'))
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 12,
                    color: log.status == 'UNSEEN' ? Colors.red : Colors.grey,
                  ),
                  title: Text('Reminder #${log.reminderId}'),
                  subtitle: Text(log.firedAt?.toLocal().toString() ?? ''),
                  onTap: () => reminderProvider.markSeen(log.id),
                );
              },
            ),
    );
  }
}