import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:intl/intl.dart';
import 'add_edit_event_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String _filter = 'ALL'; // ALL | UPCOMING | PAST

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => _filter = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'ALL', child: Text('All')),
              PopupMenuItem(value: 'UPCOMING', child: Text('Upcoming')),
              PopupMenuItem(value: 'PAST', child: Text('Past')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditEventScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<HteProvider?>(
        builder: (context, provider, _) {
          if (provider == null) {
            return const Center(child: Text('Please login'));
          }

          var events = provider.todosEvents
              .where((e) => e.type == 'EVENT')
              .toList();

          final now = DateTime.now();

          if (_filter == 'UPCOMING') {
            events = events.where((e) {
              if (e.date == null || e.time == null) return false;
              final dt = DateTime.parse('${e.date} ${e.time}');
              return dt.isAfter(now);
            }).toList();
          } else if (_filter == 'PAST') {
            events = events.where((e) {
              if (e.date == null || e.time == null) return true;
              final dt = DateTime.parse('${e.date} ${e.time}');
              return dt.isBefore(now);
            }).toList();
          }

          if (events.isEmpty) {
            return const Center(child: Text('No events yet'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final item = events[index];
              return _EventTile(item: item);
            },
          );
        },
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final TodosEvent item;

  const _EventTile({required this.item});

  bool get isPast {
    if (item.date == null || item.time == null) return false;
    final dt = DateTime.parse('${item.date} ${item.time}');
    return dt.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HteProvider?>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.description != null && item.description!.isNotEmpty)
              Text(item.description!),
            if (item.date != null)
              Text(
                '${item.date} ${item.time ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: isPast ? Colors.red : Colors.grey,
                ),
              ),
            if (isPast)
              const Text(
                'PAST',
                style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Event'),
                content: const Text('Are you sure?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirm == true && provider != null) {
              await provider.deleteTodoEvent(item.id);
            }
          },
        ),
        onTap: isPast
            ? null // locked after fired / past (except delete which is always allowed)
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditEventScreen(existing: item),
                  ),
                );
              },
      ),
    );
  }
}