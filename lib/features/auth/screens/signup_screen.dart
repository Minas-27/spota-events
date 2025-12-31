import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spota_events/app/providers/auth_provider.dart';
import 'package:spota_events/core/themes/app_theme.dart';
import 'package:spota_events/features/auth/widgets/auth_text_field.dart';
import 'package:spota_events/shared/models/user_model.dart';
import 'package:spota_events/shared/widgets/role_selection_card.dart';
import 'package:spota_events/features/auth/screens/login_screen.dart';
import 'package:spota_events/core/utils/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  UserRole selectedRole = UserRole.attendee;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _navigateToLogin,
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
                const Text(
                  'I want to:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
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
                AuthTextField(
                  hintText: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  controller: _nameController,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  hintText: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  hintText: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 16),
                if (selectedRole == UserRole.organizer) ...[
                  AuthTextField(
                    hintText: 'Organization Name',
                    prefixIcon: Icons.business,
                    controller: _organizationController,
                    validator: (v) =>
                        v!.isEmpty ? 'Organization name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller: _confirmPasswordController,
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: _navigateToLogin,
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
      ),
    );
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

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

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _showError(authProvider.error ?? 'Signup failed');
      }
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
