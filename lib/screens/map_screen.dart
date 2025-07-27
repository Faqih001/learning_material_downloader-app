import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import '../services/auth_service.dart';
import '../utils/map_utils.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const double _nairobiLat = -1.286389;
  static const double _nairobiLng = 36.817223;

  double _distanceFromNairobi(double lat, double lng) {
    const double earthRadius = 6371; // km
    final dLat = _deg2rad(lat - _nairobiLat);
    final dLng = _deg2rad(lng - _nairobiLng);
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_deg2rad(_nairobiLat)) * cos(_deg2rad(lat)) * (sin(dLng / 2) * sin(dLng / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180.0);

  Map<String, String?> _user = {};
  bool _loadingUser = true;
  ui.Image? _staticMapImage;
  final List<Map<String, dynamic>> _allLibraries = [
    // Nairobi County
    {'name': 'Nairobi National Library', 'lat': -1.286389, 'lng': 36.817223, 'county': 'Nairobi', 'type': 'National'},
    {'name': 'McMillan Memorial Library', 'lat': -1.2833, 'lng': 36.8167, 'county': 'Nairobi', 'type': 'Public'},
    {'name': 'Kayole Library', 'lat': -1.3083, 'lng': 36.9483, 'county': 'Nairobi', 'type': 'Public'},
    {'name': 'Makadara Library', 'lat': -1.3078, 'lng': 36.8736, 'county': 'Nairobi', 'type': 'Public'},
    {'name': 'Dagoretti Library', 'lat': -1.2986, 'lng': 36.7475, 'county': 'Nairobi', 'type': 'Public'},
    {'name': 'Buruburu Library', 'lat': -1.2944, 'lng': 36.8875, 'county': 'Nairobi', 'type': 'Public'},
    // Mombasa County
    {'name': 'Seif Bin Salim Public Library', 'lat': -4.0435, 'lng': 39.6682, 'county': 'Mombasa', 'type': 'Public'},
    // Nakuru County
    {'name': 'Nakuru Library', 'lat': -0.303099, 'lng': 36.080025, 'county': 'Nakuru', 'type': 'Public'},
    // Kisumu County
    {'name': 'Kisumu Public Library', 'lat': -0.102206, 'lng': 34.761711, 'county': 'Kisumu', 'type': 'Public'},
    // Baringo County
    {'name': 'Marigat Library', 'lat': 0.4900, 'lng': 35.9875, 'county': 'Baringo', 'type': 'Public'},
    {'name': 'Eldama Ravine Library', 'lat': 0.0500, 'lng': 35.7250, 'county': 'Baringo', 'type': 'Public'},
    {'name': 'Kabartonjo Library', 'lat': 0.4833, 'lng': 35.7667, 'county': 'Baringo', 'type': 'Public'},
    // Bomet County
    {'name': 'Silibwet Library', 'lat': -0.7500, 'lng': 35.3833, 'county': 'Bomet', 'type': 'Public'},
    // Bungoma County
    {'name': 'Kimilili Library', 'lat': 0.7833, 'lng': 34.7500, 'county': 'Bungoma', 'type': 'Public'},
    {'name': 'Lagam Library', 'lat': 0.7000, 'lng': 34.7000, 'county': 'Bungoma', 'type': 'Public'},
    // Embu County
    {'name': 'Embu Library', 'lat': -0.5333, 'lng': 37.4500, 'county': 'Embu', 'type': 'Public'},
    // Garissa County
    {'name': 'Garissa Library', 'lat': -0.4533, 'lng': 39.6500, 'county': 'Garissa', 'type': 'Public'},
    // Isiolo County
    {'name': 'Isiolo Library', 'lat': 0.3500, 'lng': 37.5833, 'county': 'Isiolo', 'type': 'Public'},
    // Kajiado County
    {'name': 'Kajiado Library', 'lat': -2.0000, 'lng': 36.7833, 'county': 'Kajiado', 'type': 'Public'},
    // Kakamega County
    {'name': 'Kakamega Library', 'lat': 0.2833, 'lng': 34.7500, 'county': 'Kakamega', 'type': 'Public'},
    // Kericho County
    {'name': 'Kericho Library', 'lat': -0.3667, 'lng': 35.2833, 'county': 'Kericho', 'type': 'Public'},
    // Kiambu County
    {'name': 'Kiambu Library', 'lat': -1.1667, 'lng': 36.8167, 'county': 'Kiambu', 'type': 'Public'},
    // Kilifi County
    {'name': 'Kilifi Library', 'lat': -3.6333, 'lng': 39.8500, 'county': 'Kilifi', 'type': 'Public'},
    // Kirinyaga County
    {'name': 'Kerugoya Library', 'lat': -0.5000, 'lng': 37.3667, 'county': 'Kirinyaga', 'type': 'Public'},
    // Kitui County
    {'name': 'Kitui Library', 'lat': -1.3667, 'lng': 38.0167, 'county': 'Kitui', 'type': 'Public'},
    // Kwale County
    {'name': 'Kwale Library', 'lat': -4.1667, 'lng': 39.4500, 'county': 'Kwale', 'type': 'Public'},
    // Laikipia County
    {'name': 'Nanyuki Library', 'lat': 0.0167, 'lng': 37.0833, 'county': 'Laikipia', 'type': 'Public'},
    // Lamu County
    {'name': 'Lamu Library', 'lat': -2.2667, 'lng': 40.9000, 'county': 'Lamu', 'type': 'Public'},
    // Machakos County
    {'name': 'Machakos Library', 'lat': -1.5167, 'lng': 37.2667, 'county': 'Machakos', 'type': 'Public'},
    // Makueni County
    {'name': 'Wote Library', 'lat': -2.1000, 'lng': 37.6167, 'county': 'Makueni', 'type': 'Public'},
    // Mandera County
    {'name': 'Mandera Library', 'lat': 3.9333, 'lng': 41.8500, 'county': 'Mandera', 'type': 'Public'},
    // Marsabit County
    {'name': 'Marsabit Library', 'lat': 2.3333, 'lng': 37.9833, 'county': 'Marsabit', 'type': 'Public'},
    // Meru County
    {'name': 'Meru Library', 'lat': 0.0500, 'lng': 37.6500, 'county': 'Meru', 'type': 'Public'},
    {'name': 'Nkubu Library', 'lat': 0.2167, 'lng': 37.6167, 'county': 'Meru', 'type': 'Public'},
    // Migori County
    {'name': 'Migori Library', 'lat': -1.0667, 'lng': 34.4667, 'county': 'Migori', 'type': 'Public'},
    // Murang'a County
    {'name': 'Murang’a Library', 'lat': -0.7167, 'lng': 37.1500, 'county': 'Murang’a', 'type': 'Public'},
    // Nyamira County
    {'name': 'Nyamira Library', 'lat': -0.5667, 'lng': 34.9333, 'county': 'Nyamira', 'type': 'Public'},
    // Nyeri County
    {'name': 'Nyeri Library', 'lat': -0.4167, 'lng': 36.9500, 'county': 'Nyeri', 'type': 'Public'},
    // Samburu County
    {'name': 'Maralal Library', 'lat': 1.1000, 'lng': 36.7000, 'county': 'Samburu', 'type': 'Public'},
    // Siaya County
    {'name': 'Siaya Library', 'lat': 0.0667, 'lng': 34.2833, 'county': 'Siaya', 'type': 'Public'},
    // Taita-Taveta County
    {'name': 'Voi Library', 'lat': -3.4000, 'lng': 38.5500, 'county': 'Taita-Taveta', 'type': 'Public'},
    // Tana River County
    {'name': 'Hola Library', 'lat': -1.7167, 'lng': 40.0167, 'county': 'Tana River', 'type': 'Public'},
    // Tharaka-Nithi County
    {'name': 'Chuka Library', 'lat': -0.3167, 'lng': 37.9833, 'county': 'Tharaka-Nithi', 'type': 'Public'},
    // Trans Nzoia County
    {'name': 'Kitale Library', 'lat': 1.0167, 'lng': 35.0000, 'county': 'Trans Nzoia', 'type': 'Public'},
    // Turkana County
    {'name': 'Lodwar Library', 'lat': 3.1167, 'lng': 35.6000, 'county': 'Turkana', 'type': 'Public'},
    // Uasin Gishu County
    {'name': 'Eldoret Library', 'lat': 0.5167, 'lng': 35.2667, 'county': 'Uasin Gishu', 'type': 'Public'},
    // Vihiga County
    {'name': 'Vihiga Library', 'lat': 0.0500, 'lng': 34.7000, 'county': 'Vihiga', 'type': 'Public'},
    // Wajir County
    {'name': 'Wajir Library', 'lat': 1.7500, 'lng': 40.0500, 'county': 'Wajir', 'type': 'Public'},
    // West Pokot County
    {'name': 'Kapenguria Library', 'lat': 1.2333, 'lng': 35.0833, 'county': 'West Pokot', 'type': 'Public'},
    // Additional Community/Academic Libraries
    {'name': 'Mathare Youth Sports Association Library', 'lat': -1.2667, 'lng': 36.8667, 'county': 'Nairobi', 'type': 'Community'},
    {'name': 'Micato-Amshare Library', 'lat': -1.3167, 'lng': 36.8500, 'county': 'Nairobi', 'type': 'Community'},
    {'name': 'Hosanna B&K Library', 'lat': -0.7000, 'lng': 36.9500, 'county': 'Murang’a', 'type': 'Community'},
    {'name': 'University of Nairobi Library', 'lat': -1.2819, 'lng': 36.8192, 'county': 'Nairobi', 'type': 'Academic'},
    {'name': 'Kenyatta University Library', 'lat': -1.180019, 'lng': 36.927532, 'county': 'Nairobi', 'type': 'Academic'},
    // Add all other libraries as needed...
  ];

  String _searchQuery = '';
  String? _selectedCounty;
  String? _selectedType;

  List<String> get _allCounties {
    final List<String> counties = _allLibraries
        .map((lib) => lib['county'] as String)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    counties.sort();
    return counties;
  }

  List<String> get _allTypes {
    final List<String> types = _allLibraries
        .map((lib) => lib['type'] as String)
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();
    types.sort();
    return types;
  }

  List<Map<String, dynamic>> get _filteredLibraries {
    return _allLibraries.where((lib) {
      final matchesQuery = _searchQuery.isEmpty ||
          lib['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCounty = _selectedCounty == null ||
          (lib['county'] != null && lib['county'] == _selectedCounty);
      final matchesType = _selectedType == null ||
          (lib['type'] != null && lib['type'] == _selectedType);
      return matchesQuery && matchesCounty && matchesType;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadStaticMap();
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

  Future<void> _loadStaticMap() async {
    try {
      // Use OpenStreetMap static map API centered on Kenya
      final response = await http.get(Uri.parse(
          'https://staticmap.openstreetmap.de/staticmap.php?center=-0.0236,37.9062&zoom=6&size=600x400'));
      if (response.statusCode == 200) {
        final codec = await ui.instantiateImageCodec(response.bodyBytes);
        final frame = await codec.getNextFrame();
        if (!mounted) return;
        setState(() {
          _staticMapImage = frame.image;
        });
      } else {
        throw Exception('Failed to load static map');
      }
    } catch (e) {
      debugPrint('Error loading static map: $e');
    }
  }

  void _openGoogleMaps({required double lat, required double lng, required String label}) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';
    debugPrint('Opening Google Maps: $url');
  }

  void _openDirections({required double lat, required double lng}) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    debugPrint('Opening directions: $url');
  }

  Widget _buildMapWidget(BuildContext context) {
    if (_staticMapImage == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return CustomPaint(
      painter: _StaticMapPainter(libraries: _filteredLibraries, mapImage: _staticMapImage!),
      child: Container(),
    );
  }

  void _showStaticMapDialog(Map<String, dynamic> lib) {
    final lat = lib['lat'] as double;
    final lng = lib['lng'] as double;
    final name = lib['name'] as String;
    final osmUrl = 'https://staticmap.openstreetmap.de/staticmap.php?center=$lat,$lng&zoom=15&size=400x200&markers=$lat,$lng,blue-pushpin';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: GestureDetector(
          onTap: () => _openGoogleMaps(lat: lat, lng: lng, label: name),
          child: Image.network(
            osmUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Text('Map preview unavailable.'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => _openDirections(lat: lat, lng: lng),
            child: const Text('Get Directions'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Libraries'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body: _loadingUser
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                final double horizontalPadding = isWide ? 48.0 : 16.0;
                final double mapHeight = isWide ? 320.0 : 220.0;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        if ((_user['name']?.isNotEmpty ?? false) || (_user['email']?.isNotEmpty ?? false))
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (_user['name'] != null && _user['name']!.isNotEmpty)
                                        Text(
                                          _user['name']!,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      if (_user['email'] != null && _user['email']!.isNotEmpty)
                                        Text(
                                          _user['email']!,
                                          style: const TextStyle(fontSize: 13, color: Colors.black54),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Search libraries...',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (val) {
                                  setState(() => _searchQuery = val);
                                },
                              ),
                              const SizedBox(height: 12),
                              DropdownButton<String>(
                                value: _selectedCounty,
                                hint: const Text('County'),
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('All Counties'),
                                  ),
                                  ..._allCounties.map(
                                    (county) => DropdownMenuItem(
                                      value: county,
                                      child: Text(county),
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  setState(() => _selectedCounty = val);
                                },
                              ),
                              const SizedBox(height: 12),
                              DropdownButton<String>(
                                value: _selectedType,
                                hint: const Text('Type'),
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('All Types'),
                                  ),
                                  ..._allTypes.map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  setState(() => _selectedType = val);
                                },
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
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            itemCount: _filteredLibraries.length,
                            separatorBuilder: (_, index) => const Divider(),
                            itemBuilder: (context, i) {
                              final lib = _filteredLibraries[i];
                              final lat = lib['lat'] as double;
                              final lng = lib['lng'] as double;
                              final distance = _distanceFromNairobi(lat, lng);
                              return ListTile(
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF2563EB),
                                ),
                                title: Text(
                                  lib['name'],
                                  style: TextStyle(fontSize: isWide ? 18 : 16),
                                ),
                                subtitle: Text(
                                  '${lib['county'] ?? ''}${lib['county'] != null && lib['type'] != null ? ' • ' : ''}${lib['type'] ?? ''} • ${distance.toStringAsFixed(1)} km from Nairobi',
                                  style: TextStyle(fontSize: isWide ? 15 : 13),
                                ),
                                trailing: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: ElevatedButton(
                                    onPressed: () => _showStaticMapDialog(lib),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isWide ? 24 : 12,
                                        vertical: isWide ? 14 : 8,
                                      ),
                                      textStyle: TextStyle(fontSize: isWide ? 16 : 14),
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
}

class _StaticMapPainter extends CustomPainter {
  final List<Map<String, dynamic>> libraries;
  final ui.Image mapImage;

  _StaticMapPainter({required this.libraries, required this.mapImage});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the static map image
    final paint = Paint();
    canvas.drawImageRect(
      mapImage,
      Rect.fromLTWH(0, 0, mapImage.width.toDouble(), mapImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Define Kenya's approximate bounds for scaling
    const double minLat = -4.5; // Southernmost latitude
    const double maxLat = 5.0;  // Northernmost latitude
    const double minLng = 33.5; // Westernmost longitude
    const double maxLng = 42.0; // Easternmost longitude

    // Scale coordinates to fit the canvas
    for (var lib in libraries) {
      double lat = lib['lat'] as double;
      double lng = lib['lng'] as double;

      // Normalize latitude and longitude to [0,1]
      double x = (lng - minLng) / (maxLng - minLng);
      double y = 1.0 - (lat - minLat) / (maxLat - minLat); // Invert y for top-left origin

      // Convert to canvas coordinates
      double px = x * size.width;
      double py = y * size.height;

      // Draw a dot for each library
      canvas.drawCircle(
        Offset(px, py),
        5.0, // Dot radius
        Paint()..color = Colors.red,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}