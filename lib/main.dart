import 'package:flutter/material.dart';
import 'package:lifeos/providers/reminder_provider.dart';
import 'package:lifeos/services/reminder_service.dart';
import 'package:provider/provider.dart';
import 'database/app_database.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';
late AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();

  final authService = AuthService(database);

  WidgetsFlutterBinding.ensureInitialized();

  tzdata.initializeTimeZones();
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    // Handle deprecated timezone names (e.g., Asia/Calcutta -> Asia/Kolkata)
    var tzName = timezoneInfo.identifier;
    if (tzName == 'Asia/Calcutta') {
      tzName = 'Asia/Kolkata';
    }
    tz.setLocalLocation(tz.getLocation(tzName));
  } catch (e) {
    // Fallback to UTC if timezone is invalid
    tz.setLocalLocation(tz.UTC);
  }

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
        Provider<ReminderService>(
          create: (_) => ReminderService(database, notificationsPlugin),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService)..checkLoginStatus(),
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