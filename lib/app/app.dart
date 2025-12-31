import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spota_events/app/providers/auth_provider.dart';
import 'package:spota_events/core/themes/app_theme.dart';
import 'package:spota_events/features/auth/screens/login_screen.dart';
import 'package:spota_events/features/events/screens/home_screen.dart';
import 'package:spota_events/features/organizer/screens/organizer_dashboard.dart';
import 'package:spota_events/features/admin/screens/admin_dashboard_screen.dart';
import 'package:spota_events/shared/models/user_model.dart';

class SpotaApp extends StatelessWidget {
  const SpotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'SPOTA',
        theme: AppTheme.lightTheme,
        home: const AppNavigator(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }

    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const LoadingScreen();
    }

    if (authProvider.isLoggedIn) {
      final user = authProvider.currentUser;
      if (user.role == UserRole.organizer) {
        return const OrganizerDashboard();
      } else if (user.role == UserRole.admin) {
        return const AdminDashboardScreen();
      } else {
        return const HomeScreen();
      }
    }

    return const LoginScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.event_available,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'SPOTA',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
            const Text(
              'Find Your Vibe in Bahir Dar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
