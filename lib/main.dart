import 'package:flutter/material.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/providers/category_provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/providers/reminder_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/services/reminder_service.dart';
import 'package:lifeos/services/transaction_service.dart';
import 'package:provider/provider.dart';
import 'database/app_database.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
late AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();

  final authService = AuthService(database);
  final categoryService = CategoryService(database);
  final contactService = ContactService(database);
  final accountService = AccountService(database);
  final transactionService = TransactionService(
    database,
    contactService,
    accountService,
    categoryService,
  );


  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database and set Indian Standard Time (IST)
  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // IST for India-specific app

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await notificationsPlugin.initialize(
    settings: const InitializationSettings(android: androidInit),
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<AuthService>.value(value: authService),
        Provider<FlutterLocalNotificationsPlugin>.value(value: notificationsPlugin),
        Provider<CategoryService>.value(value: categoryService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService)..checkLoginStatus(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CategoryProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (!auth.isLoggedIn) return null;
            final userId = auth.userId;
            if (userId == null) return null;
            if (previous != null && previous.userId == userId) return previous;
            return CategoryProvider(
              categoryService: context.read<CategoryService>(),
              userId: userId,
            );
          },
        ),
        Provider<ReminderService>(
          create: (_) => ReminderService(database, notificationsPlugin),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ReminderProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (!auth.isLoggedIn) return null;
            final userId = auth.userId as int;// ⚠️ placeholder — confirm real property name
            if (previous != null && previous.userId == userId) return previous;
            final rp = ReminderProvider(
              db: database,
              reminderService: context.read<ReminderService>(),
              userId: userId, 
            );
            rp.scheduleAll();
            return rp;
          },
        ),
                Provider<ContactService>.value(value: contactService),

        ChangeNotifierProxyProvider<AuthProvider, ContactProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (!auth.isLoggedIn) return null;

            final userId = auth.userId;
            if (userId == null) return null;

            // Reuse previous provider if same user
            if (previous != null && previous.userId == userId) {
              return previous;
            }

            return ContactProvider(
              contactService: context.read<ContactService>(),
              userId: userId,
            );
          },
        ),
                Provider<AccountService>.value(value: accountService),

        ChangeNotifierProxyProvider<AuthProvider, AccountProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (!auth.isLoggedIn) return null;
            final userId = auth.userId;
            if (userId == null) return null;
            if (previous != null && previous.userId == userId) return previous;
            return AccountProvider(
              accountService: context.read<AccountService>(),
              userId: userId,
            );
          },
        ),
                Provider<TransactionService>.value(value: transactionService),

        ChangeNotifierProxyProvider<AuthProvider, TransactionProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (!auth.isLoggedIn) return null;
            final userId = auth.userId;
            if (userId == null) return null;
            if (previous != null && previous.userId == userId) return previous;
            return TransactionProvider(
              transactionService: context.read<TransactionService>(),
              userId: userId,
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (auth.isLoggedIn) {
            return const MainScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}