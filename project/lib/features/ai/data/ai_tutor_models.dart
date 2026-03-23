class AiTutorRequest {
  const AiTutorRequest({
    required this.classId,
    required this.experimentId,
    required this.mode,
    required this.studentState,
  });

  final String classId;
  final String experimentId;
  final String mode;
  final Map<String, dynamic> studentState;

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'experimentId': experimentId,
      'mode': mode,
      'studentState': studentState,
    };
  }
}

class AiTutorResponse {
  const AiTutorResponse({
    required this.question,
    required this.feedback,
    required this.nextStep,
    required this.status,
    required this.options,
    required this.isCorrect,
    required this.botMood,
    required this.answerReview,
  });

  final String question;
  final String feedback;
  final String nextStep;
  final String status;
  final List<String> options;
  final bool? isCorrect;
  final String botMood;
  final String answerReview;

  factory AiTutorResponse.fromJson(Map<String, dynamic> json) {
    return AiTutorResponse(
      question: (json['question'] ?? '').toString(),
      feedback: (json['feedback'] ?? '').toString(),
      nextStep: (json['nextStep'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      options: (json['options'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      isCorrect: json['isCorrect'] is bool ? json['isCorrect'] as bool : null,
      botMood: (json['botMood'] ?? 'neutral').toString(),
      answerReview: (json['answerReview'] ?? '').toString(),
    );
  }
}

class McpExplanationResponse {
  const McpExplanationResponse({
    required this.classId,
    required this.experimentId,
    required this.language,
    required this.version,
    required this.status,
    required this.scriptId,
    required this.script,
    required this.audioId,
    required this.audioUrl,
    required this.audioCached,
    required this.audioError,
  });

  final String classId;
  final String experimentId;
  final String language;
  final String version;
  final String status;
  final String scriptId;
  final String script;
  final String? audioId;
  final String? audioUrl;
  final bool audioCached;
  final String? audioError;

  factory McpExplanationResponse.fromJson(Map<String, dynamic> json) {
    return McpExplanationResponse(
      classId: (json['classId'] ?? '').toString(),
      experimentId: (json['experimentId'] ?? '').toString(),
      language: (json['language'] ?? '').toString(),
      version: (json['version'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      scriptId: (json['scriptId'] ?? '').toString(),
      script: (json['script'] ?? '').toString(),
      audioId: json['audioId']?.toString(),
      audioUrl: json['audioUrl']?.toString(),
      audioCached: json['audioCached'] is bool
          ? json['audioCached'] as bool
          : false,
      audioError: json['audioError']?.toString(),
    );
  }
}
