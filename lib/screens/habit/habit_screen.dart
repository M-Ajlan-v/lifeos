import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/hte_provider.dart';

import 'add_edit_habit_screen.dart';
import 'widget/habit_empty_state.dart';
import 'widget/habit_tile.dart';

class HabitScreen extends StatelessWidget {
  const HabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,

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
                        builder: (_) => const AddEditHabitScreen(),
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

          return StreamBuilder<List<Habit>>(
  stream: provider.habitsStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState ==
            ConnectionState.waiting &&
        !snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final habits =
        snapshot.data ?? const <Habit>[];

    if (habits.isEmpty) {
      return const HabitEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        110,
      ),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: HabitTile(
            habit: habit,
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