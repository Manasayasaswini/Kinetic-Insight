import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_tutor_models.dart';

class AiTutorService {
  AiTutorService({http.Client? client})
    : _client = client ?? http.Client(),
      _baseUrl = const String.fromEnvironment('AI_BASE_URL');

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

  Future<McpExplanationResponse> getExperimentExplanation({
    required String classId,
    required String experimentId,
    required String language,
    String version = 'v1',
    String voiceProfile = 'teacher_warm_v1',
    String format = 'mp3',
  }) async {
    final uri =
        Uri.parse(
          '$_baseUrl/mcp/explanation/$classId/$experimentId/$language',
        ).replace(
          queryParameters: <String, String>{
            'version': version,
            'voice_profile': voiceProfile,
            'fmt': format,
          },
        );
    final response = await _client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('MCP explanation request failed: ${response.statusCode}');
    }
    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final audioUrlRaw = payload['audioUrl'];
    if (audioUrlRaw is String &&
        audioUrlRaw.startsWith('/') &&
        _baseUrl.isNotEmpty) {
      payload['audioUrl'] = '$_baseUrl$audioUrlRaw';
    }
    return McpExplanationResponse.fromJson(payload);
  }
}
