import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class GoogleMapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> libraries;
  const GoogleMapWidget({super.key, required this.libraries});

  @override
  Widget build(BuildContext context) {
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
