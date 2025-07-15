import 'package:flutter/material.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
      _error = null;
    });
  }

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirm() {
    setState(() => _obscureConfirm = !_obscureConfirm);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _error = null);
      // Simulate login/register
      Navigator.pushReplacementNamed(context, '/home');
    }
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isLogin ? 'Login' : 'Register', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      if (!isLogin)
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)),
                          validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                        ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: _togglePassword,
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
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
                                icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                                onPressed: _toggleConfirm,
                              ),
                            ),
                            obscureText: _obscureConfirm,
                            validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                          ),
                        ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(_error!, style: const TextStyle(color: Colors.red)),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(isLogin ? 'Login' : 'Register'),
                        ),
                      ),
                      TextButton(
                        onPressed: _toggleMode,
                        child: Text(isLogin ? "Don't have an account? Register" : 'Already have an account? Login'),
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
