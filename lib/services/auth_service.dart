import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Register user and save to local storage
  Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if user already exists
    if (prefs.containsKey('user_email')) {
      return false; // User already registered
    }
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);
    return true;
  }

  // Login user by checking local storage
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('user_email');
    final storedPassword = prefs.getString('user_password');
    if (email == storedEmail && password == storedPassword) {
      await prefs.setBool('is_logged_in', true);
      return true;
    }
    return false;
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Get current user info
  Future<Map<String, String?>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name'),
      'email': prefs.getString('user_email'),
    };
  }
}
