import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class7_mirror_calculator.dart';

enum _Class7Experiment { planeMirror, sphericalMirror, newtonDisc }

class _Class7CheckpointQuestion {
  const _Class7CheckpointQuestion({
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

class Class7LabScreen extends StatefulWidget {
  const Class7LabScreen({super.key});

  @override
  State<Class7LabScreen> createState() => _Class7LabScreenState();
}

class _Class7LabScreenState extends State<Class7LabScreen>
    with SingleTickerProviderStateMixin {
  static const _maxNewtonLevel = 3.0;
  static const String _checkpointPrompt =
      'Do the experiment and answer the checkpoint questions.';

  static const Map<_Class7Experiment, List<_Class7CheckpointQuestion>>
  _checkpointQuestionBank = {
    _Class7Experiment.planeMirror: <_Class7CheckpointQuestion>[
      _Class7CheckpointQuestion(
        prompt:
            'In a plane mirror, image distance compared to object distance is:',
        options: <String>['Equal', 'Half', 'Double', 'Always zero'],
        correctIndex: 0,
        explanation:
            'For a plane mirror, image distance equals object distance.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'A plane mirror image is usually:',
        options: <String>[
          'Virtual and erect',
          'Real and inverted',
          'Real and erect',
          'Virtual and inverted',
        ],
        correctIndex: 0,
        explanation: 'Plane mirror image is virtual and erect.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'Which effect is shown by the word AMBULANCE in mirrors?',
        options: <String>[
          'Lateral inversion',
          'Diffraction',
          'Dispersion',
          'Interference',
        ],
        correctIndex: 0,
        explanation: 'Left-right reversal is called lateral inversion.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'Size of image in plane mirror is:',
        options: <String>[
          'Same as object',
          'Always smaller',
          'Always larger',
          'Zero',
        ],
        correctIndex: 0,
        explanation: 'Plane mirror image size is same as object size.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'A plane mirror image can be taken on a screen?',
        options: <String>[
          'No, because it is virtual',
          'Yes, always',
          'Only at night',
          'Only if mirror is convex',
        ],
        correctIndex: 0,
        explanation: 'Virtual images cannot be obtained on a screen.',
      ),
    ],
    _Class7Experiment.sphericalMirror: <_Class7CheckpointQuestion>[
      _Class7CheckpointQuestion(
        prompt: 'For a concave mirror, object beyond F forms image that is:',
        options: <String>[
          'Real and inverted',
          'Virtual and erect',
          'Virtual and inverted',
          'Always at infinity',
        ],
        correctIndex: 0,
        explanation:
            'Beyond focus in concave mirror gives real inverted image.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'A convex mirror image is generally:',
        options: <String>[
          'Virtual, erect, and diminished',
          'Real and magnified',
          'Real and same size',
          'Inverted and magnified',
        ],
        correctIndex: 0,
        explanation:
            'Convex mirrors produce virtual, erect, diminished images.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'In spherical mirrors, C denotes:',
        options: <String>[
          'Centre of curvature',
          'Critical angle',
          'Color point',
          'Convergence line',
        ],
        correctIndex: 0,
        explanation: 'C is the centre of curvature.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'If object is placed at F of a concave mirror, image forms:',
        options: <String>[
          'At infinity',
          'At C',
          'Between F and C',
          'Behind mirror at finite distance',
        ],
        correctIndex: 0,
        explanation:
            'At F, reflected rays become parallel so image is at infinity.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'Mirror formula used in this experiment is:',
        options: <String>[
          '1/f = 1/v + 1/u',
          'v = u + f',
          'f = u + v',
          'm = u/v only',
        ],
        correctIndex: 0,
        explanation: 'The mirror relation is 1/f = 1/v + 1/u.',
      ),
    ],
    _Class7Experiment.newtonDisc: <_Class7CheckpointQuestion>[
      _Class7CheckpointQuestion(
        prompt: 'As Newton disc speed increases, colors appear to:',
        options: <String>[
          'Merge toward white',
          'Become black',
          'Separate more',
          'Turn only red',
        ],
        correctIndex: 0,
        explanation: 'Fast rotation blends colors and appears whitish.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'The disc has sectors of:',
        options: <String>[
          'VIBGYOR colors',
          'Only primary colors',
          'Only black and white',
          'Random grayscale',
        ],
        correctIndex: 0,
        explanation: 'Newton disc uses VIBGYOR sectors.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'At low speed, the color sectors are:',
        options: <String>[
          'Clearly visible',
          'Fully white',
          'Invisible',
          'All black',
        ],
        correctIndex: 0,
        explanation: 'Low speed keeps individual sectors visible.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'Newton disc demonstrates:',
        options: <String>[
          'Persistence of vision and color recombination',
          'Only reflection',
          'Only refraction',
          'Only shadow formation',
        ],
        correctIndex: 0,
        explanation:
            'Rapid color mixing with persistence of vision gives near-white appearance.',
      ),
      _Class7CheckpointQuestion(
        prompt: 'When speed is very high, white opacity in output should be:',
        options: <String>['Near 1', 'Near 0', 'Negative', 'Undefined'],
        correctIndex: 0,
        explanation: 'In this simulation, white blend opacity approaches 1.',
      ),
    ],
  };

  _Class7Experiment _active = _Class7Experiment.planeMirror;

  final _planeDistanceController = TextEditingController(text: '30');
  PlaneMirrorResult _planeResult = Class7MirrorCalculator.calculatePlaneMirror(
    30,
  );

  MirrorType _mirrorType = MirrorType.concave;
  final _mirrorObjectDistanceController = TextEditingController(text: '30');
  final _mirrorFocalLengthController = TextEditingController(text: '10');
  SphericalMirrorResult _mirrorResult =
      Class7MirrorCalculator.calculateSphericalMirror(
        type: MirrorType.concave,
        objectDistanceCm: 30,
        focalLengthCm: 10,
      );

  double _newtonSpeedLevel = 0;
  late final AnimationController _discController;
  final Map<_Class7Experiment, bool> _checkpointVisible =
      <_Class7Experiment, bool>{};
  final Map<_Class7Experiment, int> _checkpointIndex =
      <_Class7Experiment, int>{};
  final Map<_Class7Experiment, List<int?>> _checkpointAnswers =
      <_Class7Experiment, List<int?>>{};
  final Map<_Class7Experiment, List<bool>> _checkpointSubmitted =
      <_Class7Experiment, List<bool>>{};
  final Map<_Class7Experiment, String> _checkpointFeedback =
      <_Class7Experiment, String>{};
  final Map<_Class7Experiment, int> _checkpointScore =
      <_Class7Experiment, int>{};

  String? _inputError;

  @override
  void initState() {
    super.initState();
    _discController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _updateDiscSpeed();
    for (final experiment in _Class7Experiment.values) {
      _resetCheckpoint(experiment);
    }
  }

  @override
  void dispose() {
    _discController.dispose();
    _planeDistanceController.dispose();
    _mirrorObjectDistanceController.dispose();
    _mirrorFocalLengthController.dispose();
    super.dispose();
  }

  void _updateDiscSpeed() {
    final level = _newtonSpeedLevel.round().clamp(0, 3);
    final durations = <int>[1800, 900, 420, 180];
    final millis = durations[level];
    _discController.duration = Duration(milliseconds: millis);
    _discController
      ..reset()
      ..repeat();
  }

  void _calculatePlaneMirror() {
    final distance = double.tryParse(_planeDistanceController.text.trim());
    if (distance == null) {
      setState(
        () => _inputError = 'Enter a valid object distance for plane mirror.',
      );
      return;
    }

    final result = Class7MirrorCalculator.calculatePlaneMirror(distance);
    setState(() {
      _planeResult = result;
      _inputError = result.isValid ? null : result.message;
    });
  }

  void _calculateSphericalMirror() {
    final objectDistance = double.tryParse(
      _mirrorObjectDistanceController.text.trim(),
    );
    final focalLength = double.tryParse(
      _mirrorFocalLengthController.text.trim(),
    );
    if (objectDistance == null || focalLength == null) {
      setState(
        () => _inputError =
            'Enter valid object distance and focal length for spherical mirror.',
      );
      return;
    }

    final result = Class7MirrorCalculator.calculateSphericalMirror(
      type: _mirrorType,
      objectDistanceCm: objectDistance,
      focalLengthCm: focalLength,
    );
    setState(() {
      _mirrorResult = result;
      _inputError = result.isValid ? null : result.message;
    });
  }

  void _resetCheckpoint(_Class7Experiment experiment) {
    final total = _checkpointQuestionBank[experiment]?.length ?? 0;
    _checkpointVisible[experiment] = false;
    _checkpointIndex[experiment] = 0;
    _checkpointAnswers[experiment] = List<int?>.filled(total, null);
    _checkpointSubmitted[experiment] = List<bool>.filled(total, false);
    _checkpointFeedback[experiment] = '';
    _checkpointScore[experiment] = 0;
  }

  bool _isExperimentVerified(_Class7Experiment experiment) {
    final questions = _checkpointQuestionBank[experiment] ?? const [];
    final submitted = _checkpointSubmitted[experiment] ?? const [];
    final submittedAll =
        questions.isNotEmpty && submitted.every((value) => value);
    final score = _checkpointScore[experiment] ?? 0;
    return submittedAll && score >= 4;
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
    if (answers == null || index >= answers.length) return;
    setState(() {
      answers[index] = optionIndex;
      _checkpointFeedback[experiment] = '';
    });
  }

  void _submitCheckpointAnswer() {
    final experiment = _active;
    final questions = _checkpointQuestionBank[experiment] ?? const [];
    if (questions.isEmpty) return;

    final index = (_checkpointIndex[experiment] ?? 0)
        .clamp(0, questions.length - 1)
        .toInt();
    final answers = _checkpointAnswers[experiment];
    final submitted = _checkpointSubmitted[experiment];
    if (answers == null || submitted == null) return;

    final selected = answers[index];
    if (selected == null) {
      setState(() {
        _checkpointFeedback[experiment] =
            'Choose one option before submitting your answer.';
      });
      return;
    }

    if (submitted[index]) {
      setState(() {
        _checkpointFeedback[experiment] =
            'Answer already submitted. Click Next Question.';
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
    final questions = _checkpointQuestionBank[experiment] ?? const [];
    if (questions.isEmpty) return;

    final index = (_checkpointIndex[experiment] ?? 0)
        .clamp(0, questions.length - 1)
        .toInt();
    final submitted = _checkpointSubmitted[experiment] ?? const [];
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
    final activeQuestions = _checkpointQuestionBank[_active] ?? const [];
    final activeIndex = (_checkpointIndex[_active] ?? 0)
        .clamp(0, math.max(0, activeQuestions.length - 1))
        .toInt();
    final activeQuestion = activeQuestions.isNotEmpty
        ? activeQuestions[activeIndex]
        : const _Class7CheckpointQuestion(
            prompt: '',
            options: <String>[],
            correctIndex: 0,
            explanation: '',
          );
    final activeAnswers = _checkpointAnswers[_active] ?? const <int?>[];
    final activeSubmitted = _checkpointSubmitted[_active] ?? const <bool>[];
    final selectedCheckpointOption = activeIndex < activeAnswers.length
        ? activeAnswers[activeIndex]
        : null;
    final hasSubmittedCurrent = activeIndex < activeSubmitted.length
        ? activeSubmitted[activeIndex]
        : false;
    final checkpointScore = _checkpointScore[_active] ?? 0;
    final checkpointVerified = _isExperimentVerified(_active);

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
                    'Class 7 - Mirrors and Light',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Run the experiments, change inputs, and verify observations with formulas.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  SegmentedButton<_Class7Experiment>(
                    segments: const [
                      ButtonSegment<_Class7Experiment>(
                        value: _Class7Experiment.planeMirror,
                        label: Text('Plane Mirror'),
                      ),
                      ButtonSegment<_Class7Experiment>(
                        value: _Class7Experiment.sphericalMirror,
                        label: Text('Spherical Mirrors'),
                      ),
                      ButtonSegment<_Class7Experiment>(
                        value: _Class7Experiment.newtonDisc,
                        label: Text("Newton's Disc"),
                      ),
                    ],
                    selected: <_Class7Experiment>{_active},
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
                  if (_active == _Class7Experiment.planeMirror)
                    _PlaneMirrorExperiment(
                      distanceController: _planeDistanceController,
                      result: _planeResult,
                      onCalculate: _calculatePlaneMirror,
                      checkpointVisible: _checkpointVisible[_active] ?? false,
                      checkpointPrompt: _checkpointPrompt,
                      checkpointQuestion: activeQuestion,
                      checkpointQuestionIndex: activeIndex,
                      checkpointTotalQuestions: activeQuestions.length,
                      checkpointSelectedOption: selectedCheckpointOption,
                      checkpointHasSubmittedCurrent: hasSubmittedCurrent,
                      checkpointFeedback: _checkpointFeedback[_active] ?? '',
                      checkpointScore: checkpointScore,
                      checkpointVerified: checkpointVerified,
                      onStartCheckpoint: _startCheckpoint,
                      onCheckpointOptionSelected: _selectCheckpointOption,
                      onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                      onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                      onRestartCheckpoint: _restartCheckpoint,
                    ),
                  if (_active == _Class7Experiment.sphericalMirror)
                    _SphericalMirrorExperiment(
                      mirrorType: _mirrorType,
                      objectDistanceController: _mirrorObjectDistanceController,
                      focalLengthController: _mirrorFocalLengthController,
                      result: _mirrorResult,
                      onMirrorTypeChanged: (value) {
                        setState(() => _mirrorType = value);
                        _calculateSphericalMirror();
                      },
                      onCalculate: _calculateSphericalMirror,
                      checkpointVisible: _checkpointVisible[_active] ?? false,
                      checkpointPrompt: _checkpointPrompt,
                      checkpointQuestion: activeQuestion,
                      checkpointQuestionIndex: activeIndex,
                      checkpointTotalQuestions: activeQuestions.length,
                      checkpointSelectedOption: selectedCheckpointOption,
                      checkpointHasSubmittedCurrent: hasSubmittedCurrent,
                      checkpointFeedback: _checkpointFeedback[_active] ?? '',
                      checkpointScore: checkpointScore,
                      checkpointVerified: checkpointVerified,
                      onStartCheckpoint: _startCheckpoint,
                      onCheckpointOptionSelected: _selectCheckpointOption,
                      onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                      onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                      onRestartCheckpoint: _restartCheckpoint,
                    ),
                  if (_active == _Class7Experiment.newtonDisc)
                    _NewtonsDiscExperiment(
                      speedLevel: _newtonSpeedLevel,
                      controller: _discController,
                      maxLevel: _maxNewtonLevel,
                      onSpeedLevelChanged: (value) {
                        setState(() => _newtonSpeedLevel = value);
                        _updateDiscSpeed();
                      },
                      checkpointVisible: _checkpointVisible[_active] ?? false,
                      checkpointPrompt: _checkpointPrompt,
                      checkpointQuestion: activeQuestion,
                      checkpointQuestionIndex: activeIndex,
                      checkpointTotalQuestions: activeQuestions.length,
                      checkpointSelectedOption: selectedCheckpointOption,
                      checkpointHasSubmittedCurrent: hasSubmittedCurrent,
                      checkpointFeedback: _checkpointFeedback[_active] ?? '',
                      checkpointScore: checkpointScore,
                      checkpointVerified: checkpointVerified,
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

class _PlaneMirrorExperiment extends StatelessWidget {
  const _PlaneMirrorExperiment({
    required this.distanceController,
    required this.result,
    required this.onCalculate,
    required this.checkpointVisible,
    required this.checkpointPrompt,
    required this.checkpointQuestion,
    required this.checkpointQuestionIndex,
    required this.checkpointTotalQuestions,
    required this.checkpointSelectedOption,
    required this.checkpointHasSubmittedCurrent,
    required this.checkpointFeedback,
    required this.checkpointScore,
    required this.checkpointVerified,
    required this.onStartCheckpoint,
    required this.onCheckpointOptionSelected,
    required this.onSubmitCheckpointAnswer,
    required this.onNextCheckpointQuestion,
    required this.onRestartCheckpoint,
  });

  final TextEditingController distanceController;
  final PlaneMirrorResult result;
  final VoidCallback onCalculate;
  final bool checkpointVisible;
  final String checkpointPrompt;
  final _Class7CheckpointQuestion checkpointQuestion;
  final int checkpointQuestionIndex;
  final int checkpointTotalQuestions;
  final int? checkpointSelectedOption;
  final bool checkpointHasSubmittedCurrent;
  final String checkpointFeedback;
  final int checkpointScore;
  final bool checkpointVerified;
  final VoidCallback onStartCheckpoint;
  final ValueChanged<int> onCheckpointOptionSelected;
  final VoidCallback onSubmitCheckpointAnswer;
  final VoidCallback onNextCheckpointQuestion;
  final VoidCallback onRestartCheckpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1) Plane Mirror: Lateral Inversion',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Object distance from mirror (cm)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onCalculate,
              child: const Text('Calculate'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: _PlaneMirrorStage(distanceCm: result.objectDistanceCm),
        ),
        const SizedBox(height: 12),
        _ResultPanel(
          title: 'Output',
          body:
              'Object distance = ${result.objectDistanceCm.toStringAsFixed(1)} cm\nImage distance = ${result.imageDistanceCm.toStringAsFixed(1)} cm\nRule: d(object) = d(image)',
        ),
        const SizedBox(height: 20),
        _CheckpointCard(
          active: checkpointVisible,
          prompt: checkpointPrompt,
          question: checkpointQuestion,
          questionIndex: checkpointQuestionIndex,
          totalQuestions: checkpointTotalQuestions,
          selectedOption: checkpointSelectedOption,
          hasSubmittedCurrent: checkpointHasSubmittedCurrent,
          feedback: checkpointFeedback,
          score: checkpointScore,
          verified: checkpointVerified,
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

class _PlaneMirrorStage extends StatelessWidget {
  const _PlaneMirrorStage({required this.distanceCm});

  final double distanceCm;

  @override
  Widget build(BuildContext context) {
    final px = (distanceCm * 4).clamp(40, 220);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerX = constraints.maxWidth / 2;
          final objectX = centerX - px;
          final imageX = centerX + px;

          return Stack(
            children: [
              Positioned(
                left: centerX - 2,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: const Color(0xFF94A3B8)),
              ),
              Positioned(
                left: objectX - 35,
                top: constraints.maxHeight * 0.45,
                child: const Text(
                  'AMBULANCE',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              Positioned(
                left: imageX - 36,
                top: constraints.maxHeight * 0.45,
                child: Transform.scale(
                  scaleX: -1,
                  child: const Text(
                    'AMBULANCE',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: objectX,
                bottom: 24,
                child: const Icon(
                  Icons.person,
                  size: 42,
                  color: Color(0xFF1D4ED8),
                ),
              ),
              Positioned(
                left: imageX,
                bottom: 24,
                child: Transform.scale(
                  scaleX: -1,
                  child: const Icon(
                    Icons.person,
                    size: 42,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SphericalMirrorExperiment extends StatelessWidget {
  const _SphericalMirrorExperiment({
    required this.mirrorType,
    required this.objectDistanceController,
    required this.focalLengthController,
    required this.result,
    required this.onMirrorTypeChanged,
    required this.onCalculate,
    required this.checkpointVisible,
    required this.checkpointPrompt,
    required this.checkpointQuestion,
    required this.checkpointQuestionIndex,
    required this.checkpointTotalQuestions,
    required this.checkpointSelectedOption,
    required this.checkpointHasSubmittedCurrent,
    required this.checkpointFeedback,
    required this.checkpointScore,
    required this.checkpointVerified,
    required this.onStartCheckpoint,
    required this.onCheckpointOptionSelected,
    required this.onSubmitCheckpointAnswer,
    required this.onNextCheckpointQuestion,
    required this.onRestartCheckpoint,
  });

  final MirrorType mirrorType;
  final TextEditingController objectDistanceController;
  final TextEditingController focalLengthController;
  final SphericalMirrorResult result;
  final ValueChanged<MirrorType> onMirrorTypeChanged;
  final VoidCallback onCalculate;
  final bool checkpointVisible;
  final String checkpointPrompt;
  final _Class7CheckpointQuestion checkpointQuestion;
  final int checkpointQuestionIndex;
  final int checkpointTotalQuestions;
  final int? checkpointSelectedOption;
  final bool checkpointHasSubmittedCurrent;
  final String checkpointFeedback;
  final int checkpointScore;
  final bool checkpointVerified;
  final VoidCallback onStartCheckpoint;
  final ValueChanged<int> onCheckpointOptionSelected;
  final VoidCallback onSubmitCheckpointAnswer;
  final VoidCallback onNextCheckpointQuestion;
  final VoidCallback onRestartCheckpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final stageAspectRatio = isDesktop ? (16 / 8) : (11 / 10);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2) Spherical Mirrors: Concave vs Convex',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SegmentedButton<MirrorType>(
          segments: const [
            ButtonSegment<MirrorType>(
              value: MirrorType.concave,
              label: Text('Concave'),
            ),
            ButtonSegment<MirrorType>(
              value: MirrorType.convex,
              label: Text('Convex'),
            ),
          ],
          selected: <MirrorType>{mirrorType},
          onSelectionChanged: (value) => onMirrorTypeChanged(value.first),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: objectDistanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Object distance |u| (cm)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: focalLengthController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Focal length |f| (cm)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onCalculate,
              child: const Text('Calculate'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: stageAspectRatio,
          child: _MirrorStage(result: result),
        ),
        const SizedBox(height: 16),
        _ResultPanel(title: 'Output', body: _buildSphericalOutput(result)),
        const SizedBox(height: 20),
        _CheckpointCard(
          active: checkpointVisible,
          prompt: checkpointPrompt,
          question: checkpointQuestion,
          questionIndex: checkpointQuestionIndex,
          totalQuestions: checkpointTotalQuestions,
          selectedOption: checkpointSelectedOption,
          hasSubmittedCurrent: checkpointHasSubmittedCurrent,
          feedback: checkpointFeedback,
          score: checkpointScore,
          verified: checkpointVerified,
          onStart: onStartCheckpoint,
          onOptionSelected: onCheckpointOptionSelected,
          onSubmitAnswer: onSubmitCheckpointAnswer,
          onNextQuestion: onNextCheckpointQuestion,
          onRestart: onRestartCheckpoint,
        ),
      ],
    );
  }

  String _natureLabel(MirrorImageNature nature) {
    switch (nature) {
      case MirrorImageNature.real:
        return 'Real';
      case MirrorImageNature.virtual:
        return 'Virtual';
      case MirrorImageNature.atInfinity:
        return 'At infinity';
      case MirrorImageNature.invalid:
        return 'Invalid';
    }
  }

  String _orientationLabel(MirrorOrientation orientation) {
    switch (orientation) {
      case MirrorOrientation.inverted:
        return 'Inverted';
      case MirrorOrientation.erect:
        return 'Erect';
      case MirrorOrientation.none:
        return '-';
    }
  }

  String _sizeLabel(MirrorSize size) {
    switch (size) {
      case MirrorSize.magnified:
        return 'Magnified';
      case MirrorSize.diminished:
        return 'Diminished';
      case MirrorSize.sameSize:
        return 'Same size';
      case MirrorSize.undefined:
        return '-';
    }
  }

  String _buildSphericalOutput(SphericalMirrorResult result) {
    final vText = result.imageDistanceCm == null
        ? '∞'
        : '${result.imageDistanceCm!.toStringAsFixed(2)} cm';
    final mText = result.magnification == null
        ? '-'
        : result.magnification!.toStringAsFixed(2);
    final sideText = result.imageDistanceCm == null
        ? 'Image forms at infinity.'
        : result.imageDistanceCm! < 0
        ? 'Image is formed in front of the mirror (object side).'
        : 'Image is formed behind the mirror.';

    return 'Mirror Formula: 1/f = 1/v + 1/u\n'
        'Image distance v = $vText\n'
        'Magnification m = $mText\n'
        'Nature = ${_natureLabel(result.nature)}\n'
        'Orientation = ${_orientationLabel(result.orientation)}\n'
        'Size = ${_sizeLabel(result.size)}\n'
        '$sideText';
  }
}

class _MirrorStage extends StatelessWidget {
  const _MirrorStage({required this.result});

  final SphericalMirrorResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FBFF), Color(0xFFF0F7FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6E4F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: const Color(0xFFFFFFFF),
                  child: CustomPaint(
                    painter: _MirrorPainter(result: result),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _LegendPill(color: Color(0xFF059669), text: 'Object'),
                _LegendPill(color: Color(0xFFDC2626), text: 'Image'),
                _LegendPill(color: Color(0xFFF59E0B), text: 'Principal Rays'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MirrorPainter extends CustomPainter {
  _MirrorPainter({required this.result});

  final SphericalMirrorResult result;

  @override
  void paint(Canvas canvas, Size size) {
    final axisY = size.height * 0.62;
    final mirrorX = size.width * 0.72;
    const pxPerCm = 6.0;
    final objectHeightPx = (size.height * 0.22).clamp(56.0, 95.0);
    final leftBound = 8.0;

    final gridPaint = Paint()..color = const Color(0xFFEAF2FB);
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final signedFocal = result.type == MirrorType.concave
        ? -result.focalLengthCm
        : result.focalLengthCm;
    final focusX = (mirrorX + signedFocal * pxPerCm)
        .clamp(18.0, size.width - 18.0)
        .toDouble();
    final centerX = (mirrorX + 2 * signedFocal * pxPerCm)
        .clamp(18.0, size.width - 18.0)
        .toDouble();

    // Principal axis
    canvas.drawLine(
      Offset(0, axisY),
      Offset(size.width, axisY),
      Paint()
        ..color = const Color(0xFF64748B)
        ..strokeWidth = 2.2,
    );

    // Mirror profile
    final mirrorPath = Path();
    final mirrorTop = Offset(mirrorX, axisY - size.height * 0.35);
    final mirrorBottom = Offset(mirrorX, axisY + size.height * 0.24);
    if (result.type == MirrorType.concave) {
      mirrorPath
        ..moveTo(mirrorTop.dx, mirrorTop.dy)
        ..quadraticBezierTo(
          mirrorX + 42,
          axisY - 12,
          mirrorBottom.dx,
          mirrorBottom.dy,
        );
    } else {
      mirrorPath
        ..moveTo(mirrorTop.dx, mirrorTop.dy)
        ..quadraticBezierTo(
          mirrorX - 42,
          axisY - 12,
          mirrorBottom.dx,
          mirrorBottom.dy,
        );
    }
    canvas.drawPath(
      mirrorPath,
      Paint()
        ..color = const Color(0xFF2563EB)
        ..strokeWidth = 4.5
        ..style = PaintingStyle.stroke,
    );
    canvas.drawPath(
      mirrorPath,
      Paint()
        ..color = const Color(0x882563EB)
        ..strokeWidth = 9
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Object
    final objectX = (mirrorX - result.objectDistanceCm * pxPerCm)
        .clamp(30.0, mirrorX - 20)
        .toDouble();
    final objectBase = Offset(objectX, axisY);
    final objectTip = Offset(objectX, axisY - objectHeightPx);
    _arrow(canvas, objectBase, objectTip, const Color(0xFF059669));
    _plainLabel(
      canvas,
      size,
      'Object',
      Offset(objectTip.dx - 62, objectTip.dy - 24),
    );

    // C and F markers
    _axisMarker(canvas, Offset(centerX, axisY), const Color(0xFF0EA5A4));
    _axisMarker(canvas, Offset(focusX, axisY), const Color(0xFF7C3AED));
    _plainLabel(canvas, size, 'C', Offset(centerX - 7, axisY + 10));
    _plainLabel(canvas, size, 'F', Offset(focusX - 6, axisY + 10));

    Offset? imageTip;
    Offset? imageBase;
    if (result.imageDistanceCm != null && result.magnification != null) {
      final imageX = (mirrorX + result.imageDistanceCm! * pxPerCm)
          .clamp(20.0, size.width - 20)
          .toDouble();
      final imageHeight = -objectHeightPx * result.magnification!;
      imageBase = Offset(imageX, axisY);
      imageTip = Offset(imageX, axisY + imageHeight);
      _arrow(canvas, imageBase, imageTip, const Color(0xFFDC2626));
      final imageLabelDx = imageTip.dx >= mirrorX ? 8.0 : -44.0;
      final imageLabelDy = imageTip.dy < axisY ? -22.0 : 8.0;
      _plainLabel(
        canvas,
        size,
        'Image',
        Offset(imageTip.dx + imageLabelDx, imageTip.dy + imageLabelDy),
      );
    }

    // Principal rays
    final mirrorHit1 = Offset(mirrorX, objectTip.dy);
    final rayPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 2.2;
    canvas.drawLine(objectTip, mirrorHit1, rayPaint);

    final focusPoint = Offset(focusX, axisY);
    final mirrorHit2Raw = _pointOnRayToX(
      start: objectTip,
      through: focusPoint,
      targetX: mirrorX,
      fallbackY: axisY - objectHeightPx * 0.30,
    );
    final mirrorHit2 = Offset(
      mirrorX,
      mirrorHit2Raw.dy.clamp(mirrorTop.dy + 8, mirrorBottom.dy - 8).toDouble(),
    );
    canvas.drawLine(objectTip, mirrorHit2, rayPaint);

    if (imageTip != null) {
      final imageIsReal = imageTip.dx < mirrorX;

      if (imageIsReal) {
        canvas.drawLine(mirrorHit1, imageTip, rayPaint);
        canvas.drawLine(mirrorHit2, imageTip, rayPaint);
      } else {
        final r1 = _pointOnRayToX(
          start: mirrorHit1,
          through: imageTip,
          targetX: leftBound,
          fallbackY: mirrorHit1.dy,
        );
        final r2 = _pointOnRayToX(
          start: mirrorHit2,
          through: imageTip,
          targetX: leftBound,
          fallbackY: mirrorHit2.dy,
        );
        canvas.drawLine(mirrorHit1, r1, rayPaint);
        canvas.drawLine(mirrorHit2, r2, rayPaint);
        _dashedLine(canvas, mirrorHit1, imageTip, const Color(0xFFF59E0B));
        _dashedLine(canvas, mirrorHit2, imageTip, const Color(0xFFF59E0B));
      }
    } else {
      final out1 = Offset(leftBound, objectTip.dy);
      final out2 = Offset(6, mirrorHit2.dy - 8);
      canvas.drawLine(mirrorHit1, out1, rayPaint);
      canvas.drawLine(mirrorHit2, out2, rayPaint);
      _plainLabel(canvas, size, 'Image at ∞', Offset(mirrorX + 10, axisY - 46));
    }

    // Pole marker for cleaner geometry reading.
    _axisMarker(canvas, Offset(mirrorX, axisY), const Color(0xFF334155));
  }

  Offset _pointOnRayToX({
    required Offset start,
    required Offset through,
    required double targetX,
    required double fallbackY,
  }) {
    final dx = through.dx - start.dx;
    final dy = through.dy - start.dy;
    if (dx.abs() < 0.001) return Offset(targetX, fallbackY);
    final t = (targetX - start.dx) / dx;
    return Offset(targetX, start.dy + dy * t);
  }

  void _axisMarker(Canvas canvas, Offset point, Color color) {
    canvas.drawCircle(point, 4.5, Paint()..color = color);
  }

  void _plainLabel(Canvas canvas, Size size, String text, Offset origin) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final x = origin.dx.clamp(4.0, size.width - tp.width - 4.0).toDouble();
    final y = origin.dy.clamp(4.0, size.height - tp.height - 4.0).toDouble();
    tp.paint(canvas, Offset(x, y));
  }

  void _dashedLine(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 1.8;
    final total = (to - from).distance;
    if (total <= 0.1) return;
    final direction = (to - from) / total;
    const dash = 8.0;
    const gap = 5.0;
    var travelled = 0.0;
    while (travelled < total) {
      final start = from + direction * travelled;
      final end = from + direction * math.min(travelled + dash, total);
      canvas.drawLine(start, end, paint);
      travelled += dash + gap;
    }
  }

  void _arrow(Canvas canvas, Offset base, Offset tip, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;
    canvas.drawLine(base, tip, paint);
    final head = tip.dy > base.dy ? -10 : 10;
    canvas.drawLine(Offset(tip.dx - 7, tip.dy + head), tip, paint);
    canvas.drawLine(Offset(tip.dx + 7, tip.dy + head), tip, paint);
  }

  @override
  bool shouldRepaint(covariant _MirrorPainter oldDelegate) =>
      oldDelegate.result != result;
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFDCE7F4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewtonsDiscExperiment extends StatelessWidget {
  const _NewtonsDiscExperiment({
    required this.speedLevel,
    required this.controller,
    required this.maxLevel,
    required this.onSpeedLevelChanged,
    required this.checkpointVisible,
    required this.checkpointPrompt,
    required this.checkpointQuestion,
    required this.checkpointQuestionIndex,
    required this.checkpointTotalQuestions,
    required this.checkpointSelectedOption,
    required this.checkpointHasSubmittedCurrent,
    required this.checkpointFeedback,
    required this.checkpointScore,
    required this.checkpointVerified,
    required this.onStartCheckpoint,
    required this.onCheckpointOptionSelected,
    required this.onSubmitCheckpointAnswer,
    required this.onNextCheckpointQuestion,
    required this.onRestartCheckpoint,
  });

  final double speedLevel;
  final AnimationController controller;
  final double maxLevel;
  final ValueChanged<double> onSpeedLevelChanged;
  final bool checkpointVisible;
  final String checkpointPrompt;
  final _Class7CheckpointQuestion checkpointQuestion;
  final int checkpointQuestionIndex;
  final int checkpointTotalQuestions;
  final int? checkpointSelectedOption;
  final bool checkpointHasSubmittedCurrent;
  final String checkpointFeedback;
  final int checkpointScore;
  final bool checkpointVerified;
  final VoidCallback onStartCheckpoint;
  final ValueChanged<int> onCheckpointOptionSelected;
  final VoidCallback onSubmitCheckpointAnswer;
  final VoidCallback onNextCheckpointQuestion;
  final VoidCallback onRestartCheckpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final whiteOpacity = Class7MirrorCalculator.newtonDiscWhiteOpacity(
      speed: speedLevel,
      maxSpeed: maxLevel,
    );
    final speedLabel = _speedLabel(speedLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "3) Newton's Disc: Recombining Colors",
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text('Rotation speed: $speedLabel', style: theme.textTheme.bodyMedium),
        Slider(
          value: speedLevel,
          min: 0,
          max: maxLevel,
          divisions: 3,
          label: speedLabel,
          onChanged: onSpeedLevelChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Low'),
            Text('Medium'),
            Text('High'),
            Text('Very High'),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 340,
            height: 340,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: controller.value * 2 * math.pi,
                      child: CustomPaint(
                        size: const Size(320, 320),
                        painter: _NewtonDiscPainter(),
                      ),
                    ),
                    Opacity(
                      opacity: whiteOpacity,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        _ResultPanel(
          title: 'Output',
          body:
              'White blend opacity = ${whiteOpacity.toStringAsFixed(2)}\n'
              'As speed increases, colors merge visually toward white.',
        ),
        const SizedBox(height: 12),
        _CheckpointCard(
          active: checkpointVisible,
          prompt: checkpointPrompt,
          question: checkpointQuestion,
          questionIndex: checkpointQuestionIndex,
          totalQuestions: checkpointTotalQuestions,
          selectedOption: checkpointSelectedOption,
          hasSubmittedCurrent: checkpointHasSubmittedCurrent,
          feedback: checkpointFeedback,
          score: checkpointScore,
          verified: checkpointVerified,
          onStart: onStartCheckpoint,
          onOptionSelected: onCheckpointOptionSelected,
          onSubmitAnswer: onSubmitCheckpointAnswer,
          onNextQuestion: onNextCheckpointQuestion,
          onRestart: onRestartCheckpoint,
        ),
      ],
    );
  }

  String _speedLabel(double level) {
    switch (level.round().clamp(0, 3)) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Very High';
    }
  }
}

class _NewtonDiscPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final colors = <Color>[
      const Color(0xFFFF0000),
      const Color(0xFFFF7F00),
      const Color(0xFFFFFF00),
      const Color(0xFF00FF00),
      const Color(0xFF0000FF),
      const Color(0xFF4B0082),
      const Color(0xFF9400D3),
    ];

    final sweep = (2 * math.pi) / colors.length;
    for (var i = 0; i < colors.length; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep,
        sweep,
        true,
        Paint()..color = colors[i],
      );
    }

    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    required this.active,
    required this.prompt,
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    required this.selectedOption,
    required this.hasSubmittedCurrent,
    required this.feedback,
    required this.score,
    required this.verified,
    required this.onStart,
    required this.onOptionSelected,
    required this.onSubmitAnswer,
    required this.onNextQuestion,
    required this.onRestart,
  });

  final bool active;
  final String prompt;
  final _Class7CheckpointQuestion question;
  final int questionIndex;
  final int totalQuestions;
  final int? selectedOption;
  final bool hasSubmittedCurrent;
  final String feedback;
  final int score;
  final bool verified;
  final VoidCallback onStart;
  final ValueChanged<int> onOptionSelected;
  final VoidCallback onSubmitAnswer;
  final VoidCallback onNextQuestion;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastQuestion = questionIndex >= totalQuestions - 1;
    final completedAll = isLastQuestion && hasSubmittedCurrent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.quiz_outlined,
                color: Color(0xFF0F766E),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Experiment Checkpoint',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(prompt, style: theme.textTheme.bodyMedium),
          if (!active) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.rocket_launch_outlined, size: 18),
              label: const Text('Start Checkpoint'),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              'Question ${questionIndex + 1} of $totalQuestions',
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFF0F766E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.prompt,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < question.options.length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: selectedOption,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: hasSubmittedCurrent
                    ? null
                    : (value) {
                        if (value != null) onOptionSelected(value);
                      },
                title: Text(
                  question.options[i],
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: hasSubmittedCurrent ? null : onSubmitAnswer,
                  icon: const Icon(Icons.task_alt, size: 18),
                  label: const Text('Submit Answer'),
                ),
                if (!isLastQuestion)
                  FilledButton(
                    onPressed: hasSubmittedCurrent ? onNextQuestion : null,
                    child: const Text('Next Question'),
                  ),
              ],
            ),
          ],
          if (feedback.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              feedback,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: feedback.startsWith('Correct')
                    ? const Color(0xFF166534)
                    : const Color(0xFF334155),
              ),
            ),
          ],
          if (active) ...[
            const SizedBox(height: 10),
            Text(
              'Score: $score / $totalQuestions',
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
          if (completedAll) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: verified
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: verified
                      ? const Color(0xFF86EFAC)
                      : const Color(0xFFFED7AA),
                ),
              ),
              child: Text(
                verified
                    ? 'Experiment verified as done. Great work.'
                    : 'Checkpoint finished. Score 4/5 or above is needed to verify this experiment.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: verified
                      ? const Color(0xFF166534)
                      : const Color(0xFF9A3412),
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.replay, size: 18),
              label: const Text('Restart Checkpoint'),
            ),
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
          Text('Class 7 Student Guide', style: theme.textTheme.titleLarge),
          const SizedBox(height: 14),
          Text(
            '1. Plane Mirror: Lateral Inversion',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'What you do: Enter the object distance from the mirror and press Calculate.\n'
            'What you see: The image appears the same distance behind the mirror.\n'
            'Key idea: Plane mirror gives an upright virtual image of same size.\n'
            'Remember: Object distance = Image distance.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            '2. Spherical Mirrors: Concave vs Convex',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'What you do: Choose Concave or Convex, then enter object distance and focal length.\n'
            'What you see: The app shows image distance, magnification, and image type.\n'
            'Key idea: Concave can form real or virtual images. Convex always forms virtual, erect, and smaller image.\n'
            'Useful formula: 1/f = 1/v + 1/u.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            "3. Newton's Disc: Recombination of Colors",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'What you do: Move speed from Low to Very High.\n'
            'What you see: At low speed, VIBGYOR colors are clear. At very high speed, colors mix and look nearly white.\n'
            'Key idea: Fast spinning makes colors blend in our vision.\n'
            'Connect this to prism: Prism splits white light, Newton disc combines colors back toward white.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
