import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/hte_provider.dart';

import 'widget/notification_empty_state.dart';
import 'widget/notification_list_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textPrimary,
              size: 20,
            ),
          ),
        titleSpacing: 16,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
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

    return StreamBuilder<List<NotificationLogData>>(
      stream: provider.firedNotificationsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
                ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final logs =
            snapshot.data ??
            const <NotificationLogData>[];

        if (logs.isEmpty) {
          return const NotificationEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            110,
          ),
          itemCount: logs.length,
          separatorBuilder: (_, __) {
            return const Padding(
              padding: EdgeInsets.only(left: 58),
              child: Divider(
                color: AppTheme.divider,
                height: 1,
                thickness: 1,
              ),
            );
          },
          itemBuilder: (context, index) {
            final log = logs[index];

            return NotificationListItem(
              log: log,
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