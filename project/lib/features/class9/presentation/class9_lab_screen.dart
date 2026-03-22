import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class9_kaleidoscope_calculator.dart';

enum _Class9Experiment { lawsOfReflection, kaleidoscope }

class _Class9CheckpointQuestion {
  const _Class9CheckpointQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class Class9LabScreen extends StatefulWidget {
  const Class9LabScreen({super.key});

  @override
  State<Class9LabScreen> createState() => _Class9LabScreenState();
}

class _Class9LabScreenState extends State<Class9LabScreen>
    with SingleTickerProviderStateMixin {
  static const String _checkpointPrompt =
      'Do the experiment and answer the checkpoint questions.';
  static const Map<_Class9Experiment, List<_Class9CheckpointQuestion>>
  _checkpointQuestionBank = {
    _Class9Experiment.lawsOfReflection: <_Class9CheckpointQuestion>[
      _Class9CheckpointQuestion(
        prompt:
            'According to the first law of reflection, angle of incidence is:',
        options: <String>[
          'Equal to angle of reflection',
          'Half of angle of reflection',
          'Double angle of reflection',
          'Always 90°',
        ],
        correctIndex: 0,
        explanation: 'The first law states that θi = θr.',
      ),
      _Class9CheckpointQuestion(
        prompt: 'Angles in reflection are measured between the ray and the:',
        options: <String>[
          'Normal to the mirror',
          'Mirror surface only',
          'Horizontal line only',
          'Vertical line only',
        ],
        correctIndex: 0,
        explanation:
            'Both incidence and reflection angles are measured from normal.',
      ),
      _Class9CheckpointQuestion(
        prompt: 'If angle of incidence is 35°, the reflected angle is:',
        options: <String>['20°', '35°', '55°', '70°'],
        correctIndex: 1,
        explanation: 'By law of reflection, reflected angle is also 35°.',
      ),
      _Class9CheckpointQuestion(
        prompt:
            'Incident ray, reflected ray, and normal at point of incidence lie in:',
        options: <String>[
          'The same plane',
          'Different planes',
          'Perpendicular planes only',
          'Only a curved surface',
        ],
        correctIndex: 0,
        explanation: 'The second law says all three lie in one common plane.',
      ),
      _Class9CheckpointQuestion(
        prompt:
            'When the incident angle increases on a plane mirror, reflected angle:',
        options: <String>[
          'Also increases by the same amount',
          'Decreases',
          'Stays zero',
          'Becomes random',
        ],
        correctIndex: 0,
        explanation:
            'Since θi = θr, both angles change equally for a plane mirror.',
      ),
    ],
    _Class9Experiment.kaleidoscope: <_Class9CheckpointQuestion>[
      _Class9CheckpointQuestion(
        prompt:
            'In a kaleidoscope, repeated patterns are formed mainly due to:',
        options: <String>[
          'Multiple reflections between mirrors',
          'Refraction through water',
          'Diffraction at edges',
          'Magnetic field lines',
        ],
        correctIndex: 0,
        explanation:
            'Kaleidoscope images are created by repeated mirror reflections.',
      ),
      _Class9CheckpointQuestion(
        prompt:
            'As the angle between two mirrors decreases, number of images generally:',
        options: <String>[
          'Increases',
          'Decreases',
          'Becomes zero',
          'Stays exactly one',
        ],
        correctIndex: 0,
        explanation:
            'Smaller mirror angle gives more sectors and therefore more images.',
      ),
      _Class9CheckpointQuestion(
        prompt: 'If mirror angle is 60°, estimated sectors are close to:',
        options: <String>['3', '6', '12', '60'],
        correctIndex: 1,
        explanation: 'Using 360° / θ, sectors are approximately 360/60 = 6.',
      ),
      _Class9CheckpointQuestion(
        prompt: 'A basic kaleidoscope arrangement commonly uses:',
        options: <String>[
          'Two or more mirrors inclined to each other',
          'One plane mirror only',
          'A convex lens only',
          'A prism without mirrors',
        ],
        correctIndex: 0,
        explanation:
            'At least two inclined mirrors are required for repeated reflections.',
      ),
      _Class9CheckpointQuestion(
        prompt:
            'For angle θ between mirrors, image multiplication trend follows:',
        options: <String>[
          'Roughly proportional to 360°/θ',
          'Proportional to θ only',
          'Independent of θ',
          'Always fixed at 2 images',
        ],
        correctIndex: 0,
        explanation:
            'Image repetition scales with sector count based on 360°/θ.',
      ),
    ],
  };

  _Class9Experiment _active = _Class9Experiment.lawsOfReflection;

  double _incidentAngle = 30;
  double _mirrorAngle = 45;
  int _numberOfMirrors = 2;
  KaleidoscopeResult? _result;

  late final AnimationController _rayController;
  final Map<_Class9Experiment, bool> _checkpointVisible =
      <_Class9Experiment, bool>{};
  final Map<_Class9Experiment, int> _checkpointIndex =
      <_Class9Experiment, int>{};
  final Map<_Class9Experiment, List<int?>> _checkpointAnswers =
      <_Class9Experiment, List<int?>>{};
  final Map<_Class9Experiment, List<bool>> _checkpointSubmitted =
      <_Class9Experiment, List<bool>>{};
  final Map<_Class9Experiment, String> _checkpointFeedback =
      <_Class9Experiment, String>{};
  final Map<_Class9Experiment, int> _checkpointScore =
      <_Class9Experiment, int>{};

  String? _inputError;

  @override
  void initState() {
    super.initState();
    _rayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    for (final experiment in _Class9Experiment.values) {
      _resetCheckpoint(experiment);
    }
    _calculate();
  }

  @override
  void dispose() {
    _rayController.dispose();
    super.dispose();
  }

  void _calculate() {
    final result = KaleidoscopeCalculator.calculateForTwoMirrors(
      mirrorAngleDegrees: _mirrorAngle,
      numberOfMirrors: _numberOfMirrors,
    );
    setState(() {
      _result = result;
      _inputError = result.isValid ? null : result.message;
    });
  }

  List<_Class9CheckpointQuestion> _activeQuestions() {
    return _checkpointQuestionBank[_active] ??
        const <_Class9CheckpointQuestion>[];
  }

  void _resetCheckpoint(_Class9Experiment experiment) {
    final total = _checkpointQuestionBank[experiment]?.length ?? 0;
    _checkpointVisible[experiment] = false;
    _checkpointIndex[experiment] = 0;
    _checkpointAnswers[experiment] = List<int?>.filled(total, null);
    _checkpointSubmitted[experiment] = List<bool>.filled(total, false);
    _checkpointFeedback[experiment] = '';
    _checkpointScore[experiment] = 0;
  }

  bool _isExperimentVerified() {
    final questions = _activeQuestions();
    final submitted = _checkpointSubmitted[_active] ?? const <bool>[];
    final allAnswered =
        questions.isNotEmpty &&
        submitted.length == questions.length &&
        submitted.every((value) => value);
    final score = _checkpointScore[_active] ?? 0;
    return allAnswered && score >= 4;
  }

  void _startCheckpoint() {
    final experiment = _active;
    setState(() {
      _checkpointVisible[experiment] = true;
      _checkpointFeedback[experiment] = '';
    });
  }

  void _selectCheckpointOption(int optionIndex) {
    final experiment = _active;
    final index = _checkpointIndex[experiment] ?? 0;
    final answers = _checkpointAnswers[experiment];
    final submitted = _checkpointSubmitted[experiment];
    if (answers == null || submitted == null || submitted[index]) {
      return;
    }
    setState(() {
      answers[index] = optionIndex;
      _checkpointFeedback[experiment] = '';
    });
  }

  void _submitCheckpointAnswer() {
    final experiment = _active;
    final questions = _activeQuestions();
    if (questions.isEmpty) return;
    final index = (_checkpointIndex[experiment] ?? 0).clamp(
      0,
      questions.length - 1,
    );
    final answers = _checkpointAnswers[experiment];
    final submitted = _checkpointSubmitted[experiment];
    if (answers == null || submitted == null) return;

    final selected = answers[index];
    if (selected == null) {
      setState(() {
        _checkpointFeedback[experiment] = 'Select an option before submitting.';
      });
      return;
    }
    if (submitted[index]) {
      setState(() {
        _checkpointFeedback[experiment] =
            'This question is already submitted. Use Next Question.';
      });
      return;
    }

    final question = questions[index];
    final isCorrect = selected == question.correctIndex;

    setState(() {
      submitted[index] = true;
      if (isCorrect) {
        _checkpointScore[experiment] = (_checkpointScore[experiment] ?? 0) + 1;
      }
      _checkpointFeedback[experiment] = isCorrect
          ? 'Correct. ${question.explanation}'
          : 'Not correct. ${question.explanation}';
    });
  }

  void _goToNextCheckpointQuestion() {
    final experiment = _active;
    final questions = _activeQuestions();
    if (questions.isEmpty) return;
    final index = (_checkpointIndex[experiment] ?? 0).clamp(
      0,
      questions.length - 1,
    );
    final submitted = _checkpointSubmitted[experiment] ?? const <bool>[];
    if (!submitted[index]) {
      setState(() {
        _checkpointFeedback[experiment] =
            'Submit this answer before moving to the next question.';
      });
      return;
    }
    if (index < questions.length - 1) {
      setState(() {
        _checkpointIndex[experiment] = index + 1;
        _checkpointFeedback[experiment] = '';
      });
    }
  }

  void _restartCheckpoint() {
    final experiment = _active;
    setState(() {
      _resetCheckpoint(experiment);
      _checkpointVisible[experiment] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeQuestions = _activeQuestions();
    final activeQuestionIndex = activeQuestions.isEmpty
        ? 0
        : (_checkpointIndex[_active] ?? 0).clamp(0, activeQuestions.length - 1);
    final activeAnswers = _checkpointAnswers[_active] ?? const <int?>[];
    final activeSubmitted = _checkpointSubmitted[_active] ?? const <bool>[];
    final activeQuestion = activeQuestions.isEmpty
        ? const _Class9CheckpointQuestion(
            prompt: '',
            options: <String>[],
            correctIndex: 0,
            explanation: '',
          )
        : activeQuestions[activeQuestionIndex];
    final selectedCheckpointOption = activeQuestionIndex < activeAnswers.length
        ? activeAnswers[activeQuestionIndex]
        : null;
    final activeCheckpointSubmitted =
        activeQuestionIndex < activeSubmitted.length
        ? activeSubmitted[activeQuestionIndex]
        : false;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFF7F3EA), Color(0xFFE8F0FA)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class 9 - Kaleidoscope & Laws of Reflection',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore multiple reflections with mirrors at varying angles. Understand how kaleidoscopes create symmetrical patterns.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  SegmentedButton<_Class9Experiment>(
                    segments: const [
                      ButtonSegment<_Class9Experiment>(
                        value: _Class9Experiment.lawsOfReflection,
                        label: Text('Laws of Reflection'),
                      ),
                      ButtonSegment<_Class9Experiment>(
                        value: _Class9Experiment.kaleidoscope,
                        label: Text('Kaleidoscope'),
                      ),
                    ],
                    selected: <_Class9Experiment>{_active},
                    onSelectionChanged: (value) {
                      setState(() {
                        _active = value.first;
                        _inputError = null;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  if (_inputError != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Text(
                        _inputError!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFB91C1C),
                        ),
                      ),
                    ),
                  if (_inputError != null) const SizedBox(height: 18),
                  if (_active == _Class9Experiment.lawsOfReflection)
                    _LawsOfReflectionExperiment(
                      incidentAngle: _incidentAngle,
                      isVerified: _isExperimentVerified(),
                      checkpointPrompt: _checkpointPrompt,
                      checkpointVisible: _checkpointVisible[_active] ?? false,
                      checkpointQuestion: activeQuestion,
                      checkpointQuestionIndex: activeQuestionIndex,
                      checkpointTotalQuestions: activeQuestions.length,
                      checkpointSelectedOption: selectedCheckpointOption,
                      checkpointSubmitted: activeCheckpointSubmitted,
                      checkpointFeedback: _checkpointFeedback[_active] ?? '',
                      checkpointScore: _checkpointScore[_active] ?? 0,
                      onStartCheckpoint: _startCheckpoint,
                      onCheckpointOptionSelected: _selectCheckpointOption,
                      onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                      onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                      onRestartCheckpoint: _restartCheckpoint,
                      onIncidentAngleChanged: (value) {
                        setState(() => _incidentAngle = value);
                      },
                    ),
                  if (_active == _Class9Experiment.kaleidoscope)
                    _KaleidoscopeExperiment(
                      mirrorAngle: _mirrorAngle,
                      numberOfMirrors: _numberOfMirrors,
                      result: _result,
                      onMirrorAngleChanged: (value) {
                        setState(() => _mirrorAngle = value);
                        _calculate();
                      },
                      onNumberOfMirrorsChanged: (value) {
                        setState(() => _numberOfMirrors = value);
                        _calculate();
                      },
                      rayController: _rayController,
                      isVerified: _isExperimentVerified(),
                      checkpointPrompt: _checkpointPrompt,
                      checkpointVisible: _checkpointVisible[_active] ?? false,
                      checkpointQuestion: activeQuestion,
                      checkpointQuestionIndex: activeQuestionIndex,
                      checkpointTotalQuestions: activeQuestions.length,
                      checkpointSelectedOption: selectedCheckpointOption,
                      checkpointSubmitted: activeCheckpointSubmitted,
                      checkpointFeedback: _checkpointFeedback[_active] ?? '',
                      checkpointScore: _checkpointScore[_active] ?? 0,
                      onStartCheckpoint: _startCheckpoint,
                      onCheckpointOptionSelected: _selectCheckpointOption,
                      onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                      onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                      onRestartCheckpoint: _restartCheckpoint,
                    ),
                  const SizedBox(height: 32),
                  Text(
                    'Student Spec Document',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Read this before running the experiments. This section is part of your learning material.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const _SpecDocumentCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LawsOfReflectionExperiment extends StatelessWidget {
  const _LawsOfReflectionExperiment({
    required this.incidentAngle,
    required this.isVerified,
    required this.checkpointPrompt,
    required this.checkpointVisible,
    required this.checkpointQuestion,
    required this.checkpointQuestionIndex,
    required this.checkpointTotalQuestions,
    required this.checkpointSelectedOption,
    required this.checkpointSubmitted,
    required this.checkpointFeedback,
    required this.checkpointScore,
    required this.onStartCheckpoint,
    required this.onCheckpointOptionSelected,
    required this.onSubmitCheckpointAnswer,
    required this.onNextCheckpointQuestion,
    required this.onRestartCheckpoint,
    required this.onIncidentAngleChanged,
  });

  final double incidentAngle;
  final bool isVerified;
  final String checkpointPrompt;
  final bool checkpointVisible;
  final _Class9CheckpointQuestion checkpointQuestion;
  final int checkpointQuestionIndex;
  final int checkpointTotalQuestions;
  final int? checkpointSelectedOption;
  final bool checkpointSubmitted;
  final String checkpointFeedback;
  final int checkpointScore;
  final VoidCallback onStartCheckpoint;
  final ValueChanged<int> onCheckpointOptionSelected;
  final VoidCallback onSubmitCheckpointAnswer;
  final VoidCallback onNextCheckpointQuestion;
  final VoidCallback onRestartCheckpoint;
  final ValueChanged<double> onIncidentAngleChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('1) Laws of Reflection', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(
          'Angle of incidence = Angle of reflection',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        Text('Inputs', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.straighten, size: 20),
            const SizedBox(width: 8),
            Text(
              'Incident angle: ${incidentAngle.toStringAsFixed(0)}°',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        Slider(
          value: incidentAngle,
          min: 0,
          max: 90,
          divisions: 18,
          label: '${incidentAngle.toStringAsFixed(0)}°',
          onChanged: onIncidentAngleChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text('0°'), Text('45°'), Text('90°')],
        ),
        const SizedBox(height: 16),
        Text('Canvas', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: _ReflectionLawStage(incidentAngle: incidentAngle),
        ),
        const SizedBox(height: 16),
        _ResultPanel(
          title: 'Output',
          body:
              'Incident angle θi = ${incidentAngle.toStringAsFixed(0)}°\n'
              'Reflection angle θr = ${incidentAngle.toStringAsFixed(0)}°\n'
              'θi = θr (Law of Reflection confirmed)',
        ),
        const SizedBox(height: 16),
        _CheckpointCard(
          prompt: checkpointPrompt,
          question: checkpointQuestion,
          questionIndex: checkpointQuestionIndex,
          totalQuestions: checkpointTotalQuestions,
          selectedOption: checkpointSelectedOption,
          isSubmitted: checkpointSubmitted,
          feedback: checkpointFeedback,
          score: checkpointScore,
          isVerified: isVerified,
          visible: checkpointVisible,
          onStart: onStartCheckpoint,
          onOptionSelected: onCheckpointOptionSelected,
          onSubmitAnswer: onSubmitCheckpointAnswer,
          onNextQuestion: onNextCheckpointQuestion,
          onRestart: onRestartCheckpoint,
        ),
      ],
    );
  }
}

class _ReflectionLawStage extends StatelessWidget {
  const _ReflectionLawStage({required this.incidentAngle});

  final double incidentAngle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: CustomPaint(
        painter: _ReflectionLawPainter(incidentAngle),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ReflectionLawPainter extends CustomPainter {
  _ReflectionLawPainter(this.incidentAngle);

  final double incidentAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.58);
    final margin = math.min(size.width, size.height) * 0.08;
    final mirrorHalf = (size.width * 0.40).clamp(120.0, 260.0);
    final rayLength = (size.height * 0.38).clamp(85.0, 170.0);
    final arcRadius = (rayLength * 0.48).clamp(38.0, 72.0);
    final incidentRad = incidentAngle * math.pi / 180;

    final incidentStart = Offset(
      center.dx - rayLength * math.sin(incidentRad),
      center.dy - rayLength * math.cos(incidentRad),
    );
    final reflectedEnd = Offset(
      center.dx + rayLength * math.sin(incidentRad),
      center.dy - rayLength * math.cos(incidentRad),
    );

    final mirrorPaint = Paint()
      ..color = const Color(0xFF475569)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final mirrorAccentPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.5;
    final normalPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final incidentPaint = Paint()
      ..color = const Color(0xFF0F766E)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final reflectedPaint = Paint()
      ..color = const Color(0xFFB91C1C)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final leftMirror = Offset(center.dx - mirrorHalf, center.dy);
    final rightMirror = Offset(center.dx + mirrorHalf, center.dy);
    canvas.drawLine(leftMirror, rightMirror, mirrorPaint);
    for (var i = 0; i <= 28; i++) {
      final t = i / 28;
      final x = leftMirror.dx + (rightMirror.dx - leftMirror.dx) * t;
      canvas.drawLine(
        Offset(x - 8, center.dy + 7),
        Offset(x, center.dy),
        mirrorAccentPaint,
      );
    }

    _drawDashedLine(
      canvas: canvas,
      start: Offset(center.dx, margin),
      end: Offset(center.dx, size.height - margin * 0.65),
      dashLength: 8,
      gapLength: 6,
      paint: normalPaint,
    );

    canvas.drawLine(incidentStart, center, incidentPaint);
    canvas.drawLine(center, reflectedEnd, reflectedPaint);
    _drawArrowHead(
      canvas: canvas,
      tip: center,
      tail: incidentStart,
      color: const Color(0xFF0F766E),
    );
    _drawArrowHead(
      canvas: canvas,
      tip: reflectedEnd,
      tail: center,
      color: const Color(0xFFB91C1C),
    );

    final incidentArcPaint = Paint()
      ..color = const Color(0xFF0F766E)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    final reflectedArcPaint = Paint()
      ..color = const Color(0xFFB91C1C)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    final arcRect = Rect.fromCircle(center: center, radius: arcRadius);
    canvas.drawArc(
      arcRect,
      -math.pi / 2 - incidentRad,
      incidentRad,
      false,
      incidentArcPaint,
    );
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      incidentRad,
      false,
      reflectedArcPaint,
    );

    _paintLabel(
      canvas,
      'Incident ray',
      incidentStart + const Offset(-8, -18),
      const Color(0xFF0F766E),
      bold: true,
    );
    _paintLabel(
      canvas,
      'Reflected ray',
      reflectedEnd + const Offset(-18, -20),
      const Color(0xFFB91C1C),
      bold: true,
    );
    _paintLabel(
      canvas,
      'Normal',
      Offset(center.dx + 10, center.dy + 12),
      const Color(0xFF64748B),
      italic: true,
    );
    _paintLabel(
      canvas,
      'Mirror',
      Offset(rightMirror.dx - 54, center.dy + 12),
      const Color(0xFF475569),
    );
    _paintLabel(
      canvas,
      'θi = ${incidentAngle.toStringAsFixed(0)}°',
      Offset(center.dx - arcRadius - 54, center.dy - arcRadius - 10),
      const Color(0xFF0F766E),
      bold: true,
    );
    _paintLabel(
      canvas,
      'θr = ${incidentAngle.toStringAsFixed(0)}°',
      Offset(center.dx + 10, center.dy - arcRadius - 10),
      const Color(0xFFB91C1C),
      bold: true,
    );
  }

  void _drawDashedLine({
    required Canvas canvas,
    required Offset start,
    required Offset end,
    required double dashLength,
    required double gapLength,
    required Paint paint,
  }) {
    final distance = (end - start).distance;
    final direction = (end - start) / distance;
    double covered = 0;
    while (covered < distance) {
      final from = start + direction * covered;
      final to = start + direction * math.min(covered + dashLength, distance);
      canvas.drawLine(from, to, paint);
      covered += dashLength + gapLength;
    }
  }

  void _drawArrowHead({
    required Canvas canvas,
    required Offset tip,
    required Offset tail,
    required Color color,
  }) {
    final direction = (tip - tail);
    final length = direction.distance;
    if (length < 0.1) return;
    final unit = direction / length;
    final perp = Offset(-unit.dy, unit.dx);
    const arrowLength = 12.0;
    const arrowWidth = 6.0;
    final base = tip - unit * arrowLength;
    final p1 = base + perp * arrowWidth;
    final p2 = base - perp * arrowWidth;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void _paintLabel(
    Canvas canvas,
    String text,
    Offset offset,
    Color color, {
    bool bold = false,
    bool italic = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ReflectionLawPainter oldDelegate) =>
      oldDelegate.incidentAngle != incidentAngle;
}

class _KaleidoscopeExperiment extends StatelessWidget {
  const _KaleidoscopeExperiment({
    required this.mirrorAngle,
    required this.numberOfMirrors,
    required this.result,
    required this.isVerified,
    required this.checkpointPrompt,
    required this.checkpointVisible,
    required this.checkpointQuestion,
    required this.checkpointQuestionIndex,
    required this.checkpointTotalQuestions,
    required this.checkpointSelectedOption,
    required this.checkpointSubmitted,
    required this.checkpointFeedback,
    required this.checkpointScore,
    required this.onStartCheckpoint,
    required this.onCheckpointOptionSelected,
    required this.onSubmitCheckpointAnswer,
    required this.onNextCheckpointQuestion,
    required this.onRestartCheckpoint,
    required this.onMirrorAngleChanged,
    required this.onNumberOfMirrorsChanged,
    required this.rayController,
  });

  final double mirrorAngle;
  final int numberOfMirrors;
  final KaleidoscopeResult? result;
  final bool isVerified;
  final String checkpointPrompt;
  final bool checkpointVisible;
  final _Class9CheckpointQuestion checkpointQuestion;
  final int checkpointQuestionIndex;
  final int checkpointTotalQuestions;
  final int? checkpointSelectedOption;
  final bool checkpointSubmitted;
  final String checkpointFeedback;
  final int checkpointScore;
  final VoidCallback onStartCheckpoint;
  final ValueChanged<int> onCheckpointOptionSelected;
  final VoidCallback onSubmitCheckpointAnswer;
  final VoidCallback onNextCheckpointQuestion;
  final VoidCallback onRestartCheckpoint;
  final ValueChanged<double> onMirrorAngleChanged;
  final ValueChanged<int> onNumberOfMirrorsChanged;
  final AnimationController rayController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2) Kaleidoscope: Multiple Reflections',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text('Inputs', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mirror angle: ${mirrorAngle.toStringAsFixed(0)}°',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Slider(
                    value: mirrorAngle,
                    min: 15,
                    max: 90,
                    divisions: 15,
                    label: '${mirrorAngle.toStringAsFixed(0)}°',
                    onChanged: onMirrorAngleChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of mirrors: $numberOfMirrors',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Slider(
                    value: numberOfMirrors.toDouble(),
                    min: 2,
                    max: 6,
                    divisions: 4,
                    label: '$numberOfMirrors',
                    onChanged: (v) => onNumberOfMirrorsChanged(v.round()),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Canvas', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth.clamp(200.0, 360.0);
              return SizedBox(
                width: size,
                height: size,
                child: AnimatedBuilder(
                  animation: rayController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _KaleidoscopePainter(
                        mirrorAngleDegrees: mirrorAngle,
                        numberOfMirrors: numberOfMirrors,
                        animationValue: rayController.value,
                      ),
                      child: const SizedBox.expand(),
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (result != null) ...[
          const SizedBox(height: 16),
          _ResultPanel(
            title: 'Output',
            body:
                'Mirror angle θ = ${result!.mirrorAngleDegrees.toStringAsFixed(0)}°\n'
                'Number of sectors = ${result!.numberOfSectors}\n'
                'Reflection count = ${result!.reflectionCount}\n'
                'Total images visible = ${result!.imageCount}',
          ),
        ],
        const SizedBox(height: 16),
        _CheckpointCard(
          prompt: checkpointPrompt,
          question: checkpointQuestion,
          questionIndex: checkpointQuestionIndex,
          totalQuestions: checkpointTotalQuestions,
          selectedOption: checkpointSelectedOption,
          isSubmitted: checkpointSubmitted,
          feedback: checkpointFeedback,
          score: checkpointScore,
          isVerified: isVerified,
          visible: checkpointVisible,
          onStart: onStartCheckpoint,
          onOptionSelected: onCheckpointOptionSelected,
          onSubmitAnswer: onSubmitCheckpointAnswer,
          onNextQuestion: onNextCheckpointQuestion,
          onRestart: onRestartCheckpoint,
        ),
      ],
    );
  }
}

class _KaleidoscopePainter extends CustomPainter {
  _KaleidoscopePainter({
    required this.mirrorAngleDegrees,
    required this.numberOfMirrors,
    required this.animationValue,
  });

  final double mirrorAngleDegrees;
  final int numberOfMirrors;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF334155)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFFEAB308),
      const Color(0xFF22C55E),
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
    ];

    final angleRad = (mirrorAngleDegrees * math.pi) / 180;
    final sectorCount = (2 * math.pi / angleRad).floor();

    if (numberOfMirrors == 2) {
      final mirrorLength = radius * 0.85;
      final mirror1Angle = -math.pi / 2 - angleRad / 2;
      final mirror2Angle = -math.pi / 2 + angleRad / 2;

      canvas.drawLine(
        center,
        Offset(
          center.dx + mirrorLength * math.cos(mirror1Angle),
          center.dy + mirrorLength * math.sin(mirror1Angle),
        ),
        Paint()
          ..color = const Color(0xFFCBD5E1)
          ..strokeWidth = 4,
      );
      canvas.drawLine(
        center,
        Offset(
          center.dx + mirrorLength * math.cos(mirror2Angle),
          center.dy + mirrorLength * math.sin(mirror2Angle),
        ),
        Paint()
          ..color = const Color(0xFFCBD5E1)
          ..strokeWidth = 4,
      );

      final objectRadius = radius * 0.6;
      final objectAngle = -math.pi / 2 + (animationValue * 2 * math.pi);
      final objectX = center.dx + objectRadius * math.cos(objectAngle);
      final objectY = center.dy + objectRadius * math.sin(objectAngle);

      canvas.drawCircle(
        Offset(objectX, objectY),
        8,
        Paint()
          ..color = const Color(0xFFFBBF24)
          ..style = PaintingStyle.fill,
      );

      for (var i = 0; i < sectorCount; i++) {
        final sectorAngle = i * angleRad;
        final innerRadius = radius * 0.15;
        final outerRadius = radius * 0.85;

        final path = Path();
        final color = colors[i % colors.length];

        for (var j = 0; j <= 8; j++) {
          final t = j / 8;
          final r = innerRadius + (outerRadius - innerRadius) * t;
          final a = sectorAngle + (angleRad * t);
          final x = center.dx + r * math.cos(a);
          final y = center.dy + r * math.sin(a);
          if (j == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }

        canvas.drawPath(
          path,
          Paint()
            ..color = color.withValues(alpha: 0.7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
    } else {
      final mirrorLength = radius * 0.85;
      final angleBetweenMirrors = (2 * math.pi) / numberOfMirrors;

      for (var i = 0; i < numberOfMirrors; i++) {
        final mirrorAngle = (i * angleBetweenMirrors) - math.pi / 2;
        final endX = center.dx + mirrorLength * math.cos(mirrorAngle);
        final endY = center.dy + mirrorLength * math.sin(mirrorAngle);

        canvas.drawLine(
          center,
          Offset(endX, endY),
          Paint()
            ..color = const Color(0xFFCBD5E1)
            ..strokeWidth = 4,
        );
      }

      for (var sector = 0; sector < sectorCount; sector++) {
        final sectorAngle = sector * angleRad;
        final color = colors[sector % colors.length];

        for (var ring = 1; ring <= 3; ring++) {
          final blobRadius = radius * (0.2 + ring * 0.2);
          final blobAngle =
              sectorAngle +
              (ring * 0.3) +
              (animationValue * 2 * math.pi / (ring + 1));
          final blobX = center.dx + blobRadius * math.cos(blobAngle);
          final blobY = center.dy + blobRadius * math.sin(blobAngle);

          canvas.drawCircle(
            Offset(blobX, blobY),
            6.0 + ring * 2,
            Paint()
              ..color = color.withValues(alpha: 0.6)
              ..style = PaintingStyle.fill,
          );
        }
      }
    }

    canvas.drawCircle(
      center,
      6,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _KaleidoscopePainter oldDelegate) =>
      oldDelegate.mirrorAngleDegrees != mirrorAngleDegrees ||
      oldDelegate.numberOfMirrors != numberOfMirrors ||
      oldDelegate.animationValue != animationValue;
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFF93C5FD),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckpointCard extends StatelessWidget {
  const _CheckpointCard({
    required this.prompt,
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    required this.selectedOption,
    required this.isSubmitted,
    required this.feedback,
    required this.score,
    required this.isVerified,
    required this.visible,
    required this.onStart,
    required this.onOptionSelected,
    required this.onSubmitAnswer,
    required this.onNextQuestion,
    required this.onRestart,
  });

  final String prompt;
  final _Class9CheckpointQuestion question;
  final int questionIndex;
  final int totalQuestions;
  final int? selectedOption;
  final bool isSubmitted;
  final String feedback;
  final int score;
  final bool isVerified;
  final bool visible;
  final VoidCallback onStart;
  final ValueChanged<int> onOptionSelected;
  final VoidCallback onSubmitAnswer;
  final VoidCallback onNextQuestion;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastQuestion = questionIndex >= totalQuestions - 1;
    final allSubmitted = questionIndex == totalQuestions - 1 && isSubmitted;
    final chipText = isVerified ? 'Verified' : 'Not Verified';
    final chipColor = isVerified
        ? const Color(0xFF166534)
        : const Color(0xFF9A3412);
    final chipBackground = isVerified
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFFEDD5);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Experiment Checkpoint', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(prompt, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: chipBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$chipText • Score $score/$totalQuestions',
              style: theme.textTheme.bodySmall?.copyWith(
                color: chipColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!visible) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onStart,
              child: const Text('Start Checkpoint'),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              'Question ${questionIndex + 1} of $totalQuestions',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(question.prompt, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            for (var i = 0; i < question.options.length; i++) ...[
              RadioListTile<int>(
                value: i,
                groupValue: selectedOption,
                onChanged: isSubmitted ? null : (value) => onOptionSelected(i),
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(question.options[i]),
              ),
              if (i < question.options.length - 1) const SizedBox(height: 4),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton(
                  onPressed: isSubmitted ? null : onSubmitAnswer,
                  child: const Text('Submit'),
                ),
                OutlinedButton(
                  onPressed: isLastQuestion ? null : onNextQuestion,
                  child: const Text('Next Question'),
                ),
                TextButton(
                  onPressed: onRestart,
                  child: const Text('Retry Checkpoint'),
                ),
              ],
            ),
            if (feedback.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(feedback, style: theme.textTheme.bodyMedium),
            ],
            if (allSubmitted) ...[
              const SizedBox(height: 10),
              Text(
                isVerified
                    ? 'Checkpoint finished. Experiment verified.'
                    : 'Checkpoint finished. Score 4/5 or above is needed to verify this experiment.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SpecDocumentCard extends StatelessWidget {
  const _SpecDocumentCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Class 9 Student Guide', style: theme.textTheme.titleLarge),
          const SizedBox(height: 14),
          Text('1. Laws of Reflection', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'What you do: Move the slider to change the angle of incidence.\n'
            'What you see: The angle of reflection changes to match.\n'
            'Key idea: θi = θr. The angle of incidence equals the angle of reflection.\n'
            'Real-world use: This law explains how mirrors form images.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            '2. Kaleidoscope: Multiple Reflections',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'What you do: Adjust the mirror angle and number of mirrors.\n'
            'What you see: Patterns multiply as angle decreases.\n'
            'Key idea: Each mirror creates multiple reflections, forming a kaleidoscope.\n'
            'Formula: Number of reflections = 360° / θ.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
