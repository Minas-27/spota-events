import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spota_events/app/providers/auth_provider.dart';
import 'package:spota_events/core/themes/app_theme.dart';
import 'package:spota_events/features/auth/widgets/auth_text_field.dart';
import 'package:spota_events/shared/models/user_model.dart';
import 'package:spota_events/shared/widgets/role_selection_card.dart';
import 'package:spota_events/features/auth/screens/login_screen.dart'; // Ensure this import exists

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  UserRole selectedRole = UserRole.attendee;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Helper method to go to Login
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

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

              // --- FIXED BACK BUTTON ---
              GestureDetector(
                onTap: _navigateToLogin, // Changed from Navigator.pop
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join SPOTA to discover or host events',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // Role Selection Section
              const Text(
                'I want to:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Role Cards
              Row(
                children: [
                  Expanded(
                    child: RoleSelectionCard(
                      title: 'Attend Events',
                      subtitle: 'Discover and book events',
                      icon: Icons.person,
                      role: UserRole.attendee,
                      isSelected: selectedRole == UserRole.attendee,
                      onTap: () {
                        setState(() {
                          selectedRole = UserRole.attendee;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RoleSelectionCard(
                      title: 'Organize Events',
                      subtitle: 'Create and manage events',
                      icon: Icons.business,
                      role: UserRole.organizer,
                      isSelected: selectedRole == UserRole.organizer,
                      onTap: () {
                        setState(() {
                          selectedRole = UserRole.organizer;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Fields...
              AuthTextField(
                hintText: 'Full Name',
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                hintText: 'Email Address',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                hintText: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                controller: _phoneController,
              ),
              const SizedBox(height: 16),

              if (selectedRole == UserRole.organizer) ...[
                AuthTextField(
                  hintText: 'Organization Name',
                  prefixIcon: Icons.business,
                  controller: _organizationController,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tell us about your organization...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              AuthTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 24),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- FIXED LOGIN LINK ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: _navigateToLogin, // Changed from Navigator.pop
                    child: Text(
                      'Login',
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

  void _handleSignup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showError('Please fill all required fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    // Show loading indicator? The screen doesn't have one in state, but AuthProvider has isLoading.
    // But we are not listening to it here (we could).
    // For now, let's just await.

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signup(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: selectedRole,
        organization: selectedRole == UserRole.organizer
            ? _organizationController.text.trim()
            : null,
        bio: selectedRole == UserRole.organizer
            ? _bioController.text.trim()
            : null,
      );

      if (!success) {
        if (!mounted) return;
        _showError(authProvider.error ?? 'Signup failed');
      }
      // No need for manual navigation, AppNavigator handles it reactively
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _organizationController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}