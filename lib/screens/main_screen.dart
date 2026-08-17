import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/widgets/modern_bottom_nav.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/screens/todo/todo_screen.dart';
import 'package:lifeos/screens/event/event_screen.dart';
import 'package:lifeos/screens/habit/habit_screen.dart';

import 'package:lifeos/providers/auth_provider.dart';

import 'package:lifeos/screens/auth/login_screen.dart';
import 'package:lifeos/screens/dashboard/dashboard_screen.dart';
import 'package:lifeos/screens/contact/contact_screen.dart';
import 'package:lifeos/screens/transactions/transaction_list_screen.dart';
import 'package:lifeos/screens/cashbook/cashbook_screen.dart';
import 'package:lifeos/screens/transfers/transfer_list_screen.dart';
import 'package:lifeos/screens/account/account_screen.dart';
import 'package:lifeos/screens/settings/settings_screen.dart';
import 'package:lifeos/screens/notifications/notifications_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomIndex = 0;

  // -1 = using bottom navigation
  // >= 0 = a drawer-only screen is open
  int _drawerIndex = -1;

  final List<Widget> _bottomScreens = const [
    DashboardScreen(),
    ContactScreen(),
    CashbookScreen(),
    AccountScreen(),
  ];

  final List<_DrawerItem> _drawerItems = const [
    _DrawerItem(
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      screen: DashboardScreen(),
      bottomIndex: 0,
    ),
    _DrawerItem(
      title: 'Contacts',
      icon: Icons.people_rounded,
      screen: ContactScreen(),
      bottomIndex: 1,
    ),
    _DrawerItem(
      title: 'Cashbook',
      icon: Icons.menu_book_rounded,
      screen: CashbookScreen(),
      bottomIndex: 2,
    ),
    _DrawerItem(
      title: 'Accounts',
      icon: Icons.account_balance_wallet_rounded,
      screen: AccountScreen(),
      bottomIndex: 3,
    ),
    _DrawerItem(
      title: 'All Transactions',
      icon: Icons.list_rounded,
      screen: TransactionListScreen(),
    ),
    _DrawerItem(
      title: 'Transfers',
      icon: Icons.swap_horiz_rounded,
      screen: TransferListScreen(),
    ),
    _DrawerItem(
      title: 'Todos',
      icon: Icons.check_box_rounded,
      screen: TodoScreen(),
    ),
    _DrawerItem(
      title: 'Events',
      icon: Icons.event_rounded,
      screen: EventScreen(),
    ),
    _DrawerItem(
      title: 'Habits',
      icon: Icons.repeat_rounded,
      screen: HabitScreen(),
    ),
    _DrawerItem(
      title: 'Settings',
      icon: Icons.settings_rounded,
      screen: SettingsScreen(),
    ),
  ];

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppTheme.radiusHero,
          ),
          side: const BorderSide(
            color: AppTheme.glassBorderStrong,
          ),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: AppTheme.textSecondary,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          14,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                ctx,
                false,
              );
            },
            child: const Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                ctx,
                true,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.expense,
            ),
            child: const Text(
              'Logout',
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final auth = context.read<AuthProvider>();

    await auth.logout();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  String get _currentTitle {
    if (_drawerIndex >= 0) {
      return _drawerItems[_drawerIndex].title;
    }

    switch (_bottomIndex) {
      case 0:
        return 'Dashboard';

      case 1:
        return 'Contacts';

      case 2:
        return 'Cashbook';

      case 3:
        return 'Accounts';

      default:
        return 'LifeOS';
    }
  }

  void _onDrawerItemTap(int index) {
    final item = _drawerItems[index];

    setState(() {
      if (item.bottomIndex != null) {
        _bottomIndex = item.bottomIndex!;
        _drawerIndex = -1;
      } else {
        _drawerIndex = index;
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        titleSpacing: 8,

        // =======================================================
        // HAMBURGER ICON
        // =======================================================
        leadingWidth: 60,
        leading: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 6,
                bottom: 6,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardElevated,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: AppTheme.glassBorder,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_rounded,
                      color: AppTheme.textPrimary,
                      size: 23,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // =======================================================
        // PAGE TITLE
        // =======================================================
        title: Text(
          _currentTitle,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        // =======================================================
        // NOTIFICATION BUTTON
        // =======================================================
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 12,
              top: 6,
              bottom: 6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.cardElevated,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppTheme.glassBorder,
              ),
            ),
            child: IconButton(
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const NotificationsScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppTheme.textPrimary,
                size: 21,
              ),
            ),
          ),
        ],
      ),

      // =========================================================
      // DRAWER
      // =========================================================
      drawer: Drawer(
        backgroundColor: AppTheme.backgroundSecondary,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===================================================
              // DRAWER HEADER
              // ===================================================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  12,
                  12,
                  12,
                  8,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient:
                      AppTheme.violetOrangeGradient,
                  borderRadius:
                      BorderRadius.circular(
                    AppTheme.radiusHero,
                  ),
                  boxShadow:
                      AppTheme.violetGlow,
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          Colors.white,
                      child: Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: AppTheme.violet,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'LifeOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Outfit',
                        fontSize: 21,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Personal Finance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // ===================================================
              // DRAWER ITEMS
              // ===================================================
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    8,
                    12,
                    8,
                  ),
                  children: [
                    for (
                      int i = 0;
                      i < _drawerItems.length;
                      i++
                    )
                      Builder(
                        builder: (context) {
                          final item =
                              _drawerItems[i];

                          final isSelected =
                              _drawerIndex == i ||
                                  (_drawerIndex ==
                                          -1 &&
                                      item.bottomIndex ==
                                          _bottomIndex);

                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 4,
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                              selected:
                                  isSelected,

                              selectedTileColor:
                                  AppTheme.violet
                                      .withOpacity(
                                0.14,
                              ),

                              leading: Icon(
                                item.icon,
                                color: isSelected
                                    ? AppTheme
                                        .violetBright
                                    : AppTheme
                                        .textSecondary,
                              ),

                              title: Text(
                                item.title,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppTheme
                                          .textPrimary
                                      : AppTheme
                                          .textSecondary,
                                  fontFamily:
                                      'Outfit',
                                  fontSize: 14,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight
                                              .w600
                                          : FontWeight
                                              .w500,
                                ),
                              ),

                              onTap: () {
                                _onDrawerItemTap(
                                  i,
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              // ===================================================
              // DIVIDER
              // ===================================================
              const Padding(
                padding:
                    EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Divider(
                  height: 1,
                  color: AppTheme.divider,
                ),
              ),

              // ===================================================
              // LOGOUT
              // ===================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  8,
                  12,
                  8,
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.expense,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: AppTheme.expense,
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmLogout();
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: _drawerIndex >= 0
          ? _drawerItems[_drawerIndex].screen
          : IndexedStack(
              index: _bottomIndex,
              children: _bottomScreens,
            ),

      // =========================================================
      // BOTTOM NAVIGATION
      // =========================================================
      bottomNavigationBar: _drawerIndex >= 0
          ? null
          : ModernBottomNav(
              currentIndex: _bottomIndex,
              onTap: (index) {
                setState(() {
                  _bottomIndex = index;
                  _drawerIndex = -1;
                });
              },
            ),
    );
  }
}

class _DrawerItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final int? bottomIndex;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.screen,
    this.bottomIndex,
  });
}