import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

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
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/mock_map.png'),
                fit: BoxFit.cover,
                onError: null,
              ),
            ),
            child: const Center(
              child: Text(
                'Map Placeholder',
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Nearby Libraries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: libraries.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) => ListTile(
                leading: const Icon(Icons.location_on, color: Color(0xFF2563EB)),
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
