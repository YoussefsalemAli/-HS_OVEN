import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  // Change these credentials as needed
  static const String _adminUsername = 'admin';
  static const String _adminPassword = 'hoven2024';

  bool get isLoggedIn => _isLoggedIn;

  AdminProvider() {
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('admin_session') ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> login(String username, String password) async {
    if (username == _adminUsername && password == _adminPassword) {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('admin_session', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('admin_session', false);
    notifyListeners();
  }
}
