import 'package:flutter/material.dart';
import 'package:lifeos/screens/widgets/modern_bottom_nav.dart';
import 'package:provider/provider.dart';

import 'package:lifeos/providers/auth_provider.dart';
import 'package:lifeos/screens/auth/login_screen.dart';
import 'package:lifeos/screens/dashboard/dashboard_screen.dart';
import 'package:lifeos/screens/contact/contact_screen.dart';
import 'package:lifeos/screens/transactions/transaction_list_screen.dart';
import 'package:lifeos/screens/cashbook/cashbook_screen.dart';
import 'package:lifeos/screens/transfers/transfer_list_screen.dart';
import 'package:lifeos/screens/account/account_screen.dart';
import 'package:lifeos/screens/settings/settings_screen.dart';

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
      title: 'Settings',
      icon: Icons.settings_rounded,
      screen: SettingsScreen(),
    ),
  ];

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final auth = context.read<AuthProvider>();

    await auth.logout();

    if (!mounted) return;

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
        // Drawer-only screen.
        _drawerIndex = index;
      }
    });

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
      ),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 20,
                ),
                color: Theme.of(context).primaryColor,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'LifeOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Personal Finance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  children: [
                    for (int i = 0; i < _drawerItems.length; i++)
                      ListTile(
                        leading: Icon(
                          _drawerItems[i].icon,
                        ),
                        title: Text(
                          _drawerItems[i].title,
                        ),

                        // Highlight the currently selected item.
                        selected: _drawerIndex == i ||
                            (_drawerIndex == -1 &&
                                _drawerItems[i].bottomIndex ==
                                    _bottomIndex),

                        selectedTileColor: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.08),

                        onTap: () {
                          _onDrawerItemTap(i);
                        },
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmLogout();
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      body: _drawerIndex >= 0
          ? _drawerItems[_drawerIndex].screen
          : IndexedStack(
              index: _bottomIndex,
              children: _bottomScreens,
            ),

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