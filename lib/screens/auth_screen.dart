import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;
  bool _loading = false;
  final AuthService _authService = AuthService();

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
      _error = null;
    });
  }

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  bool _rememberMe = false;
  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool('remember_me') ?? false;
    final rememberedPwd = prefs.getBool('remember_password') ?? false;
    final email = prefs.getString('remembered_email') ?? '';
    final password = prefs.getString('remembered_password') ?? '';
    setState(() {
      _rememberMe = remembered;
      _rememberPassword = rememberedPwd;
      if (remembered && email.isNotEmpty) {
        _emailController.text = email;
      }
      if (rememberedPwd && password.isNotEmpty) {
        _passwordController.text = password;
      }
    });
  }

  void _toggleConfirm() {
    setState(() => _obscureConfirm = !_obscureConfirm);
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _error = null;
        _loading = true;
      });
      String? result;
      if (isLogin) {
        result = await _authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe && result == null) {
          await prefs.setBool('remember_me', true);
          await prefs.setString(
            'remembered_email',
            _emailController.text.trim(),
          );
        } else {
          await prefs.setBool('remember_me', false);
          await prefs.remove('remembered_email');
        }
        if (_rememberPassword && result == null) {
          await prefs.setBool('remember_password', true);
          await prefs.setString(
            'remembered_password',
            _passwordController.text,
          );
        } else {
          await prefs.setBool('remember_password', false);
          await prefs.remove('remembered_password');
        }
        setState(() => _loading = false);
        if (result == null) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() => _error = result);
        }
      } else {
        result = await _authService.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
        setState(() => _loading = false);
        if (result == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login.'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;
          setState(() {
            isLogin = true;
            _error = null;
            _passwordController.clear();
            _confirmPasswordController.clear();
          });
        } else {
          setState(() => _error = result);
        }
      }
    }
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Enter your email';
    // Accepts emails ending with @gmail.com, @ac.ke, @co.ke, and other valid domains
    final emailReg = RegExp(
      r'^[\w\-.]+@([\w\-]+\.)+(com|ac\.ke|co\.ke|net|org|edu|gov|info|io|[a-z]{2,})$',
      caseSensitive: false,
    );
    if (!emailReg.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter your password';
    final passwordReg = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}',
    );
    if (!passwordReg.hasMatch(v)) {
      return 'Min 8 chars, upper, lower, digit, special char.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? 'Login' : 'Register',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF2563EB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!isLogin)
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Enter your name'
                                      : null,
                        ),
                      if (!isLogin) const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _togglePassword,
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator:
                            isLogin
                                ? (v) =>
                                    v == null || v.isEmpty
                                        ? 'Enter your password'
                                        : null
                                : _validatePassword,
                      ),
                      if (!isLogin)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _toggleConfirm,
                              ),
                            ),
                            obscureText: _obscureConfirm,
                            validator:
                                (v) =>
                                    v != _passwordController.text
                                        ? 'Passwords do not match'
                                        : null,
                          ),
                        ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: CircularProgressIndicator(),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(isLogin ? 'Login' : 'Register'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isLogin)
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) {
                                    setState(() {
                                      _rememberMe = val ?? false;
                                    });
                                  },
                                ),
                                const Text('Remember Me'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberPassword,
                                  onChanged: (val) {
                                    setState(() {
                                      _rememberPassword = val ?? false;
                                    });
                                  },
                                ),
                                const Text('Remember Password'),
                              ],
                            ),
                          ],
                        ),
                      TextButton(
                        onPressed: _loading ? null : _toggleMode,
                        child: Text(
                          isLogin
                              ? "Don't have an account? Register"
                              : 'Already have an account? Login',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
