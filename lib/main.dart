import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:calendar_application/firebase_options.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          lazy: false, // Initialize immediately
        ),
        ChangeNotifierProxyProvider<AuthService, EventService>(
          create: (_) => EventService(),
          update: (_, auth, eventService) {
            // Optionally update EventService when auth changes
            return eventService ?? EventService();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Calendar App',
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // Use Material 3 design
        ),
        home: Consumer<AuthService>(
          builder: (context, auth, child) {
            if (auth.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return auth.user == null
                ? const LoginScreen()
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  const ErrorBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        ErrorWidget.builder = (FlutterErrorDetails error) {
          return Scaffold(
            body: Center(
              child: Text('An error occurred: ${error.exception}'),
            ),
          );
        };
        return widget ?? const SizedBox.shrink();
      },
      home: child,
    );
  }
}
