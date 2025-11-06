import 'package:flutter/material.dart';
import '../core/themes/app_theme.dart';

class SpotaApp extends StatelessWidget {
  const SpotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPOTA',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
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
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
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