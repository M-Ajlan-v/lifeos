import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'add_edit_habit_screen.dart';
import 'habit_detail_screen.dart';

class HabitScreen extends StatelessWidget {
  const HabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditHabitScreen()),
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

          final habits = provider.habits;

          if (habits.isEmpty) {
            return const Center(child: Text('No habits yet'));
          }

          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return _HabitTile(habit: habit);
            },
          );
        },
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  final Habit habit;

  const _HabitTile({required this.habit});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HteProvider?>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(habit.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (habit.description != null && habit.description!.isNotEmpty)
              Text(habit.description!),
            Text(
              'Daily at ${habit.time}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              tooltip: 'Mark Done today',
              onPressed: () async {
                if (provider != null) {
                  await provider.markHabitDone(habit.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marked as Done for today')),
                    );
                  }
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Habit'),
                    content: const Text(
                      'This will permanently deactivate the habit.\nHistory will be kept but hidden.',
                    ),
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
                  await provider.deleteHabit(habit.id);
                }
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HabitDetailScreen(habit: habit),
            ),
          );
        },
      ),
    );
  }
}