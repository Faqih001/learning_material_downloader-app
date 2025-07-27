
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> libraries;
  const GoogleMapWidget({super.key, required this.libraries});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Use Mapbox Static Images API for web fallback
      // You need a Mapbox access token for production use
      const mapboxToken = 'pk.eyJ1IjoibWFwYm94dXNlciIsImEiOiJja2x4b2Z2b2MwMDFwMnBvN2Z2b2Z2b2Z2In0.2v1Qw1Qw1Qw1Qw1Qw1Qw1Q'; // Replace with your own
      final markerString = libraries.map((lib) =>
        'pin-s+555555(${lib['lng']},${lib['lat']})'
      ).join(',');
      final mapboxUrl =
        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/$markerString/37.9062,-0.0236,6/600x300?access_token=$mapboxToken';
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          mapboxUrl,
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Text('Map preview unavailable.'),
        ),
      );
    } else {
      final markers = libraries.map((lib) {
        return Marker(
          markerId: MarkerId(lib['name']),
          position: LatLng(lib['lat'], lib['lng']),
          infoWindow: InfoWindow(title: lib['name']),
        );
      }).toSet();
      return SizedBox(
        height: 300,
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(0.0236, 37.9062), // Center of Kenya
            zoom: 6.2,
          ),
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      );
    }
  }
}
