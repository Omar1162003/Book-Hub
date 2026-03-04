// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // دالة تسجيل الدخول الحقيقية (API)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('UserProvider: Starting login...');
      final user = await ApiService.login(email, password);

      if (user != null) {
        print('UserProvider: Login successful');
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print('UserProvider: Login returned null');
        _error = 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('UserProvider: Login exception: $e');
      _error = 'An error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // دالة التسجيل الحقيقية (API)
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('UserProvider: Starting registration...');
      final user = await ApiService.register(name, email, password);

      if (user != null) {
        print('UserProvider: Registration successful');
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print('UserProvider: Registration returned null');
        _error = 'Registration failed. Please use your MTI email (@mti.edu.eg)';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('UserProvider: Registration exception: $e');
      _error = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // دالة تسجيل وهمية للاختبار (بدون API)
  Future<bool> registerMock(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 1));

    // محاكاة نجاح التسجيل - أنشئ user وهمي
    _currentUser = User(
      id: DateTime.now().toString(),
      Name: name,
      Email: email,
      memberSince: DateTime.now(),
    );

    print('✅ Mock registration successful for: $name');
    print('📧 Email: $email');
    print('🔑 Password: $password');

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // دالة تسجيل الخروج
  void logout() {
    _currentUser = null;
    notifyListeners();
    print('👋 User logged out');
  }
}
