import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spota_events/app/providers/auth_provider.dart';
import 'package:spota_events/shared/models/user_model.dart';
import 'package:spota_events/core/themes/app_theme.dart';
import 'package:spota_events/features/auth/screens/forgot_password_screen.dart';
import 'package:spota_events/features/auth/screens/signup_screen.dart';
import 'package:spota_events/features/auth/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Demo organizer credentials
  final Map<String, dynamic> _demoOrganizerCredentials = {
    'email': 'organizer@spota.com',
    'password': 'organizer123',
    'name': 'Event Organizer',
    'phone': '+251911223344',
    'organization': 'SPOTA Events',
  };

  // Demo attendee credentials
  final Map<String, dynamic> _demoAttendeeCredentials = {
    'email': 'user@spota.com',
    'password': 'user123',
    'name': 'Event Attendee',
    'phone': '+251944556677',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Title
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // Demo Credentials Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Demo Credentials:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDemoCredential(
                        'Organizer', 'organizer@spota.com', 'organizer123'),
                    const SizedBox(height: 4),
                    _buildDemoCredential(
                        'Attendee', 'user@spota.com', 'user123'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Email Field
              AuthTextField(
                hintText: 'Email Address',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
              ),

              const SizedBox(height: 16),

              // Password Field
              AuthTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 8),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Quick Login Buttons
              const Text(
                'Quick Login:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _quickLogin(_demoOrganizerCredentials),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Organizer Demo',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _quickLogin(_demoAttendeeCredentials),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Attendee Demo',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sign Up Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to signup
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCredential(String role, String email, String password) {
    return Row(
      children: [
        Text(
          '$role: ',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          '$email / $password',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _quickLogin(Map<String, dynamic> credentials) {
    _emailController.text = credentials['email'];
    _passwordController.text = credentials['password'];
    _handleLogin(isDemo: true, demoData: credentials);
  }

  void _handleLogin(
      {bool isDemo = false, Map<String, dynamic>? demoData}) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Auto-detect demo accounts even if typed manually
      if (!isDemo) {
        if (email == _demoOrganizerCredentials['email']) {
          isDemo = true;
          demoData = _demoOrganizerCredentials;
        } else if (email == _demoAttendeeCredentials['email']) {
          isDemo = true;
          demoData = _demoAttendeeCredentials;
        }
      }

      bool success = await authProvider.login(email, password);

      // If it's a demo account and login failed (likely because user doesn't exist), try to sign up
      if (!success && isDemo && demoData != null) {
        final error = authProvider.error?.toLowerCase() ?? '';
        if (error.contains('user-not-found') ||
            error.contains('invalid-credential')) {
          success = await authProvider.signup(
            email: email,
            password: password,
            name: demoData['name'] ?? 'Demo User',
            phone: demoData['phone'] ?? '',
            role: demoData['organization'] != null
                ? UserRole.organizer
                : UserRole.attendee,
            organization: demoData['organization'],
          );
        }
      }

      if (!success) {
        if (!mounted) return;
        _showError(authProvider.error ?? 'Login failed');
      }
      // No need for manual navigation, AppNavigator handles it reactively
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}