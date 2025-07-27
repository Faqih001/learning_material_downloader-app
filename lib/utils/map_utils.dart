import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> openGoogleMaps({required double lat, required double lng, String? label}) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng${label != null ? '($label)' : ''}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  static Future<void> openDirections({required double lat, required double lng}) async {
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch directions';
    }
  }
}
