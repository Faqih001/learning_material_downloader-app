import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';

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
  final List<Map<String, dynamic>> _allLibraries = [
    {
      'name': 'Nairobi National Library',
      'lat': -1.286389,
      'lng': 36.817223,
      'county': 'Nairobi',
      'type': 'National',
    },
    {
      'name': 'Kenyatta University Library',
      'lat': -1.180019,
      'lng': 36.927532,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'Mombasa Library',
      'lat': -4.043477,
      'lng': 39.668206,
      'county': 'Mombasa',
      'type': 'Public',
    },
    {
      'name': 'Kisumu Public Library',
      'lat': -0.102206,
      'lng': 34.761711,
      'county': 'Kisumu',
      'type': 'Public',
    },
    {
      'name': 'Nakuru Library',
      'lat': -0.303099,
      'lng': 36.080025,
      'county': 'Nakuru',
      'type': 'Public',
    },
    {
      'name': 'Eldoret Library',
      'lat': 0.520360,
      'lng': 35.269779,
      'county': 'Uasin Gishu',
      'type': 'Public',
    },
    {
      'name': 'Thika Library',
      'lat': -1.033260,
      'lng': 37.069330,
      'county': 'Kiambu',
      'type': 'Public',
    },
    {
      'name': 'Nyeri Library',
      'lat': -0.420130,
      'lng': 36.947600,
      'county': 'Nyeri',
      'type': 'Public',
    },
    {
      'name': 'Meru Library',
      'lat': 0.047035,
      'lng': 37.649803,
      'county': 'Meru',
      'type': 'Public',
    },
    {
      'name': 'Machakos Library',
      'lat': -1.517683,
      'lng': 37.263414,
      'county': 'Machakos',
      'type': 'Public',
    },
    {
      'name': 'Embu Library',
      'lat': -0.537846,
      'lng': 37.457431,
      'county': 'Embu',
      'type': 'Public',
    },
    {
      'name': 'Kakamega Library',
      'lat': 0.282730,
      'lng': 34.751863,
      'county': 'Kakamega',
      'type': 'Public',
    },
    {
      'name': 'Garissa Library',
      'lat': -0.453229,
      'lng': 39.646098,
      'county': 'Garissa',
      'type': 'Public',
    },
    {
      'name': 'Kitale Library',
      'lat': 1.015720,
      'lng': 35.006220,
      'county': 'Trans Nzoia',
      'type': 'Public',
    },
    {
      'name': 'Kericho Library',
      'lat': -0.367100,
      'lng': 35.283100,
      'county': 'Kericho',
      'type': 'Public',
    },
    {
      'name': 'Bungoma Library',
      'lat': 0.563500,
      'lng': 34.560600,
      'county': 'Bungoma',
      'type': 'Public',
    },
    {
      'name': 'Vihiga Library',
      'lat': 0.070000,
      'lng': 34.720000,
      'county': 'Vihiga',
      'type': 'Public',
    },
    {
      'name': 'Narok Library',
      'lat': -1.078100,
      'lng': 35.860000,
      'county': 'Narok',
      'type': 'Public',
    },
    {
      'name': 'Isiolo Library',
      'lat': 0.354620,
      'lng': 37.582184,
      'county': 'Isiolo',
      'type': 'Public',
    },
    {
      'name': 'Marsabit Library',
      'lat': 2.334800,
      'lng': 37.990600,
      'county': 'Marsabit',
      'type': 'Public',
    },
    {
      'name': 'Wajir Library',
      'lat': 1.747100,
      'lng': 40.057300,
      'county': 'Wajir',
      'type': 'Public',
    },
    {
      'name': 'Mandera Library',
      'lat': 3.937260,
      'lng': 41.856900,
      'county': 'Mandera',
      'type': 'Public',
    },
    {
      'name': 'Lamu Library',
      'lat': -2.271690,
      'lng': 40.902000,
      'county': 'Lamu',
      'type': 'Public',
    },
    {
      'name': 'Taita Taveta Library',
      'lat': -3.389600,
      'lng': 38.492700,
      'county': 'Taita Taveta',
      'type': 'Public',
    },
    {
      'name': 'Kwale Library',
      'lat': -4.173000,
      'lng': 39.452100,
      'county': 'Kwale',
      'type': 'Public',
    },
    {
      'name': 'Kilifi Library',
      'lat': -3.633300,
      'lng': 39.850000,
      'county': 'Kilifi',
      'type': 'Public',
    },
    {
      'name': 'Malindi Library',
      'lat': -3.217600,
      'lng': 40.116900,
      'county': 'Kilifi',
      'type': 'Public',
    },
    {
      'name': 'Homa Bay Library',
      'lat': -0.527300,
      'lng': 34.457100,
      'county': 'Homa Bay',
      'type': 'Public',
    },
    {
      'name': 'Migori Library',
      'lat': -1.063400,
      'lng': 34.473100,
      'county': 'Migori',
      'type': 'Public',
    },
    {
      'name': 'Siaya Library',
      'lat': 0.061200,
      'lng': 34.288100,
      'county': 'Siaya',
      'type': 'Public',
    },
    {
      'name': 'Bomet Library',
      'lat': -0.782200,
      'lng': 35.342800,
      'county': 'Bomet',
      'type': 'Public',
    },
    {
      'name': 'Nandi Library',
      'lat': 0.120000,
      'lng': 35.200000,
      'county': 'Nandi',
      'type': 'Public',
    },
    {
      'name': 'Turkana Library',
      'lat': 3.121900,
      'lng': 35.597300,
      'county': 'Turkana',
      'type': 'Public',
    },
    {
      'name': 'West Pokot Library',
      'lat': 1.238100,
      'lng': 35.112800,
      'county': 'West Pokot',
      'type': 'Public',
    },
    {
      'name': 'Samburu Library',
      'lat': 0.515000,
      'lng': 37.528100,
      'county': 'Samburu',
      'type': 'Public',
    },
    {
      'name': 'Laikipia Library',
      'lat': 0.292100,
      'lng': 36.225100,
      'county': 'Laikipia',
      'type': 'Public',
    },
    {
      'name': 'Nyandarua Library',
      'lat': -0.183300,
      'lng': 36.366700,
      'county': 'Nyandarua',
      'type': 'Public',
    },
    {
      'name': 'Murang’a Library',
      'lat': -0.718600,
      'lng': 37.150000,
      'county': 'Murang’a',
      'type': 'Public',
    },
    {
      'name': 'Kiambu Library',
      'lat': -1.170000,
      'lng': 36.830000,
      'county': 'Kiambu',
      'type': 'Public',
    },
    {
      'name': 'Kajiado Library',
      'lat': -1.853100,
      'lng': 36.776800,
      'county': 'Kajiado',
      'type': 'Public',
    },
    {
      'name': 'Makueni Library',
      'lat': -1.803400,
      'lng': 37.620000,
      'county': 'Makueni',
      'type': 'Public',
    },
    {
      'name': 'Kitui Library',
      'lat': -1.375000,
      'lng': 38.010000,
      'county': 'Kitui',
      'type': 'Public',
    },
    {
      'name': 'Tana River Library',
      'lat': -1.833300,
      'lng': 40.083300,
      'county': 'Tana River',
      'type': 'Public',
    },
    {
      'name': 'Busia Library',
      'lat': 0.460000,
      'lng': 34.120000,
      'county': 'Busia',
      'type': 'Public',
    },
    {
      'name': 'Uasin Gishu Library',
      'lat': 0.340000,
      'lng': 35.550000,
      'county': 'Uasin Gishu',
      'type': 'Public',
    },
    {
      'name': 'Trans Nzoia Library',
      'lat': 1.020000,
      'lng': 34.990000,
      'county': 'Trans Nzoia',
      'type': 'Public',
    },
    {
      'name': 'Baringo Library',
      'lat': 0.470000,
      'lng': 36.090000,
      'county': 'Baringo',
      'type': 'Public',
    },
    {
      'name': 'Elgeyo Marakwet Library',
      'lat': 0.980000,
      'lng': 35.480000,
      'county': 'Elgeyo Marakwet',
      'type': 'Public',
    },
    {
      'name': 'Embu University Library',
      'lat': -0.531700,
      'lng': 37.457500,
      'county': 'Embu',
      'type': 'University',
    },
    {
      'name': 'Jomo Kenyatta Memorial Library (UoN)',
      'lat': -1.279750,
      'lng': 36.816223,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'Moi University Library',
      'lat': 0.283333,
      'lng': 35.350000,
      'county': 'Uasin Gishu',
      'type': 'University',
    },
    {
      'name': 'Egerton University Library',
      'lat': -0.377400,
      'lng': 35.942800,
      'county': 'Nakuru',
      'type': 'University',
    },
    {
      'name': 'Maseno University Library',
      'lat': -0.009167,
      'lng': 34.606111,
      'county': 'Siaya',
      'type': 'University',
    },
    {
      'name': 'Masinde Muliro University Library',
      'lat': 0.282730,
      'lng': 34.751863,
      'county': 'Kakamega',
      'type': 'University',
    },
    {
      'name': 'Pwani University Library',
      'lat': -3.633300,
      'lng': 39.850000,
      'county': 'Kilifi',
      'type': 'University',
    },
    {
      'name': 'Technical University of Kenya Library',
      'lat': -1.302200,
      'lng': 36.826800,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'Kenyatta University Postmodern Library',
      'lat': -1.180019,
      'lng': 36.927532,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'Catholic University of Eastern Africa Library',
      'lat': -1.317500,
      'lng': 36.815000,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'Strathmore University Library',
      'lat': -1.309000,
      'lng': 36.814000,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'Daystar University Library',
      'lat': -1.393600,
      'lng': 36.821900,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'USIU-Africa Library',
      'lat': -1.219000,
      'lng': 36.882000,
      'county': 'Nairobi',
      'type': 'University',
    },
    {
      'name': 'Mount Kenya University Library',
      'lat': -0.365700,
      'lng': 36.958600,
      'county': 'Nyeri',
      'type': 'University',
    },
    {
      'name': 'Chuka University Library',
      'lat': -0.333333,
      'lng': 37.633333,
      'county': 'Chuka',
      'type': 'University',
    },
    {
      'name': 'Kabarak University Library',
      'lat': -0.283333,
      'lng': 36.100000,
      'county': 'Nakuru',
      'type': 'University',
    },
    {
      'name': 'Kisii University Library',
      'lat': -0.681389,
      'lng': 34.766667,
      'county': 'Kisii',
      'type': 'University',
    },
    {
      'name': 'Jaramogi Oginga Odinga University Library',
      'lat': -0.091700,
      'lng': 34.196400,
      'county': 'Homa Bay',
      'type': 'University',
    },
    {
      'name': 'South Eastern Kenya University Library',
      'lat': -2.399000,
      'lng': 38.010000,
      'county': 'Kitui',
      'type': 'University',
    },
    {
      'name': 'Garissa University Library',
      'lat': -0.453229,
      'lng': 39.646098,
      'county': 'Garissa',
      'type': 'University',
    },
    {
      'name': 'Taita Taveta University Library',
      'lat': -3.389600,
      'lng': 38.492700,
      'county': 'Taita Taveta',
      'type': 'University',
    },
    {
      'name': 'Kisumu National Polytechnic Library',
      'lat': -0.102206,
      'lng': 34.761711,
      'county': 'Kisumu',
      'type': 'Polytechnic',
    },
    {
      'name': 'Kenya National Library Service - Buruburu',
      'lat': -1.284100,
      'lng': 36.886700,
      'county': 'Nairobi',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Upper Hill',
      'lat': -1.299400,
      'lng': 36.806900,
      'county': 'Nairobi',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Kisii',
      'lat': -0.681389,
      'lng': 34.766667,
      'county': 'Kisii',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Meru',
      'lat': 0.047035,
      'lng': 37.649803,
      'county': 'Meru',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Nakuru',
      'lat': -0.303099,
      'lng': 36.080025,
      'county': 'Nakuru',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Mombasa',
      'lat': -4.043477,
      'lng': 39.668206,
      'county': 'Mombasa',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Thika',
      'lat': -1.033260,
      'lng': 37.069330,
      'county': 'Kiambu',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Kakamega',
      'lat': 0.282730,
      'lng': 34.751863,
      'county': 'Kakamega',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Kisumu',
      'lat': -0.102206,
      'lng': 34.761711,
      'county': 'Kisumu',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Nyeri',
      'lat': -0.420130,
      'lng': 36.947600,
      'county': 'Nyeri',
      'type': 'National',
    },
    {
      'name': 'Kenya National Library Service - Machakos',
      'lat': -1.517683,
      'lng': 37.263414,
      'county': 'Machakos',
      'type': 'National',
    },
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

  void _openGoogleMaps({required double lat, required double lng, required String label}) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';
    debugPrint('Opening Google Maps: $url');
  }

  void _openDirections({required double lat, required double lng}) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    debugPrint('Opening directions: $url');
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open directions.')),
      );
    }
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
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _openDirections(lat: lat, lng: lng),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Get Directions'),
                ),
              ),
            ],
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