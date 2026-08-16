import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:intl/intl.dart';
import 'add_edit_habit_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  List<HabitHistoryData> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final provider = context.read<HteProvider?>();
    if (provider == null) return;

    final list = await provider.getHabitHistory(widget.habit.id);
    setState(() {
      _history = list;
      _loading = false;
    });
  }

  double get completionPercent {
    if (_history.isEmpty) return 0;
    final done = _history.where((h) => h.status == 'DONE').length;
    final total = _history.length; // today PENDING is excluded because it is not in history yet
    return total == 0 ? 0 : (done / total) * 100;
  }

  String _statusForDate(String date) {
    final row = _history.where((h) => h.date == date).firstOrNull;
    if (row == null) {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (date == today) return 'PENDING';
      return '—';
    }
    return row.status;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HteProvider?>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditHabitScreen(existing: widget.habit),
                ),
              ).then((_) => _loadHistory());
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Completion %
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '${completionPercent.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Completion Rate'),
                        const SizedBox(height: 8),
                        Text(
                          'Daily reminder at ${widget.habit.time}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Mark Done button
                ElevatedButton.icon(
                  onPressed: () async {
                    if (provider != null) {
                      await provider.markHabitDone(widget.habit.id);
                      await _loadHistory();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Marked as Done for today')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Mark Done for Today'),
                ),
                const SizedBox(height: 24),

                const Text(
                  'History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (_history.isEmpty)
                  const Text('No history yet')
                else
                  ..._history.map((h) {
                    final color = h.status == 'DONE' ? Colors.green : Colors.red;
                    return ListTile(
                      leading: Icon(
                        h.status == 'DONE' ? Icons.check_circle : Icons.cancel,
                        color: color,
                      ),
                      title: Text(h.date),
                      subtitle: Text(h.status),
                      trailing: h.completedAt != null
                          ? Text(
                              DateFormat('HH:mm').format(DateTime.parse(h.completedAt!)),
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                    );
                  }),
              ],
            ),
    );
  }
}