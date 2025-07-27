
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiApiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty) {
      return 'API key not found.';
    }
    final url = Uri.parse('$_baseUrl?key=$_apiKey');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': message},
          ],
        },
      ],
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? 'No response.';
      } else {
        return 'Error: \\${response.statusCode}';
      }
    } catch (e) {
      return 'Failed to connect to Gemini API.';
    }
  }

  /// Simulates streaming by splitting the response into chunks and yielding them.
  Stream<String> streamResponse(String message, {Duration chunkDelay = const Duration(milliseconds: 40)}) async* {
    final fullResponse = await sendMessage(message);
    // Split by word for a more natural effect
    final words = fullResponse.split(' ');
    var current = '';
    for (final word in words) {
      if (current.isEmpty) {
        current = word;
      } else {
        current += ' $word';
      }
      yield current;
      await Future.delayed(chunkDelay);
    }
  }
}
