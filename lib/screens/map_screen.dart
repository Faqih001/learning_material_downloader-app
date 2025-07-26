import 'package:flutter/material.dart';
import '../widgets/google_map_widget.dart';
import '../services/auth_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Map<String, String?> _user = {};
  bool _loadingUser = true;

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
        _loadingUser = false;
      });
    } catch (e, st) {
      debugPrint('Error loading user: $e\n$st');
      if (!mounted) return;
      setState(() {
        _user = {};
        _loadingUser = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> libraries = [
      {'name': 'Nairobi National Library', 'distance': '2.1 km'},
      {'name': 'Kenyatta University Library', 'distance': '5.4 km'},
      {'name': 'Mombasa Library', 'distance': '8.2 km'},
      {'name': 'Kisumu Public Library', 'distance': '12.7 km'},
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Libraries'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body:
          _loadingUser
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  final horizontalPadding = isWide ? 48.0 : 16.0;
                  final mapHeight = isWide ? 320.0 : 220.0;
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 900 : double.infinity,
                      ),
                      child: Column(
                        children: [
                          if ((_user['name']?.isNotEmpty ?? false) ||
                              (_user['email']?.isNotEmpty ?? false))
                            Container(
                              width: double.infinity,
                              color: Colors.blue.shade50,
                              padding: EdgeInsets.symmetric(
                                vertical: isWide ? 18 : 12,
                                horizontal: horizontalPadding,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.account_circle,
                                    color: Color(0xFF2563EB),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (_user['name'] != null &&
                                            _user['name']!.isNotEmpty)
                                          Text(
                                            _user['name']!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        if (_user['email'] != null &&
                                            _user['email']!.isNotEmpty)
                                          Text(
                                            _user['email']!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            height: mapHeight,
                            width: double.infinity,
                            margin: EdgeInsets.all(isWide ? 32 : 16),
                            child: const GoogleMapWidget(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: isWide ? 16 : 8,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Nearby Libraries',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isWide ? 22 : 18,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              itemCount: libraries.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder:
                                  (context, i) => ListTile(
                                    leading: const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF2563EB),
                                    ),
                                    title: Text(
                                      libraries[i]['name']!,
                                      style: TextStyle(
                                        fontSize: isWide ? 18 : 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Distance: ${libraries[i]['distance']}',
                                      style: TextStyle(
                                        fontSize: isWide ? 15 : 13,
                                      ),
                                    ),
                                    trailing: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2563EB,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isWide ? 24 : 12,
                                            vertical: isWide ? 14 : 8,
                                          ),
                                          textStyle: TextStyle(
                                            fontSize: isWide ? 16 : 14,
                                          ),
                                        ),
                                        child: const Text('View'),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
