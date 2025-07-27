import 'package:flutter/material.dart';
import '../widgets/google_map_widget.dart';
import '../services/auth_service.dart';
import '../utils/map_utils.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Map<String, String?> _user = {};
  bool _loadingUser = true;
  final List<Map<String, dynamic>> _allLibraries = [
    {
      'name': 'Nairobi National Library',
      'distance': '2.1 km',
      'lat': -1.286389,
      'lng': 36.817223,
    },
    {
      'name': 'Kenyatta University Library',
      'distance': '5.4 km',
      'lat': -1.180019,
      'lng': 36.927532,
    },
    {
      'name': 'Mombasa Library',
      'distance': '8.2 km',
      'lat': -4.043477,
      'lng': 39.668206,
    },
    {
      'name': 'Kisumu Public Library',
      'distance': '12.7 km',
      'lat': -0.102206,
      'lng': 34.761711,
    },
  ];
  String _searchQuery = '';
  List<Map<String, dynamic>> get _filteredLibraries {
    if (_searchQuery.isEmpty) return _allLibraries;
    return _allLibraries
        .where(
          (lib) => lib['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

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
                          child: _buildMapWidget(context),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: isWide ? 16 : 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Search libraries...',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    setState(() => _searchQuery = val);
                                  },
                                ),
                              ),
                            ],
                          ),
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
                            itemCount: _filteredLibraries.length,
                            separatorBuilder: (_, index) => const Divider(),
                            itemBuilder: (context, i) {
                              final lib = _filteredLibraries[i];
                              return ListTile(
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF2563EB),
                                ),
                                title: Text(
                                  lib['name'],
                                  style: TextStyle(
                                    fontSize: isWide ? 18 : 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Distance: ${lib['distance']}',
                                  style: TextStyle(
                                    fontSize: isWide ? 15 : 13,
                                  ),
                                ),
                                trailing: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: ElevatedButton(
                                    onPressed:
                                        () => _showStaticMapDialog(lib),
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
                              );
                            },
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

Widget _buildMapWidget(BuildContext context) {
    // Show GoogleMapWidget on mobile/desktop, static map and button on web
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux) {
      return const GoogleMapWidget();
    } else {
      // Web fallback: static map image and button
      const double lat = -1.286389;
      const double lng = 36.817223;
      return Column(
        children: [
          Image.network(
            'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=12&size=600x220&markers=color:blue%7C$lat,$lng&key=YOUR_GOOGLE_MAPS_API_KEY',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Text('Map preview unavailable.'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.map),
            label: const Text('Open in Google Maps'),
            onPressed: () => MapUtils.openGoogleMaps(lat: lat, lng: lng, label: 'Nairobi National Library'),
          ),
        ],
      );
    }
  }
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: isWide ? 16 : 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Search libraries...',
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (val) {
                                      setState(() => _searchQuery = val);
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                              itemCount: _filteredLibraries.length,
                              separatorBuilder: (_, index) => const Divider(),
                              itemBuilder: (context, i) {
                                final lib = _filteredLibraries[i];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF2563EB),
                                  ),
                                  title: Text(
                                    lib['name'],
                                    style: TextStyle(
                                      fontSize: isWide ? 18 : 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Distance: ${lib['distance']}',
                                    style: TextStyle(
                                      fontSize: isWide ? 15 : 13,
                                    ),
                                  ),
                                  trailing: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: ElevatedButton(
                                      onPressed:
                                          () => _showStaticMapDialog(lib),
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
                                );
                              },
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

  void _showStaticMapDialog(Map<String, dynamic> lib) {
    final lat = lib['lat'] as double;
    final lng = lib['lng'] as double;
    final name = lib['name'] as String;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(name),
            content: GestureDetector(
              onTap: () => _openGoogleMaps(lat, lng, name),
              child: Image.network(
                'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=400x200&markers=color:blue%7C$lat,$lng&key=YOUR_GOOGLE_MAPS_API_KEY',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Text('Map preview unavailable.'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () => _openDirections(lat, lng),
                child: const Text('Get Directions'),
              ),
            ],
          ),
    );
  }

  void _openGoogleMaps(double lat, double lng, String label) async {
    try {
      Navigator.pop(context);
      await MapUtils.openGoogleMaps(lat: lat, lng: lng, label: label);
    } catch (e) {
      debugPrint('Could not open Google Maps: $e');
    }
  }

  void _openDirections(double lat, double lng) async {
    try {
      Navigator.pop(context);
      await MapUtils.openDirections(lat: lat, lng: lng);
    } catch (e) {
      debugPrint('Could not open directions: $e');
    }
  }
}
