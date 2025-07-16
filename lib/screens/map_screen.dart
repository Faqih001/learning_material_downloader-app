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
      body: Column(
        children: [
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    subtitle: Text('Distance: ${libraries[i]['distance']}'),
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
