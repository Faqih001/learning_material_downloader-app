import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GrokApiService {
  final String? apiKey = dotenv.env['GROK_API_KEY'];
  final String? endpoint = dotenv.env['GROK_API_ENDPOINT'];

  Future<String> sendMessage(String userMessage) async {
    if (apiKey == null || endpoint == null) {
      throw Exception('Grok API key or endpoint not set in .env');
    }
    final url = Uri.parse(endpoint!);
    final headers = {'Content-Type': 'application/json', 'api-key': apiKey!};
    final body = jsonEncode({
      "messages": [
        {"role": "system", "content": "You are an helpful assistant."},
        {"role": "user", "content": userMessage},
      ],
      "max_tokens": 1000,
      "model": "grok-3",
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Adjust this according to the actual API response structure
      return data['choices']?[0]?['message']?['content'] ?? 'No response.';
    } else {
      throw Exception(
        'Grok API error: ${response.statusCode} ${response.body}',
      );
    }
  }
}
