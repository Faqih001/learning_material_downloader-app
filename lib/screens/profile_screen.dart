import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String?> _user = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await AuthService().getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('Error loading user: $e\n$st');
      if (!mounted) return;
      setState(() {
        _user = {};
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data.')),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await AuthService().logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (e, st) {
      debugPrint('Error during logout: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 500 : double.infinity),
                    child: Padding(
                      padding: EdgeInsets.all(isWide ? 40 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: isWide ? 44 : 32,
                                backgroundColor: const Color(0xFF2563EB),
                                child: Text(
                                  (_user['name']?.isNotEmpty ?? false)
                                      ? _user['name']![0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: isWide ? 38 : 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: isWide ? 32 : 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _user['name'] ?? 'Unknown',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: isWide ? 28 : null),
                                  ),
                                  SizedBox(height: isWide ? 8 : 4),
                                  Text(
                                    _user['email'] ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: isWide ? 18 : null),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: isWide ? 48 : 32),
                          Text(
                            'Your Stats',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: isWide ? 22 : null),
                          ),
                          SizedBox(height: isWide ? 20 : 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _statCard('Uploads', '5', isWide),
                              _statCard('Downloads', '12', isWide),
                              _statCard('Favorites', '3', isWide),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton.icon(
                                onPressed: _logout,
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: isWide ? 20 : 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: TextStyle(fontSize: isWide ? 18 : 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _statCard(String label, String value, bool isWide) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isWide ? 18 : 12)),
      child: Container(
        width: isWide ? 120 : 90,
        height: isWide ? 90 : 70,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWide ? 28 : 20),
            ),
            SizedBox(height: isWide ? 8 : 4),
            Text(label, style: TextStyle(fontSize: isWide ? 18 : 14)),
          ],
        ),
      ),
    );
  }
}
