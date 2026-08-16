import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:intl/intl.dart';
import 'add_edit_todo_screen.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
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

          final todos = provider.todosEvents
              .where((e) => e.type == 'TODO')
              .toList();

          if (todos.isEmpty) {
            return const Center(child: Text('No todos yet'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final item = todos[index];
              return _TodoTile(item: item);
            },
          );
        },
      ),
    );
  }
}

class _TodoTile extends StatelessWidget {
  final TodosEvent item;

  const _TodoTile({required this.item});

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
            if (item.notificationEnabled == 1 && item.date != null)
              Text(
                '${item.date} ${item.time ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Complete Todo'),
                    content: const Text('Mark as completed and delete?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Complete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && provider != null) {
                  await provider.completeTodo(item.id);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Todo'),
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
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTodoScreen(existing: item),
            ),
          );
        },
      ),
    );
  }
}