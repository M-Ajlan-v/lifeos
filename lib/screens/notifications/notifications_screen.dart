import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Consumer<HteProvider?>(
        builder: (context, provider, _) {
          if (provider == null) {
            return const Center(child: Text('Please login'));
          }

          final logs = provider.firedNotifications;

          if (logs.isEmpty) {
            return const Center(
              child: Text('No notifications yet'),
            );
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _NotificationTile(log: log);
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationLogData log;

  const _NotificationTile({required this.log});

  IconData get _icon {
    switch (log.sourceType) {
      case 'TODO':
        return Icons.check_box;
      case 'EVENT':
        return Icons.event;
      case 'HABIT':
        return Icons.repeat;
      default:
        return Icons.notifications;
    }
  }

  Color get _color {
    switch (log.sourceType) {
      case 'TODO':
        return Colors.blue;
      case 'EVENT':
        return Colors.orange;
      case 'HABIT':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firedAt = log.firedAt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(log.firedAt!)
        : 'Unknown time';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _color.withOpacity(0.15),
          child: Icon(_icon, color: _color),
        ),
        title: Text(log.title ?? 'Notification'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (log.body != null && log.body!.isNotEmpty)
              Text(log.body!),
            const SizedBox(height: 4),
            Text(
              firedAt,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              log.sourceType ?? '',
              style: TextStyle(
                fontSize: 11,
                color: _color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}