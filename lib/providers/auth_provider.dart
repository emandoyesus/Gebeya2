import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  static const String _kCurrentUserKey = 'gebeya_auth_current_user_v1';
  static const String _kUsersRegistryKey = 'gebeya_auth_users_registry_v1';

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_kCurrentUserKey);

      if (userJson != null && userJson.isNotEmpty) {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
      } else {
        // Create default merchant/demo user for smooth first-run experience
        _currentUser = UserModel(
          id: 'usr_demo_01',
          fullName: 'Abebe Kebede',
          email: 'abebe.kebede@gebeya.et',
          phoneNumber: '+251 91 123 4567',
          defaultCity: 'Addis Ababa',
          defaultSubcity: 'Bole',
          defaultStreet: 'Bole Medhanialem, Olympia St.',
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        );
        await _saveCurrentUser(_currentUser!);
      }
    } catch (e) {
      debugPrint('Error loading auth session: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign In with Email or Phone Number and Password
  Future<bool> signIn({
    required String identifier,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600)); // Smooth local auth latency

    try {
      final trimmed = identifier.trim().toLowerCase();
      final prefs = await SharedPreferences.getInstance();
      final usersMap = _getRegisteredUsers(prefs);

      // Check if user exists in registered users
      if (usersMap.containsKey(trimmed)) {
        final userData = usersMap[trimmed] as Map<String, dynamic>;
        final storedPassword = userData['password'] as String?;

        if (storedPassword == password) {
          _currentUser = UserModel.fromJson(userData['user'] as Map<String, dynamic>);
          await _saveCurrentUser(_currentUser!);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Incorrect password. Please try again.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      // Allow demo account
      if ((trimmed == 'abebe.kebede@gebeya.et' || trimmed == '+251911234567') &&
          (password == '123456' || password.isNotEmpty)) {
        _currentUser = UserModel(
          id: 'usr_demo_01',
          fullName: 'Abebe Kebede',
          email: 'abebe.kebede@gebeya.et',
          phoneNumber: '+251 91 123 4567',
          defaultCity: 'Addis Ababa',
          defaultSubcity: 'Bole',
          defaultStreet: 'Bole Medhanialem, Olympia St.',
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        );
        await _saveCurrentUser(_currentUser!);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // If account doesn't exist yet, provide helpful guidance
      _errorMessage = 'Account not found. Please create a new account.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Authentication failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign Up for a new Customer Account
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    String subcity = 'Bole',
    String streetAddress = '',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    try {
      final prefs = await SharedPreferences.getInstance();
      final usersMap = _getRegisteredUsers(prefs);
      final emailKey = email.trim().toLowerCase();
      final phoneKey = phoneNumber.replaceAll(RegExp(r'\s+'), '');

      if (usersMap.containsKey(emailKey) || usersMap.containsKey(phoneKey)) {
        _errorMessage = 'An account with this email or phone already exists.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        email: email.trim().toLowerCase(),
        phoneNumber: phoneNumber.trim(),
        defaultCity: 'Addis Ababa',
        defaultSubcity: subcity,
        defaultStreet: streetAddress.trim().isNotEmpty
            ? streetAddress.trim()
            : '$subcity Main St.',
        isVerified: true,
        createdAt: DateTime.now(),
      );

      // Save to registry by both email and phone
      final entry = {
        'password': password,
        'user': newUser.toJson(),
      };
      usersMap[emailKey] = entry;
      usersMap[phoneKey] = entry;

      await prefs.setString(_kUsersRegistryKey, jsonEncode(usersMap));
      _currentUser = newUser;
      await _saveCurrentUser(newUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Sign up failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update Profile information
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? defaultSubcity,
    String? defaultStreet,
  }) async {
    if (_currentUser == null) return;

    final updated = _currentUser!.copyWith(
      fullName: fullName,
      phoneNumber: phoneNumber,
      defaultSubcity: defaultSubcity,
      defaultStreet: defaultStreet,
    );

    _currentUser = updated;
    await _saveCurrentUser(updated);

    // Update in registry
    final prefs = await SharedPreferences.getInstance();
    final usersMap = _getRegisteredUsers(prefs);
    if (usersMap.containsKey(updated.email)) {
      usersMap[updated.email]['user'] = updated.toJson();
      await prefs.setString(_kUsersRegistryKey, jsonEncode(usersMap));
    }

    notifyListeners();
  }

  /// Sign out
  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCurrentUserKey);
    notifyListeners();
  }

  Future<void> _saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrentUserKey, jsonEncode(user.toJson()));
  }

  Map<String, dynamic> _getRegisteredUsers(SharedPreferences prefs) {
    final raw = prefs.getString(_kUsersRegistryKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(raw));
    } catch (_) {
      return {};
    }
  }
}
