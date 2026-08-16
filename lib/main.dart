import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lifeos/providers/account_provider.dart';
import 'package:lifeos/providers/category_provider.dart';
import 'package:lifeos/providers/contact_provider.dart';
import 'package:lifeos/providers/hte_provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/services/hte_service.dart';
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

    // ========== NOTIFICATION INITIALIZATION ==========
  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

  await notificationsPlugin.initialize(
    settings: const InitializationSettings(android: androidInit),
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final payload = response.payload;
      if (payload == null || payload.isEmpty) return;

      final parts = payload.split('|');
      if (parts.length != 2) return;

      final sourceTypeRaw = parts[0];
      final sourceId = int.tryParse(parts[1]);
      if (sourceId == null) return;

      String sourceType;
      if (sourceTypeRaw == 'TODO_EVENT') {
        final item = await (database.select(database.todosEvents)
              ..where((t) => t.id.equals(sourceId)))
            .getSingleOrNull();
        if (item == null) return;
        sourceType = item.type;
      } else if (sourceTypeRaw == 'HABIT') {
        sourceType = 'HABIT';
      } else {
        return;
      }

      int? userId;
      if (sourceType == 'TODO' || sourceType == 'EVENT') {
        final item = await (database.select(database.todosEvents)
              ..where((t) => t.id.equals(sourceId)))
            .getSingleOrNull();
        userId = item?.userId;
      } else if (sourceType == 'HABIT') {
        final item = await (database.select(database.habits)
              ..where((h) => h.id.equals(sourceId)))
            .getSingleOrNull();
        userId = item?.userId;
      }

      if (userId == null) return;

      String title = 'Notification';
      String body = '';

      if (sourceType == 'TODO' || sourceType == 'EVENT') {
        final item = await (database.select(database.todosEvents)
              ..where((t) => t.id.equals(sourceId)))
            .getSingleOrNull();
        if (item != null) {
          title = item.title;
          body = item.description ?? item.title;
        }
      } else if (sourceType == 'HABIT') {
        final item = await (database.select(database.habits)
              ..where((h) => h.id.equals(sourceId)))
            .getSingleOrNull();
        if (item != null) {
          title = item.title;
          body = item.description ?? 'Habit reminder';
        }
      }

      await database.into(database.notificationLog).insert(
            NotificationLogCompanion.insert(
              userId: userId,
              sourceType: Value(sourceType),
              sourceId: Value(sourceId),
              title: Value(title),
              body: Value(body),
              firedAt: Value(DateTime.now().toUtc()),
              status: const Value('UNSEEN'),
              createdAt: Value(DateTime.now().toUtc()),
            ),
          );
    },
  );

  // Request permissions (CRITICAL)
  final androidPlugin = notificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin != null) {
    await androidPlugin.requestNotificationsPermission();
    await androidPlugin.requestExactAlarmsPermission();

    // Create high-importance channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'hte_channel',
        'Todos Events Habits',
        description: 'Notifications for Todos, Events and Habits',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );
  }
  // ========== END NOTIFICATION INITIALIZATION ==========
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
                // ========== HTE (Habit / Todo / Event) ==========
        Provider<HteService>(
          create: (_) => HteService(database, notificationsPlugin),
        ),
        ChangeNotifierProxyProvider<AuthProvider, HteProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (!auth.isLoggedIn) return null;
            final userId = auth.userId;
            if (userId == null) return null;
            if (previous != null && previous.userId == userId) return previous;

            final provider = HteProvider(
              hteService: context.read<HteService>(),
              userId: userId,
            );
            // Process missed days + refresh notifications on login / app start
            provider.refreshAll();
            return provider;
          },
        ),
        // ========== END HTE ==========
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