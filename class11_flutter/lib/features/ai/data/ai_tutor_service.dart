import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_tutor_models.dart';

class AiTutorService {
  AiTutorService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'AI_BASE_URL',
            defaultValue: 'http://localhost:8000',
          );

  final http.Client _client;
  final String _baseUrl;

  Future<AiTutorResponse> getTutorResponse(AiTutorRequest request) async {
    final uri = Uri.parse('$_baseUrl/ai/tutor');
    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('AI tutor request failed: ${response.statusCode}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    return AiTutorResponse.fromJson(payload);
  }
}
