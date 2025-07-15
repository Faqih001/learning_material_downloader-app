import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    // The apiKey is set in the AndroidManifest.xml and Info.plist for real apps
    return SizedBox(
      height: 220,
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-1.286389, 36.817223), // Nairobi
          zoom: 12,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('nairobi_library'),
            position: LatLng(-1.286389, 36.817223),
            infoWindow: InfoWindow(title: 'Nairobi National Library'),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
