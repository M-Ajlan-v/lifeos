import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),

          // About LifeOS
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About LifeOS'),
          ),

          const Divider(),

          // Notifications
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('Coming soon'),
          ),

          // Theme
          const ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Theme'),
            subtitle: Text('Coming soon'),
          ),

          // Backup & Restore
          const ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Backup & Restore'),
            subtitle: Text('Coming soon'),
          ),
        ],
      ),
    );
  }
}