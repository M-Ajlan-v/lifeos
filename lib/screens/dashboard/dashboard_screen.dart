import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/screens/dashboard/widgets/dashboard_welcome_header.dart';
import 'package:lifeos/screens/dashboard/widgets/this_month_card.dart';
import 'package:lifeos/screens/dashboard/widgets/top_expenses_card.dart';
import 'package:lifeos/screens/dashboard/widgets/total_balance_card.dart';
import 'package:lifeos/screens/dashboard/widgets/upcoming_event_card.dart';
import 'package:lifeos/screens/dashboard/widgets/upcoming_todo_card.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/providers/auth_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/providers/hte_provider.dart';



class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider?>();
    final txProvider = context.watch<TransactionProvider?>();
    final hteProvider = context.watch<HteProvider?>();

    if (authProvider == null ||
        txProvider == null ||
        hteProvider == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Text(
            'Please login first',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
            ),
          ),
        ),
      );
    }

    final userName =
        authProvider.currentUser?.displayName ??
        authProvider.currentUser?.username ??
        'User';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        color: AppTheme.violetBright,
        backgroundColor: AppTheme.cardElevated,
        onRefresh: () async {
          await hteProvider.refreshAll();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            110,
          ),
          children: [
            DashboardWelcomeHeader(
              userName: userName,
            ),
            const SizedBox(height: 22),
            const TotalBalanceCard(),
            const SizedBox(height: 14),
            const ThisMonthCard(),
            const SizedBox(height: 22),
            const _SectionTitle(
              title: 'Spending Overview',
              icon: Icons.insights_rounded,
            ),
            const SizedBox(height: 10),
            const TopExpensesCard(),
            const SizedBox(height: 22),
            const _SectionTitle(
              title: 'UpComing',
              icon: Icons.schedule_rounded,
            ),
            const SizedBox(height: 10),
StreamBuilder<List<TodosEvent>>(
  stream: hteProvider.todosEventsStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState ==
            ConnectionState.waiting &&
        !snapshot.hasData) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final allItems =
        snapshot.data ?? const <TodosEvent>[];

    final upcomingEvents =
        hteProvider.getUpcomingEvents(allItems);

    final upcomingTodos =
        hteProvider.getUpcomingTodos(allItems);

    return Column(
      children: [
        UpcomingEventCard(
          events: upcomingEvents,
        ),
        const SizedBox(height: 12),
        UpcomingTodoCard(
          todos: upcomingTodos,
        ),
      ],
    );
  },
),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppTheme.violetSoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.violetBright,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}