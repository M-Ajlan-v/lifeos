import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/hte_provider.dart';

import 'add_edit_todo_screen.dart';
import 'widget/todo_empty_state.dart';
import 'widget/todo_tile.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Todos',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppTheme.buttonGradient,
                borderRadius: BorderRadius.circular(13),
                boxShadow: AppTheme.violetGlow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddEditTodoScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<HteProvider?>(
  builder: (context, provider, _) {
    if (provider == null) {
      return const Center(
        child: Text(
          'Please login',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 14,
          ),
        ),
      );
    }

    return StreamBuilder<List<TodosEvent>>(
      stream: provider.todosEventsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
                ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final allItems =
            snapshot.data ?? const <TodosEvent>[];

        final todos = allItems
            .where(
              (e) =>
                  e.type.trim().toUpperCase() == 'TODO',
            )
            .toList();

        if (todos.isEmpty) {
          return const TodoEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            110,
          ),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final item = todos[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TodoTile(
                item: item,
              ),
            );
          },
        );
      },
    );
  },
),
    );
  }
}