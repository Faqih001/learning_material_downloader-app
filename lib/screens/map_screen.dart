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
    final user = await AuthService().getCurrentUser();
    setState(() {
      _user = user;
      _loadingUser = false;
    });
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
              : Column(
                children: [
                  if ((_user['name']?.isNotEmpty ?? false) ||
                      (_user['email']?.isNotEmpty ?? false))
                    Container(
                      width: double.infinity,
                      color: Colors.blue.shade50,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: 220,
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    child: const GoogleMapWidget(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nearby Libraries',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: libraries.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder:
                          (context, i) => ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Color(0xFF2563EB),
                            ),
                            title: Text(libraries[i]['name']!),
                            subtitle: Text(
                              'Distance: ${libraries[i]['distance']}',
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                              ),
                              child: const Text('View'),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
    );
  }
}
