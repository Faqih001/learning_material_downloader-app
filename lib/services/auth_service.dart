
class AuthService {
  // Simulate login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email == 'test@example.com' && password == 'password123';
  }

  // Simulate registration
  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email != 'test@example.com';
  }

  // Simulate logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
