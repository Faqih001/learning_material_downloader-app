import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  // Register user and save to local storage (support multiple users)
  Future<String?> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(usersJson));
    if (users.containsKey(email)) {
      return 'User already registered';
    }
    // Password validation: min 8 chars, at least 1 uppercase, 1 lowercase, 1 digit, 1 special char
    final passwordReg = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}',
    );
    if (!passwordReg.hasMatch(password)) {
      return 'Password must be at least 8 characters, include upper, lower, digit, and special character.';
    }
    users[email] = {'name': name, 'password': password};
    await prefs.setString('users', jsonEncode(users));
    await prefs.setString('current_user', email);
    await prefs.setBool('is_logged_in', true);
    return null;
  }

  // Login user by checking local storage
  Future<String?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(usersJson));
    if (!users.containsKey(email)) {
      return 'User not found';
    }
    if (users[email]['password'] != password) {
      return 'Incorrect password';
    }
    await prefs.setString('current_user', email);
    await prefs.setBool('is_logged_in', true);
    return null;
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('current_user');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Get current user info
  Future<Map<String, String?>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_user');
    if (email == null) return {};
    final usersJson = prefs.getString('users') ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(usersJson));
    final user = users[email];
    return {'name': user?['name'], 'email': email};
  }
}
