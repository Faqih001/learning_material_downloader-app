import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
    : _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  Future<String> sendMessage(String message) async {
    final response = await _model.generateContent([Content.text(message)]);
    return response.text ?? '';
  }
}
