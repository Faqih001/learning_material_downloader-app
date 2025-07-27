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
      'lat': -1.286389,
      'lng': 36.817223,
    },
    {
      'name': 'Kenyatta University Library',
      'lat': -1.180019,
      'lng': 36.927532,
    },
    {
      'name': 'Mombasa Library',
      'lat': -4.043477,
      'lng': 39.668206,
    },
    {
      'name': 'Kisumu Public Library',
      'lat': -0.102206,
      'lng': 34.761711,
    },
    {
      'name': 'Nakuru Library',
      'lat': -0.303099,
      'lng': 36.080025,
    },
    {
      'name': 'Eldoret Library',
      'lat': 0.520360,
      'lng': 35.269779,
    },
    {
      'name': 'Thika Library',
      'lat': -1.033260,
      'lng': 37.069330,
    },
    {
      'name': 'Nyeri Library',
      'lat': -0.420130,
      'lng': 36.947600,
    },
    {
      'name': 'Meru Library',
      'lat': 0.047035,
      'lng': 37.649803,
    },
    {
      'name': 'Machakos Library',
      'lat': -1.517683,
      'lng': 37.263414,
    },
    {
      'name': 'Embu Library',
      'lat': -0.537846,
      'lng': 37.457431,
    },
    {
      'name': 'Kakamega Library',
      'lat': 0.282730,
      'lng': 34.751863,
    },
    {
      'name': 'Garissa Library',
      'lat': -0.453229,
      'lng': 39.646098,
    },
    {
      'name': 'Kitale Library',
      'lat': 1.015720,
      'lng': 35.006220,
    },
    {
      'name': 'Kericho Library',
      'lat': -0.367100,
      'lng': 35.283100,
    },
    {
      'name': 'Bungoma Library',
      'lat': 0.563500,
      'lng': 34.560600,
    },
    {
      'name': 'Vihiga Library',
      'lat': 0.070000,
      'lng': 34.720000,
    },
    {
      'name': 'Narok Library',
      'lat': -1.078100,
      'lng': 35.860000,
    },
    {
      'name': 'Isiolo Library',
      'lat': 0.354620,
      'lng': 37.582184,
    },
    {
      'name': 'Marsabit Library',
      'lat': 2.334800,
      'lng': 37.990600,
    },
    {
      'name': 'Wajir Library',
      'lat': 1.747100,
      'lng': 40.057300,
    },
    {
      'name': 'Mandera Library',
      'lat': 3.937260,
      'lng': 41.856900,
    },
    {
      'name': 'Lamu Library',
      'lat': -2.271690,
      'lng': 40.902000,
    },
    {
      'name': 'Taita Taveta Library',
      'lat': -3.389600,
      'lng': 38.492700,
    },
    {
      'name': 'Kwale Library',
      'lat': -4.173000,
      'lng': 39.452100,
    },
    {
      'name': 'Kilifi Library',
      'lat': -3.633300,
      'lng': 39.850000,
    },
    {
      'name': 'Malindi Library',
      'lat': -3.217600,
      'lng': 40.116900,
    },
    {
      'name': 'Homa Bay Library',
      'lat': -0.527300,
      'lng': 34.457100,
    },
    {
      'name': 'Migori Library',
      'lat': -1.063400,
      'lng': 34.473100,
    },
    {
      'name': 'Siaya Library',
      'lat': 0.061200,
      'lng': 34.288100,
    },
    {
      'name': 'Bomet Library',
      'lat': -0.782200,
      'lng': 35.342800,
    },
    {
      'name': 'Nandi Library',
      'lat': 0.120000,
      'lng': 35.200000,
    },
    {
      'name': 'Turkana Library',
      'lat': 3.121900,
      'lng': 35.597300,
    },
    {
      'name': 'West Pokot Library',
      'lat': 1.238100,
      'lng': 35.112800,
    },
    {
      'name': 'Samburu Library',
      'lat': 0.515000,
      'lng': 37.528100,
    },
    {
      'name': 'Laikipia Library',
      'lat': 0.292100,
      'lng': 36.225100,
    },
    {
      'name': 'Nyandarua Library',
      'lat': -0.183300,
      'lng': 36.366700,
    },
    {
      'name': 'Murang’a Library',
      'lat': -0.718600,
      'lng': 37.150000,
    },
    {
      'name': 'Kiambu Library',
      'lat': -1.170000,
      'lng': 36.830000,
    },
    {
      'name': 'Kajiado Library',
      'lat': -1.853100,
      'lng': 36.776800,
    },
    {
      'name': 'Makueni Library',
      'lat': -1.803400,
      'lng': 37.620000,
    },
    {
      'name': 'Kitui Library',
      'lat': -1.375000,
      'lng': 38.010000,
    },
    {
      'name': 'Tana River Library',
      'lat': -1.833300,
      'lng': 40.083300,
    },
    {
      'name': 'Busia Library',
      'lat': 0.460000,
      'lng': 34.120000,
    },
    {
      'name': 'Uasin Gishu Library',
      'lat': 0.340000,
      'lng': 35.550000,
    },
    {
      'name': 'Trans Nzoia Library',
      'lat': 1.020000,
      'lng': 34.990000,
    },
    {
      'name': 'Baringo Library',
      'lat': 0.470000,
      'lng': 36.090000,
    },
    {
      'name': 'Elgeyo Marakwet Library',
      'lat': 0.980000,
      'lng': 35.480000,
    },
    {
      'name': 'Embu University Library',
      'lat': -0.531700,
      'lng': 37.457500,
    },
    {
      'name': 'Jomo Kenyatta Memorial Library (UoN)',
      'lat': -1.279750,
      'lng': 36.816223,
    },
    {
      'name': 'Moi University Library',
      'lat': 0.283333,
      'lng': 35.350000,
    },
    {
      'name': 'Egerton University Library',
      'lat': -0.377400,
      'lng': 35.942800,
    },
    {
      'name': 'Maseno University Library',
      'lat': -0.009167,
      'lng': 34.606111,
    },
    {
      'name': 'Masinde Muliro University Library',
      'lat': 0.282730,
      'lng': 34.751863,
    },
    {
      'name': 'Pwani University Library',
      'lat': -3.633300,
      'lng': 39.850000,
    },
    {
      'name': 'Technical University of Kenya Library',
      'lat': -1.302200,
      'lng': 36.826800,
    },
    {
      'name': 'Kenyatta University Postmodern Library',
      'lat': -1.180019,
      'lng': 36.927532,
    },
    {
      'name': 'Catholic University of Eastern Africa Library',
      'lat': -1.317500,
      'lng': 36.815000,
    },
    {
      'name': 'Strathmore University Library',
      'lat': -1.309000,
      'lng': 36.814000,
    },
    {
      'name': 'Daystar University Library',
      'lat': -1.393600,
      'lng': 36.821900,
    },
    {
      'name': 'USIU-Africa Library',
      'lat': -1.219000,
      'lng': 36.882000,
    },
    {
      'name': 'Mount Kenya University Library',
      'lat': -0.365700,
      'lng': 36.958600,
    },
    {
      'name': 'Chuka University Library',
      'lat': -0.333333,
      'lng': 37.633333,
    },
    {
      'name': 'Kabarak University Library',
      'lat': -0.283333,
      'lng': 36.100000,
    },
    {
      'name': 'Kisii University Library',
      'lat': -0.681389,
      'lng': 34.766667,
    },
    {
      'name': 'Jaramogi Oginga Odinga University Library',
      'lat': -0.091700,
      'lng': 34.196400,
    },
    {
      'name': 'South Eastern Kenya University Library',
      'lat': -2.399000,
      'lng': 38.010000,
    },
    {
      'name': 'Garissa University Library',
      'lat': -0.453229,
      'lng': 39.646098,
    },
    {
      'name': 'Taita Taveta University Library',
      'lat': -3.389600,
      'lng': 38.492700,
    },
    {
      'name': 'Kisumu National Polytechnic Library',
      'lat': -0.102206,
      'lng': 34.761711,
    },
    {
      'name': 'Kenya National Library Service - Buruburu',
      'lat': -1.284100,
      'lng': 36.886700,
    },
    {
      'name': 'Kenya National Library Service - Upper Hill',
      'lat': -1.299400,
      'lng': 36.806900,
    },
    {
      'name': 'Kenya National Library Service - Kisii',
      'lat': -0.681389,
      'lng': 34.766667,
    },
    {
      'name': 'Kenya National Library Service - Meru',
      'lat': 0.047035,
      'lng': 37.649803,
    },
    {
      'name': 'Kenya National Library Service - Nakuru',
      'lat': -0.303099,
      'lng': 36.080025,
    },
    {
      'name': 'Kenya National Library Service - Mombasa',
      'lat': -4.043477,
      'lng': 39.668206,
    },
    {
      'name': 'Kenya National Library Service - Thika',
      'lat': -1.033260,
      'lng': 37.069330,
    },
    {
      'name': 'Kenya National Library Service - Kakamega',
      'lat': 0.282730,
      'lng': 34.751863,
    },
    {
      'name': 'Kenya National Library Service - Kisumu',
      'lat': -0.102206,
      'lng': 34.761711,
    },
    {
      'name': 'Kenya National Library Service - Nyeri',
      'lat': -0.420130,
      'lng': 36.947600,
    },
    {
      'name': 'Kenya National Library Service - Machakos',
      'lat': -1.517683,
      'lng': 37.263414,
    },
    // Add more libraries as needed
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
                  final double horizontalPadding = isWide ? 48.0 : 16.0;
                  final double mapHeight = isWide ? 320.0 : 220.0;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
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
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux) {
      return const GoogleMapWidget();
    } else {
      const double lat = -1.286389;
      const double lng = 36.817223;
      final osmUrl =
          'https://staticmap.openstreetmap.de/staticmap.php?center=$lat,$lng&zoom=12&size=600x220&markers=$lat,$lng,blue-pushpin';
      return Column(
        children: [
          Image.network(
            osmUrl,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Text('Map preview unavailable.'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.map),
            label: const Text('Open in Google Maps'),
            onPressed:
                () => MapUtils.openGoogleMaps(
                  lat: lat,
                  lng: lng,
                  label: 'Nairobi National Library',
                ),
          ),
        ],
      );
    }
  }

  void _showStaticMapDialog(Map<String, dynamic> lib) {
    final lat = lib['lat'] as double;
    final lng = lib['lng'] as double;
    final name = lib['name'] as String;
    final osmUrl =
        'https://staticmap.openstreetmap.de/staticmap.php?center=$lat,$lng&zoom=15&size=400x200&markers=$lat,$lng,blue-pushpin';
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(name),
            content: GestureDetector(
              onTap: () => _openGoogleMaps(lat: lat, lng: lng, label: name),
              child: Image.network(
                osmUrl,
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
                onPressed: () => _openDirections(lat: lat, lng: lng),
                child: const Text('Get Directions'),
              ),
            ],
          ),
    );
  }

  void _openGoogleMaps({
    required double lat,
    required double lng,
    required String label,
  }) async {
    try {
      await MapUtils.openGoogleMaps(lat: lat, lng: lng, label: label);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Could not open Google Maps: $e');
    }
  }

  void _openDirections({required double lat, required double lng}) async {
    try {
      await MapUtils.openDirections(lat: lat, lng: lng);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Could not open directions: $e');
    }
  }
}
