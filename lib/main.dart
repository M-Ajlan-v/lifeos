import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/app_database.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';

late AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();

  final authService = AuthService(database);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService)..checkLoginStatus(),
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