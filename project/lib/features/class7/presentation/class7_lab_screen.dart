import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../ai/data/ai_tutor_models.dart';
import '../../ai/data/ai_tutor_service.dart';
import '../domain/class7_mirror_calculator.dart';

enum _Class7Experiment { planeMirror, sphericalMirror, newtonDisc }

class Class7LabScreen extends StatefulWidget {
  const Class7LabScreen({super.key});

  @override
  State<Class7LabScreen> createState() => _Class7LabScreenState();
}

class _Class7LabScreenState extends State<Class7LabScreen>
    with SingleTickerProviderStateMixin {
  static const _maxNewtonLevel = 3.0;
  static const _defaultNewtonOptions = <String>[
    'At very high speed, colors blend and the disc appears nearly white.',
    'At high speed, each color becomes darker and separate.',
    'The disc shows only red color when speed increases.',
    'Color does not change with speed.',
  ];

  static const _defaultPlaneMirrorOptions = <String>[
    'The image distance equals the object distance from the mirror.',
    'The image is virtual, upright, and same size as the object.',
    'Lateral inversion means left and right appear reversed.',
    'All of the above are properties of a plane mirror image.',
  ];

  static const _defaultSphericalMirrorOptions = <String>[
    'Object placed between focal point (F) and optical centre (O) — image is virtual and magnified.',
    'Object placed beyond centre of curvature (C) — image is real, inverted, and diminished.',
    'Object placed at centre of curvature (C) — image is real, inverted, and same size.',
    'Object placed at focal point (F) — image forms at infinity and is highly magnified.',
  ];

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
  final AiTutorService _aiTutorService = AiTutorService();

  bool _planeAiLoading = false;
  String? _planeAiError;
  String? _planeAiQuestion;
  String? _planeAiFeedback;
  String? _planeAiNextStep;
  List<String> _planeAiOptions = _defaultPlaneMirrorOptions;
  int? _planeSelectedOption;
  bool? _planeAiIsCorrect;
  String _planeAiBotMood = 'neutral';
  String _planeAiAnswerReview = '';

  bool _sphereAiLoading = false;
  String? _sphereAiError;
  String? _sphereAiQuestion;
  String? _sphereAiFeedback;
  String? _sphereAiNextStep;
  List<String> _sphereAiOptions = _defaultSphericalMirrorOptions;
  int? _sphereSelectedOption;
  bool? _sphereAiIsCorrect;
  String _sphereAiBotMood = 'neutral';
  String _sphereAiAnswerReview = '';

  bool _aiLoading = false;
  String? _aiError;
  String? _aiQuestion;
  String? _aiFeedback;
  String? _aiNextStep;
  List<String> _aiOptions = _defaultNewtonOptions;
  int? _selectedOption;
  bool? _aiIsCorrect;
  String _aiBotMood = 'neutral';
  String _aiAnswerReview = '';

  String? _inputError;

  @override
  void initState() {
    super.initState();
    _discController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _updateDiscSpeed();
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

  double get _currentWhiteOpacity =>
      Class7MirrorCalculator.newtonDiscWhiteOpacity(
        speed: _newtonSpeedLevel,
        maxSpeed: _maxNewtonLevel,
      );

  Future<void> _askAiQuestion() async {
    setState(() {
      _aiLoading = true;
      _aiError = null;
    });

    try {
      final response = await _aiTutorService.getTutorResponse(
        const AiTutorRequest(
          classId: '7',
          experimentId: 'newton_disc',
          mode: 'ask_or_feedback',
          studentState: <String, dynamic>{},
        ),
      );

      if (!mounted) return;
      setState(() {
        _aiQuestion = response.question;
        _aiFeedback = response.feedback;
        _aiNextStep = response.nextStep;
        _aiOptions = response.options.isEmpty
            ? _defaultNewtonOptions
            : response.options;
        _selectedOption = null;
        _aiIsCorrect = response.isCorrect;
        _aiBotMood = response.botMood;
        _aiAnswerReview = response.answerReview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _aiError =
            'Could not connect to AI backend. Check if backend is running on port 8000.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _aiLoading = false;
      });
    }
  }

  Future<void> _checkAnswerWithAi() async {
    if (_selectedOption == null) {
      setState(() {
        _aiError = 'Choose one option first.';
      });
      return;
    }

    setState(() {
      _aiLoading = true;
      _aiError = null;
    });

    try {
      final response = await _aiTutorService.getTutorResponse(
        AiTutorRequest(
          classId: '7',
          experimentId: 'newton_disc',
          mode: 'check_answer',
          studentState: <String, dynamic>{
            'speedLevel': _speedLabel(_newtonSpeedLevel),
            'computed': <String, dynamic>{'whiteOpacity': _currentWhiteOpacity},
            'step': 'answer_submitted',
            'selectedOption': _selectedOption,
          },
        ),
      );

      if (!mounted) return;
      setState(() {
        _aiQuestion = response.question;
        _aiFeedback = response.feedback;
        _aiNextStep = response.nextStep;
        _aiOptions = response.options.isEmpty
            ? _defaultNewtonOptions
            : response.options;
        _aiIsCorrect = response.isCorrect;
        _aiBotMood = response.botMood;
        _aiAnswerReview = response.answerReview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _aiError =
            'Could not connect to AI backend. Check if backend is running on port 8000.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _aiLoading = false;
      });
    }
  }

  Future<void> _askPlaneMirrorAi() async {
    setState(() {
      _planeAiLoading = true;
      _planeAiError = null;
    });

    try {
      final response = await _aiTutorService.getTutorResponse(
        const AiTutorRequest(
          classId: '7',
          experimentId: 'plane_mirror',
          mode: 'ask_or_feedback',
          studentState: <String, dynamic>{},
        ),
      );

      if (!mounted) return;
      setState(() {
        _planeAiQuestion = response.question;
        _planeAiFeedback = response.feedback;
        _planeAiNextStep = response.nextStep;
        _planeAiOptions = response.options.isEmpty
            ? _defaultPlaneMirrorOptions
            : response.options;
        _planeSelectedOption = null;
        _planeAiIsCorrect = response.isCorrect;
        _planeAiBotMood = response.botMood;
        _planeAiAnswerReview = response.answerReview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _planeAiError =
            'Could not connect to AI backend. Check if backend is running on port 8000.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _planeAiLoading = false;
        });
      }
    }
  }

  Future<void> _checkPlaneMirrorAnswerWithAi() async {
    if (_planeSelectedOption == null) {
      setState(() {
        _planeAiError = 'Choose one option first.';
      });
      return;
    }

    setState(() {
      _planeAiLoading = true;
      _planeAiError = null;
    });

    try {
      final response = await _aiTutorService.getTutorResponse(
        AiTutorRequest(
          classId: '7',
          experimentId: 'plane_mirror',
          mode: 'check_answer',
          studentState: <String, dynamic>{
            'objectDistanceCm': _planeResult.objectDistanceCm,
            'imageDistanceCm': _planeResult.imageDistanceCm,
            'step': 'answer_submitted',
            'selectedOption': _planeSelectedOption,
          },
        ),
      );

      if (!mounted) return;
      setState(() {
        _planeAiQuestion = response.question;
        _planeAiFeedback = response.feedback;
        _planeAiNextStep = response.nextStep;
        _planeAiOptions = response.options.isEmpty
            ? _defaultPlaneMirrorOptions
            : response.options;
        _planeAiIsCorrect = response.isCorrect;
        _planeAiBotMood = response.botMood;
        _planeAiAnswerReview = response.answerReview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _planeAiError =
            'Could not connect to AI backend. Check if backend is running on port 8000.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _planeAiLoading = false;
        });
      }
    }
  }

  Future<void> _askSphericalMirrorAi() async {
    setState(() {
      _sphereAiLoading = true;
      _sphereAiError = null;
    });

    try {
      final response = await _aiTutorService.getTutorResponse(
        const AiTutorRequest(
          classId: '7',
          experimentId: 'spherical_mirror',
          mode: 'ask_or_feedback',
          studentState: <String, dynamic>{},
        ),
      );

      if (!mounted) return;
      setState(() {
        _sphereAiQuestion = response.question;
        _sphereAiFeedback = response.feedback;
        _sphereAiNextStep = response.nextStep;
        _sphereAiOptions = response.options.isEmpty
            ? _defaultSphericalMirrorOptions
            : response.options;
        _sphereSelectedOption = null;
        _sphereAiIsCorrect = response.isCorrect;
        _sphereAiBotMood = response.botMood;
        _sphereAiAnswerReview = response.answerReview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sphereAiError =
            'Could not connect to AI backend. Check if backend is running on port 8000.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _sphereAiLoading = false;
        });
      }
    }
  }

  Future<void> _checkSphericalMirrorAnswerWithAi() async {
    if (_sphereSelectedOption == null) {
      setState(() {
        _sphereAiError = 'Choose one option first.';
      });
      return;
    }

    setState(() {
      _sphereAiLoading = true;
      _sphereAiError = null;
    });

    try {
      final response = await _aiTutorService.getTutorResponse(
        AiTutorRequest(
          classId: '7',
          experimentId: 'spherical_mirror',
          mode: 'check_answer',
          studentState: <String, dynamic>{
            'mirrorType': _mirrorType.name,
            'objectDistanceCm': _mirrorResult.objectDistanceCm,
            'focalLengthCm': _mirrorResult.focalLengthCm,
            'imageDistanceCm': _mirrorResult.imageDistanceCm,
            'magnification': _mirrorResult.magnification,
            'imageNature': _mirrorResult.nature.name,
            'step': 'answer_submitted',
            'selectedOption': _sphereSelectedOption,
          },
        ),
      );

      if (!mounted) return;
      setState(() {
        _sphereAiQuestion = response.question;
        _sphereAiFeedback = response.feedback;
        _sphereAiNextStep = response.nextStep;
        _sphereAiOptions = response.options.isEmpty
            ? _defaultSphericalMirrorOptions
            : response.options;
        _sphereAiIsCorrect = response.isCorrect;
        _sphereAiBotMood = response.botMood;
        _sphereAiAnswerReview = response.answerReview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sphereAiError =
            'Could not connect to AI backend. Check if backend is running on port 8000.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _sphereAiLoading = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      aiLoading: _planeAiLoading,
                      aiError: _planeAiError,
                      aiQuestion: _planeAiQuestion,
                      aiFeedback: _planeAiFeedback,
                      aiNextStep: _planeAiNextStep,
                      aiOptions: _planeAiOptions,
                      selectedOption: _planeSelectedOption,
                      aiIsCorrect: _planeAiIsCorrect,
                      aiBotMood: _planeAiBotMood,
                      aiAnswerReview: _planeAiAnswerReview,
                      onAskAi: _askPlaneMirrorAi,
                      onSubmitAnswer: _checkPlaneMirrorAnswerWithAi,
                      onOptionSelected: (value) {
                        setState(() => _planeSelectedOption = value);
                      },
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
                      aiLoading: _sphereAiLoading,
                      aiError: _sphereAiError,
                      aiQuestion: _sphereAiQuestion,
                      aiFeedback: _sphereAiFeedback,
                      aiNextStep: _sphereAiNextStep,
                      aiOptions: _sphereAiOptions,
                      selectedOption: _sphereSelectedOption,
                      aiIsCorrect: _sphereAiIsCorrect,
                      aiBotMood: _sphereAiBotMood,
                      aiAnswerReview: _sphereAiAnswerReview,
                      onAskAi: _askSphericalMirrorAi,
                      onSubmitAnswer: _checkSphericalMirrorAnswerWithAi,
                      onOptionSelected: (value) {
                        setState(() => _sphereSelectedOption = value);
                      },
                    ),
                  if (_active == _Class7Experiment.newtonDisc)
                    _NewtonsDiscExperiment(
                      speedLevel: _newtonSpeedLevel,
                      controller: _discController,
                      maxLevel: _maxNewtonLevel,
                      aiLoading: _aiLoading,
                      aiError: _aiError,
                      aiQuestion: _aiQuestion,
                      aiFeedback: _aiFeedback,
                      aiNextStep: _aiNextStep,
                      aiOptions: _aiOptions,
                      selectedOption: _selectedOption,
                      aiIsCorrect: _aiIsCorrect,
                      aiBotMood: _aiBotMood,
                      aiAnswerReview: _aiAnswerReview,
                      onAskAi: _askAiQuestion,
                      onSubmitAnswer: _checkAnswerWithAi,
                      onOptionSelected: (value) {
                        setState(() => _selectedOption = value);
                      },
                      onSpeedLevelChanged: (value) {
                        setState(() => _newtonSpeedLevel = value);
                        _updateDiscSpeed();
                      },
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
    required this.aiLoading,
    required this.aiError,
    required this.aiQuestion,
    required this.aiFeedback,
    required this.aiNextStep,
    required this.aiOptions,
    required this.selectedOption,
    required this.aiIsCorrect,
    required this.aiBotMood,
    required this.aiAnswerReview,
    required this.onAskAi,
    required this.onSubmitAnswer,
    required this.onOptionSelected,
  });

  final TextEditingController distanceController;
  final PlaneMirrorResult result;
  final VoidCallback onCalculate;
  final bool aiLoading;
  final String? aiError;
  final String? aiQuestion;
  final String? aiFeedback;
  final String? aiNextStep;
  final List<String> aiOptions;
  final int? selectedOption;
  final bool? aiIsCorrect;
  final String aiBotMood;
  final String aiAnswerReview;
  final Future<void> Function() onAskAi;
  final Future<void> Function() onSubmitAnswer;
  final ValueChanged<int> onOptionSelected;

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
        _AiTutorCard(
          aiLoading: aiLoading,
          aiError: aiError,
          aiQuestion: aiQuestion,
          aiFeedback: aiFeedback,
          aiNextStep: aiNextStep,
          aiOptions: aiOptions,
          selectedOption: selectedOption,
          aiIsCorrect: aiIsCorrect,
          aiBotMood: aiBotMood,
          aiAnswerReview: aiAnswerReview,
          onAskAi: onAskAi,
          onSubmitAnswer: onSubmitAnswer,
          onOptionSelected: onOptionSelected,
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
    required this.aiLoading,
    required this.aiError,
    required this.aiQuestion,
    required this.aiFeedback,
    required this.aiNextStep,
    required this.aiOptions,
    required this.selectedOption,
    required this.aiIsCorrect,
    required this.aiBotMood,
    required this.aiAnswerReview,
    required this.onAskAi,
    required this.onSubmitAnswer,
    required this.onOptionSelected,
  });

  final MirrorType mirrorType;
  final TextEditingController objectDistanceController;
  final TextEditingController focalLengthController;
  final SphericalMirrorResult result;
  final ValueChanged<MirrorType> onMirrorTypeChanged;
  final VoidCallback onCalculate;
  final bool aiLoading;
  final String? aiError;
  final String? aiQuestion;
  final String? aiFeedback;
  final String? aiNextStep;
  final List<String> aiOptions;
  final int? selectedOption;
  final bool? aiIsCorrect;
  final String aiBotMood;
  final String aiAnswerReview;
  final Future<void> Function() onAskAi;
  final Future<void> Function() onSubmitAnswer;
  final ValueChanged<int> onOptionSelected;

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
        _AiTutorCard(
          aiLoading: aiLoading,
          aiError: aiError,
          aiQuestion: aiQuestion,
          aiFeedback: aiFeedback,
          aiNextStep: aiNextStep,
          aiOptions: aiOptions,
          selectedOption: selectedOption,
          aiIsCorrect: aiIsCorrect,
          aiBotMood: aiBotMood,
          aiAnswerReview: aiAnswerReview,
          onAskAi: onAskAi,
          onSubmitAnswer: onSubmitAnswer,
          onOptionSelected: onOptionSelected,
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
    required this.aiLoading,
    required this.aiError,
    required this.aiQuestion,
    required this.aiFeedback,
    required this.aiNextStep,
    required this.aiOptions,
    required this.selectedOption,
    required this.aiIsCorrect,
    required this.aiBotMood,
    required this.aiAnswerReview,
    required this.onAskAi,
    required this.onSubmitAnswer,
    required this.onOptionSelected,
    required this.onSpeedLevelChanged,
  });

  final double speedLevel;
  final AnimationController controller;
  final double maxLevel;
  final bool aiLoading;
  final String? aiError;
  final String? aiQuestion;
  final String? aiFeedback;
  final String? aiNextStep;
  final List<String> aiOptions;
  final int? selectedOption;
  final bool? aiIsCorrect;
  final String aiBotMood;
  final String aiAnswerReview;
  final Future<void> Function() onAskAi;
  final Future<void> Function() onSubmitAnswer;
  final ValueChanged<int> onOptionSelected;
  final ValueChanged<double> onSpeedLevelChanged;

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
        if (aiQuestion != null) ...[
          const SizedBox(height: 12),
          Text(aiQuestion!, style: theme.textTheme.titleMedium),
        ],
        if (aiOptions.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (var i = 0; i < aiOptions.length; i++)
            RadioListTile<int>(
              value: i,
              groupValue: selectedOption,
              onChanged: aiLoading
                  ? null
                  : (value) {
                      if (value != null) onOptionSelected(value);
                    },
              title: Text(aiOptions[i]),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton.icon(
              onPressed: aiLoading ? null : onAskAi,
              icon: const Icon(Icons.psychology_alt),
              label: const Text('Ask AI'),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: aiLoading ? null : onSubmitAnswer,
              icon: const Icon(Icons.edit_note),
              label: const Text('Submit Answer'),
            ),
            if (aiLoading) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        if (aiError != null) ...[
          const SizedBox(height: 10),
          Text(
            aiError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFB91C1C),
            ),
          ),
        ],
        if (aiQuestion != null || aiFeedback != null || aiNextStep != null) ...[
          const SizedBox(height: 12),
          _ResultPanel(
            title: 'AI Tutor',
            body:
                'Question: ${aiQuestion ?? '-'}\n'
                'Feedback: ${aiFeedback ?? '-'}\n'
                'Next Step: ${aiNextStep ?? '-'}\n'
                'Answer Review: ${aiAnswerReview.isEmpty ? '-' : aiAnswerReview}',
          ),
        ],
        if (aiIsCorrect != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Builder(
                builder: (context) {
                  final happy = aiBotMood == 'happy';
                  return CircleAvatar(
                    backgroundColor: happy
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    child: Icon(
                      happy ? Icons.smart_toy : Icons.smart_toy_outlined,
                      color: happy
                          ? const Color(0xFF15803D)
                          : const Color(0xFFB91C1C),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  aiIsCorrect == true
                      ? 'Yes your experiment is correct little scientist! ...\nYess! You got the correct answer!'
                      : 'You have done a try... the correct way is to increase speed and observe blending toward white.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
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

class _AiTutorCard extends StatelessWidget {
  const _AiTutorCard({
    required this.aiLoading,
    required this.aiError,
    required this.aiQuestion,
    required this.aiFeedback,
    required this.aiNextStep,
    required this.aiOptions,
    required this.selectedOption,
    required this.aiIsCorrect,
    required this.aiBotMood,
    required this.aiAnswerReview,
    required this.onAskAi,
    required this.onSubmitAnswer,
    required this.onOptionSelected,
  });

  final bool aiLoading;
  final String? aiError;
  final String? aiQuestion;
  final String? aiFeedback;
  final String? aiNextStep;
  final List<String> aiOptions;
  final int? selectedOption;
  final bool? aiIsCorrect;
  final String aiBotMood;
  final String aiAnswerReview;
  final Future<void> Function() onAskAi;
  final Future<void> Function() onSubmitAnswer;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology_alt,
                color: Color(0xFF0F766E),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text('AI Tutor', style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          if (aiQuestion != null) ...[
            Text(
              'Question: ${aiQuestion!}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (aiOptions.isNotEmpty) ...[
            ...List.generate(
              aiOptions.length,
              (i) => RadioListTile<int>(
                value: i,
                groupValue: selectedOption,
                onChanged: aiLoading
                    ? null
                    : (value) {
                        if (value != null) onOptionSelected(value);
                      },
                title: Text(aiOptions[i], style: theme.textTheme.bodyMedium),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              FilledButton.icon(
                onPressed: aiLoading ? null : onAskAi,
                icon: const Icon(Icons.lightbulb_outline, size: 18),
                label: const Text('Ask AI'),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: aiLoading ? null : onSubmitAnswer,
                icon: const Icon(Icons.edit_note, size: 18),
                label: const Text('Submit Answer'),
              ),
              if (aiLoading) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          if (aiError != null) ...[
            const SizedBox(height: 10),
            Text(
              aiError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFFB91C1C),
              ),
            ),
          ],
          if (aiQuestion != null ||
              aiFeedback != null ||
              aiNextStep != null) ...[
            const SizedBox(height: 12),
            _ResultPanel(
              title: 'AI Response',
              body:
                  'Question: ${aiQuestion ?? '-'}\n'
                  'Feedback: ${aiFeedback ?? '-'}\n'
                  'Next Step: ${aiNextStep ?? '-'}',
            ),
          ],
          if (aiIsCorrect != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Builder(
                  builder: (context) {
                    final happy = aiBotMood == 'happy';
                    return CircleAvatar(
                      backgroundColor: happy
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFEE2E2),
                      child: Icon(
                        happy ? Icons.smart_toy : Icons.smart_toy_outlined,
                        color: happy
                            ? const Color(0xFF15803D)
                            : const Color(0xFFB91C1C),
                        size: 20,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    aiIsCorrect == true
                        ? 'Yes your experiment is correct! You got the right answer!'
                        : 'Not quite right... ${aiAnswerReview.isNotEmpty ? aiAnswerReview : 'Try again and observe the mirror properties carefully.'}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
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
