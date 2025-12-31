import 'package:flutter/foundation.dart';
import 'package:spota_events/shared/models/user_model.dart';
import 'package:spota_events/shared/services/auth_service.dart';
import 'dart:async';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  AuthService get authService => _authService;
  UserModel _currentUser = UserModel.empty();
  bool _isLoading = false;
  String? _error;
  bool _isBypassed = false; // Flag to protect demo sessions

  // Getters
  UserModel get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser.uid.isNotEmpty;
  Stream<List<UserModel>> get allUsersStream =>
      _authService.getAllUsersStream();

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) async {
      // If we are in a demo bypass session, ignore real auth changes
      if (_isBypassed) {
        debugPrint('DEBUG: Auth state change ignored due to bypass');
        return;
      }

      print('DEBUG: Auth state changed, user: ${user?.email}');
      if (user != null) {
        _setLoading(true);
        try {
          final userModel = await _authService.getCurrentUser();
          _currentUser = userModel ?? UserModel.empty();
        } catch (e) {
          print('Error fetching user profile: $e');
          _currentUser = UserModel.empty();
        }
        _setLoading(false);
      } else {
        print('DEBUG: User is null, logging out');
        _currentUser = UserModel.empty();
        _setLoading(false);
      }
    });
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      // --- DEVELOPER BYPASS FOR DEMO ---
      if (kDebugMode &&
          email.toLowerCase().trim() == 'admin@spota.com' &&
          password == 'admin') {
        debugPrint('DEVELOPER BYPASS: Identity verified as System Admin');
        _isBypassed = true; // Lock immediately

        _currentUser = UserModel(
          uid: 'EVteSAv21SbJX7GKaxFsZbM85af1',
          email: 'admin@spota.com',
          name: 'System Admin',
          phone: '+251911000000',
          role: UserRole.admin,
          createdAt: DateTime.fromMillisecondsSinceEpoch(1767134497907),
        );

        _isLoading = false; // Ensure loading stops
        notifyListeners();
        return true;
      }

      _currentUser = await _authService.signIn(email, password);
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

  // ... (rest of the provider methods same as before)
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
      _currentUser = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
        organization: organization,
        bio: bio,
      );
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

  Future<void> logout() async {
    _setLoading(true);
    try {
      _isBypassed = false;
      await _authService.signOut();
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      _currentUser = UserModel.empty();
      notifyListeners();
      _setLoading(false);
    }
  }

  Future<bool> deleteUser(String uid) async {
    _setLoading(true);
    try {
      await _authService.deleteUser(uid);
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

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _error = null;
    try {
      if (email.isEmpty) throw Exception('Please enter your email');
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

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
      await _authService.updateProfile(updatedUser);
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
