import 'package:flutter/material.dart';
import 'package:spota_events/shared/models/user_model.dart';
import 'dart:async';

class AuthProvider with ChangeNotifier {
  // final AuthService _authService = AuthService();
  UserModel _currentUser = UserModel.empty();
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser.uid.isNotEmpty;

  AuthProvider() {
    // Mock initial check - assumes logged out or simple check
    // In real app, we check firebase. For demo, we start fresh or auto-login if needed.
    _currentUser = UserModel.empty();
  }

  // void _fetchUserProfile(String uid) async {
  //   // Disabled for mock mode
  // }

  // Login (Mock)
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    // Mock successful login
    final role =
        email.contains('organizer') ? UserRole.organizer : UserRole.attendee;
    _currentUser = UserModel(
      uid: 'mock_uid_123',
      email: email,
      name: role == UserRole.organizer ? 'Abebe Kebede' : 'Tigist Haile',
      phone: '+251 91 122 3344',
      role: role,
      organization: role == UserRole.organizer ? 'Grand Events PLC' : null,
      bio: role == UserRole.organizer
          ? 'Top rated organizer in Bahir Dar'
          : null,
      createdAt: DateTime.now(),
    );
    notifyListeners();
    _setLoading(false);
    return true;
  }

  // Signup
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    String? organization,
    String? bio,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
        throw Exception('Please fill all required fields');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Mock signup logic
      _currentUser = UserModel(
        uid: 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: phone,
        role: role,
        organization: organization,
        bio: bio,
        createdAt: DateTime.now(),
      );

      /*
      _currentUser = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
        organization: organization,
        bio: bio,
      );
      */

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout (Mock)
  Future<void> logout() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = UserModel.empty();
    notifyListeners();
    _setLoading(false);
  }

  // Password reset
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _error = null;

    try {
      if (email.isEmpty) {
        throw Exception('Please enter your email');
      }

      // await _authService.sendPasswordResetEmail(email);
      await Future.delayed(const Duration(seconds: 1)); // Mock email sending
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? organization,
    String? bio,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final updatedUser = UserModel(
        uid: _currentUser.uid,
        email: _currentUser.email,
        name: name,
        phone: phone,
        role: _currentUser.role,
        organization: organization,
        bio: bio,
        createdAt: _currentUser.createdAt,
      );

      // await _authService.updateProfile(updatedUser);
      await Future.delayed(const Duration(seconds: 1)); // Mock update
      _currentUser = updatedUser;

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}