import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Register user with Supabase Auth and custom redirect
  Future<String?> register(String name, String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
        emailRedirectTo: 'learningmaterialdownloader://login-callback',
      );
      if (response.user == null) {
        return response.session == null ? 'Registration failed.' : null;
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Login user with Supabase Auth
  Future<String?> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return response.session == null ? 'Login failed.' : null;
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Logout user
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _client.auth.currentUser != null;
  }

  // Get current user info
  Future<Map<String, String?>> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return {};
    return {'name': user.userMetadata?['name'] as String?, 'email': user.email};
  }
}
