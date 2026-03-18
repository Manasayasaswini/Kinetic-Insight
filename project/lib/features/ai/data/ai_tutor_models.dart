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
