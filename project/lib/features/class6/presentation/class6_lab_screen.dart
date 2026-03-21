import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class6_experiment.dart';

class _Class6CheckpointQuestion {
  const _Class6CheckpointQuestion({
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

class Class6LabScreen extends StatefulWidget {
  const Class6LabScreen({super.key});

  @override
  State<Class6LabScreen> createState() => _Class6LabScreenState();
}

class _Class6LabScreenState extends State<Class6LabScreen> {
  static const String _refractionHalfFill = 'refraction_half_fill';
  static const String _refractionEmpty = 'refraction_empty';
  static const String _checkpointPrompt =
      'Do experiment and answer the question asked by AI.';

  static const _experiments = <Class6Experiment>[
    Class6Experiment(
      id: 'transparency',
      title: '1. Light & Materials',
      subtitle: 'Test transparent, translucent, and opaque objects.',
      observation: 'Transparent objects let most light pass through.',
      fact:
          'Transparent objects let most light pass, translucent let some, and opaque block it completely.',
      accent: Color(0xFF4A69BD),
    ),
    Class6Experiment(
      id: 'shadow',
      title: '2. Sun & Shadows',
      subtitle: 'Track how shadows stretch and shrink through the day.',
      observation: 'The shadow is shortest at noon when the sun is overhead.',
      fact: 'A shadow always forms on the side opposite the light source.',
      accent: Color(0xFFF1C40F),
    ),
    Class6Experiment(
      id: 'pinhole',
      title: '3. Pinhole Camera',
      subtitle: 'See a real upside-down image form inside a dark chamber.',
      observation: 'Light travels in straight lines, so the image flips.',
      fact: 'A pinhole camera works because light travels in straight lines.',
      accent: Color(0xFF7C3AED),
    ),
    Class6Experiment(
      id: 'refraction',
      title: '4. The Broken Pencil',
      subtitle: 'Discover why water seems to bend objects.',
      observation:
          'Light bends when it enters water, making the pencil appear broken.',
      fact:
          'Light changes speed in water, so the underwater part appears shifted.',
      accent: Color(0xFF0D9488),
    ),
  ];

  static const Map<String, List<_Class6CheckpointQuestion>> _questionBank = {
    'transparency': <_Class6CheckpointQuestion>[
      _Class6CheckpointQuestion(
        prompt: 'Which material allows most light to pass through?',
        options: <String>['Glass', 'Oiled paper', 'Wood', 'Cardboard'],
        correctIndex: 0,
        explanation: 'Glass is transparent, so most light passes through it.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'Oiled paper is best described as:',
        options: <String>['Transparent', 'Translucent', 'Opaque', 'Reflective'],
        correctIndex: 1,
        explanation: 'Translucent materials allow only some light to pass.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'An opaque object mainly does what to light?',
        options: <String>[
          'Blocks light',
          'Creates rainbow colors',
          'Magnifies light',
          'Converts light to sound',
        ],
        correctIndex: 0,
        explanation: 'Opaque materials block light and form dark shadows.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'A wooden block in front of a torch gives:',
        options: <String>[
          'A dark shadow',
          'No shadow',
          'A blurred bright image',
          'A colored halo',
        ],
        correctIndex: 0,
        explanation: 'Wood is opaque, so light cannot pass through it.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'Objects seen through transparent material usually appear:',
        options: <String>[
          'Clear',
          'Completely invisible',
          'Only black and white',
          'Larger than actual size',
        ],
        correctIndex: 0,
        explanation: 'Transparent materials allow clear visibility.',
      ),
    ],
    'shadow': <_Class6CheckpointQuestion>[
      _Class6CheckpointQuestion(
        prompt: 'When is the shadow shortest in a day?',
        options: <String>['Morning', 'Noon', 'Evening', 'Midnight'],
        correctIndex: 1,
        explanation: 'At noon, the Sun is highest, so shadow length is least.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'A shadow forms on which side of an object?',
        options: <String>[
          'Same side as light source',
          'Opposite side of light source',
          'Only on the left side',
          'Only below the object',
        ],
        correctIndex: 1,
        explanation: 'Shadow always forms opposite to incoming light.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'When the Sun is low (morning/evening), shadows are:',
        options: <String>['Short', 'Long', 'Circular', 'Absent'],
        correctIndex: 1,
        explanation: 'A low Sun angle produces longer shadows.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'A clear shadow is formed by:',
        options: <String>[
          'Opaque object',
          'Transparent object',
          'Translucent sheet only',
          'Any gas',
        ],
        correctIndex: 0,
        explanation: 'Opaque objects block most light and form clear shadows.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'Changing Sun position mainly changes shadow:',
        options: <String>[
          'Color',
          'Length and direction',
          'Temperature',
          'Mass',
        ],
        correctIndex: 1,
        explanation:
            'As the Sun angle changes, shadow length and direction change.',
      ),
    ],
    'pinhole': <_Class6CheckpointQuestion>[
      _Class6CheckpointQuestion(
        prompt: 'Image formed in a pinhole camera is usually:',
        options: <String>['Upright', 'Inverted', 'No image', 'Only red'],
        correctIndex: 1,
        explanation:
            'Rays cross at the pinhole and the image appears inverted.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'A pinhole camera works because light travels in:',
        options: <String>[
          'Curved paths',
          'Spirals',
          'Straight lines',
          'Random zig-zag',
        ],
        correctIndex: 2,
        explanation: 'Straight-line propagation forms a predictable image.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'The tiny opening in the camera is called:',
        options: <String>['Lens', 'Pinhole', 'Prism', 'Filter'],
        correctIndex: 1,
        explanation: 'The small opening is the pinhole.',
      ),
      _Class6CheckpointQuestion(
        prompt:
            'If the object is moved farther from the pinhole, image size becomes:',
        options: <String>['Larger', 'Smaller', 'Unchanged', 'Colorful only'],
        correctIndex: 1,
        explanation:
            'With fixed screen distance, image size decreases as object distance increases.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'For a clearer image, the pinhole should be:',
        options: <String>[
          'Very large',
          'Moderately small',
          'Covered fully',
          'Filled with water',
        ],
        correctIndex: 1,
        explanation:
            'A small opening improves sharpness while still allowing light.',
      ),
    ],
    'refraction': <_Class6CheckpointQuestion>[
      _Class6CheckpointQuestion(
        prompt: 'A pencil looks bent in water mainly because light:',
        options: <String>[
          'Gets absorbed',
          'Bends at boundary',
          'Stops moving',
          'Turns into heat',
        ],
        correctIndex: 1,
        explanation:
            'Light bends at the air-water boundary, changing apparent position.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'Bending of light while changing medium is called:',
        options: <String>[
          'Reflection',
          'Refraction',
          'Dispersion',
          'Diffusion',
        ],
        correctIndex: 1,
        explanation: 'This effect is called refraction.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'Compared to air, light in water usually travels:',
        options: <String>['Faster', 'Slower', 'At same speed', 'Backward'],
        correctIndex: 1,
        explanation: 'Light speed reduces in denser optical media like water.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'Underwater part of the pencil appears:',
        options: <String>[
          'Shifted from its real position',
          'Exactly unchanged',
          'Totally invisible',
          'Only bigger',
        ],
        correctIndex: 0,
        explanation:
            'Refraction shifts the apparent position of the submerged part.',
      ),
      _Class6CheckpointQuestion(
        prompt: 'When light enters water from air, it bends:',
        options: <String>[
          'Away from normal',
          'Toward normal',
          'Only upward',
          'Only left',
        ],
        correctIndex: 1,
        explanation: 'From rarer to denser medium, light bends toward normal.',
      ),
    ],
  };

  late Class6Experiment _activeExperiment = _experiments.first;
  String _selectedMaterial = 'glass';
  double _sunAngle = 45;
  Offset _mousePosition = const Offset(150, 220);
  final Map<String, bool> _checkpointVisible = <String, bool>{};
  final Map<String, int> _checkpointIndex = <String, int>{};
  final Map<String, List<int?>> _checkpointAnswers = <String, List<int?>>{};
  final Map<String, List<bool>> _checkpointSubmitted = <String, List<bool>>{};
  final Map<String, String> _checkpointFeedback = <String, String>{};
  final Map<String, int> _checkpointScore = <String, int>{};

  @override
  void initState() {
    super.initState();
    for (final experiment in _experiments) {
      _resetCheckpoint(experiment.id);
    }
  }

  void _setExperiment(Class6Experiment experiment) {
    if (!experiment.enabled) return;
    setState(() {
      _activeExperiment = experiment;
      if (experiment.id == 'transparency') {
        const transparencyModes = <String>{'glass', 'paper', 'wood'};
        if (!transparencyModes.contains(_selectedMaterial)) {
          _selectedMaterial = 'glass';
        }
      } else if (experiment.id == 'refraction') {
        const refractionModes = <String>{_refractionHalfFill, _refractionEmpty};
        if (!refractionModes.contains(_selectedMaterial)) {
          _selectedMaterial = _refractionHalfFill;
        }
      }
    });
  }

  void _setMaterial(String material) {
    setState(() {
      _selectedMaterial = material;
    });
  }

  void _resetCheckpoint(String experimentId) {
    final total = _questionBank[experimentId]?.length ?? 0;
    _checkpointVisible[experimentId] = false;
    _checkpointIndex[experimentId] = 0;
    _checkpointAnswers[experimentId] = List<int?>.filled(total, null);
    _checkpointSubmitted[experimentId] = List<bool>.filled(total, false);
    _checkpointFeedback[experimentId] = '';
    _checkpointScore[experimentId] = 0;
  }

  bool _isExperimentVerified(String experimentId) {
    final questions = _questionBank[experimentId] ?? const [];
    final submitted = _checkpointSubmitted[experimentId] ?? const [];
    final submittedAll =
        questions.isNotEmpty && submitted.every((value) => value);
    final score = _checkpointScore[experimentId] ?? 0;
    return submittedAll && score >= 4;
  }

  void _startCheckpoint() {
    final experimentId = _activeExperiment.id;
    setState(() {
      _checkpointVisible[experimentId] = true;
      _checkpointFeedback[experimentId] = '';
    });
  }

  void _selectCheckpointOption(int optionIndex) {
    final experimentId = _activeExperiment.id;
    final index = _checkpointIndex[experimentId] ?? 0;
    final answers = _checkpointAnswers[experimentId];
    if (answers == null || index >= answers.length) return;
    setState(() {
      answers[index] = optionIndex;
      _checkpointFeedback[experimentId] = '';
    });
  }

  void _submitCheckpointAnswer() {
    final experimentId = _activeExperiment.id;
    final questions = _questionBank[experimentId] ?? const [];
    if (questions.isEmpty) return;

    final index = (_checkpointIndex[experimentId] ?? 0)
        .clamp(0, questions.length - 1)
        .toInt();
    final answers = _checkpointAnswers[experimentId];
    final submitted = _checkpointSubmitted[experimentId];
    if (answers == null || submitted == null) return;

    final selected = answers[index];
    if (selected == null) {
      setState(() {
        _checkpointFeedback[experimentId] =
            'Choose one option before submitting your answer.';
      });
      return;
    }

    if (submitted[index]) {
      setState(() {
        _checkpointFeedback[experimentId] =
            'Answer already submitted. Click Next Question.';
      });
      return;
    }

    final question = questions[index];
    final isCorrect = selected == question.correctIndex;

    setState(() {
      submitted[index] = true;
      if (isCorrect) {
        _checkpointScore[experimentId] =
            (_checkpointScore[experimentId] ?? 0) + 1;
      }
      _checkpointFeedback[experimentId] = isCorrect
          ? 'Correct. ${question.explanation}'
          : 'Not correct. ${question.explanation}';
    });
  }

  void _goToNextCheckpointQuestion() {
    final experimentId = _activeExperiment.id;
    final questions = _questionBank[experimentId] ?? const [];
    if (questions.isEmpty) return;

    final index = (_checkpointIndex[experimentId] ?? 0)
        .clamp(0, questions.length - 1)
        .toInt();
    final submitted = _checkpointSubmitted[experimentId] ?? const [];
    if (!submitted[index]) {
      setState(() {
        _checkpointFeedback[experimentId] =
            'Submit this answer before moving to the next question.';
      });
      return;
    }

    if (index < questions.length - 1) {
      setState(() {
        _checkpointIndex[experimentId] = index + 1;
        _checkpointFeedback[experimentId] = '';
      });
    }
  }

  void _restartCheckpoint() {
    final experimentId = _activeExperiment.id;
    setState(() {
      _resetCheckpoint(experimentId);
      _checkpointVisible[experimentId] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeExperimentId = _activeExperiment.id;
    final activeQuestions = _questionBank[activeExperimentId] ?? const [];
    final activeIndex = (_checkpointIndex[activeExperimentId] ?? 0)
        .clamp(0, math.max(0, activeQuestions.length - 1))
        .toInt();
    final activeQuestion = activeQuestions.isNotEmpty
        ? activeQuestions[activeIndex]
        : const _Class6CheckpointQuestion(
            prompt: '',
            options: <String>[],
            correctIndex: 0,
            explanation: '',
          );
    final activeAnswers =
        _checkpointAnswers[activeExperimentId] ?? const <int?>[];
    final activeSubmitted =
        _checkpointSubmitted[activeExperimentId] ?? const <bool>[];
    final selectedOption = activeIndex < activeAnswers.length
        ? activeAnswers[activeIndex]
        : null;
    final hasSubmittedCurrent = activeIndex < activeSubmitted.length
        ? activeSubmitted[activeIndex]
        : false;
    final score = _checkpointScore[activeExperimentId] ?? 0;
    final isVerified = _isExperimentVerified(activeExperimentId);
    final verifiedExperimentIds = _experiments
        .where((experiment) => _isExperimentVerified(experiment.id))
        .map((experiment) => experiment.id)
        .toSet();

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 1040;
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFFF9F9F7), Color(0xFFF0E8D9)],
            ),
          ),
          child: compact
              ? _MobileLayout(
                  experiments: _experiments,
                  activeExperiment: _activeExperiment,
                  selectedMaterial: _selectedMaterial,
                  sunAngle: _sunAngle,
                  mousePosition: _mousePosition,
                  onExperimentSelected: _setExperiment,
                  onMaterialSelected: _setMaterial,
                  onSunAngleChanged: (value) {
                    setState(() => _sunAngle = value);
                  },
                  onMouseChanged: (value) {
                    setState(() => _mousePosition = value);
                  },
                  verifiedExperimentIds: verifiedExperimentIds,
                  checkpointVisible:
                      _checkpointVisible[activeExperimentId] ?? false,
                  checkpointPrompt: _checkpointPrompt,
                  checkpointQuestion: activeQuestion,
                  checkpointQuestionIndex: activeIndex,
                  checkpointTotalQuestions: activeQuestions.length,
                  checkpointSelectedOption: selectedOption,
                  checkpointHasSubmittedCurrent: hasSubmittedCurrent,
                  checkpointFeedback:
                      _checkpointFeedback[activeExperimentId] ?? '',
                  checkpointScore: score,
                  checkpointVerified: isVerified,
                  onStartCheckpoint: _startCheckpoint,
                  onCheckpointOptionSelected: _selectCheckpointOption,
                  onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                  onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                  onRestartCheckpoint: _restartCheckpoint,
                )
              : Row(
                  children: [
                    SizedBox(
                      width: 352,
                      child: _ControlRail(
                        experiments: _experiments,
                        activeExperiment: _activeExperiment,
                        selectedMaterial: _selectedMaterial,
                        sunAngle: _sunAngle,
                        onExperimentSelected: _setExperiment,
                        onMaterialSelected: _setMaterial,
                        onSunAngleChanged: (value) {
                          setState(() => _sunAngle = value);
                        },
                        verifiedExperimentIds: verifiedExperimentIds,
                        checkpointVisible:
                            _checkpointVisible[activeExperimentId] ?? false,
                        checkpointPrompt: _checkpointPrompt,
                        checkpointQuestion: activeQuestion,
                        checkpointQuestionIndex: activeIndex,
                        checkpointTotalQuestions: activeQuestions.length,
                        checkpointSelectedOption: selectedOption,
                        checkpointHasSubmittedCurrent: hasSubmittedCurrent,
                        checkpointFeedback:
                            _checkpointFeedback[activeExperimentId] ?? '',
                        checkpointScore: score,
                        checkpointVerified: isVerified,
                        onStartCheckpoint: _startCheckpoint,
                        onCheckpointOptionSelected: _selectCheckpointOption,
                        onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                        onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                        onRestartCheckpoint: _restartCheckpoint,
                      ),
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        selectedMaterial: _selectedMaterial,
                        sunAngle: _sunAngle,
                        mousePosition: _mousePosition,
                        onMouseChanged: (value) {
                          setState(() => _mousePosition = value);
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  MOBILE LAYOUT — student-friendly, scrollable, canvas-first
// ═══════════════════════════════════════════════════════════════════
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.experiments,
    required this.activeExperiment,
    required this.selectedMaterial,
    required this.sunAngle,
    required this.mousePosition,
    required this.onExperimentSelected,
    required this.onMaterialSelected,
    required this.onSunAngleChanged,
    required this.onMouseChanged,
    required this.verifiedExperimentIds,
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

  final List<Class6Experiment> experiments;
  final Class6Experiment activeExperiment;
  final String selectedMaterial;
  final double sunAngle;
  final Offset mousePosition;
  final ValueChanged<Class6Experiment> onExperimentSelected;
  final ValueChanged<String> onMaterialSelected;
  final ValueChanged<double> onSunAngleChanged;
  final ValueChanged<Offset> onMouseChanged;
  final Set<String> verifiedExperimentIds;
  final bool checkpointVisible;
  final String checkpointPrompt;
  final _Class6CheckpointQuestion checkpointQuestion;
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

  String _getObservation() {
    if (activeExperiment.id == 'transparency') {
      switch (selectedMaterial) {
        case 'glass':
          return 'Light passes through completely. Objects are clearly visible.';
        case 'paper':
          return 'Light passes partially. Objects look blurry and faint.';
        case 'wood':
          return 'Light is blocked completely. A dark shadow forms behind it.';
        default:
          return activeExperiment.observation;
      }
    } else if (activeExperiment.id == 'shadow') {
      if (sunAngle > 80 && sunAngle < 100)
        return 'Noon: The sun is overhead. Shadow is shortest!';
      if (sunAngle < 40 || sunAngle > 140)
        return 'Morning/Evening: Sun is low. Shadows are very long.';
      return 'Shadow always forms on the side opposite the light source.';
    } else if (activeExperiment.id == 'pinhole') {
      return 'Rays cross at the pinhole — image flips and changes size.';
    } else if (activeExperiment.id == 'refraction') {
      if (selectedMaterial == 'refraction_empty') {
        return 'The beaker is empty, so the pencil looks straight and in its original position.';
      }
      return 'With half-filled water, the submerged part looks bent at the surface due to refraction.';
    }
    return activeExperiment.observation;
  }

  String _getFunFact() => activeExperiment.fact;

  String _getStudentGuide() {
    switch (activeExperiment.id) {
      case 'transparency':
        return 'Tap a material above and watch the light beam change.\nGlass lets all light pass. Paper lets some. Wood blocks it completely.';
      case 'shadow':
        return 'Drag the slider to move the sun from morning to evening.\nWatch the shadow grow and shrink. At noon the shadow is shortest!';
      case 'pinhole':
        return 'Touch or drag on the canvas to move the candle up and down.\nThe image inside the camera flips because light travels in straight lines.';
      case 'refraction':
        return 'Choose a beaker state above.\nHalf-filled water: pencil appears bent at the surface. Empty container: pencil appears straight.';
      default:
        return activeExperiment.observation;
    }
  }

  // Canvas height — enough for each painter to render fully
  double _canvasHeight(String id, double width) {
    final scaled = width.clamp(280.0, 640.0).toDouble();
    switch (id) {
      case 'shadow':
        return math.max(420.0, scaled * 1.10);
      case 'pinhole':
        return math.max(390.0, scaled * 1.02);
      case 'refraction':
        return math.max(420.0, scaled * 1.14);
      default:
        return math.max(340.0, scaled * 0.95);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = activeExperiment.accent;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Experiment chip tabs ─────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: experiments
                  .map(
                    (exp) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _ExperimentChip(
                        experiment: exp,
                        active: activeExperiment.id == exp.id,
                        verified: verifiedExperimentIds.contains(exp.id),
                        onTap: () => onExperimentSelected(exp),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),

          // ── 2. Inline controls (ABOVE canvas) ──────────────────
          if (activeExperiment.id == 'transparency') ...[
            Text('Choose a material:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MaterialBtn(
                    label: 'Glass',
                    sublabel: 'Transparent',
                    selected: selectedMaterial == 'glass',
                    color: const Color(0xFF4A69BD),
                    onTap: () => onMaterialSelected('glass'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MaterialBtn(
                    label: 'Paper',
                    sublabel: 'Translucent',
                    selected: selectedMaterial == 'paper',
                    color: const Color(0xFFF1C40F),
                    onTap: () => onMaterialSelected('paper'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MaterialBtn(
                    label: 'Wood',
                    sublabel: 'Opaque',
                    selected: selectedMaterial == 'wood',
                    color: const Color(0xFF8B4513),
                    onTap: () => onMaterialSelected('wood'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          if (activeExperiment.id == 'shadow') ...[
            Row(
              children: [
                const Icon(Icons.wb_sunny, size: 18, color: Color(0xFFF1C40F)),
                const SizedBox(width: 8),
                Text('Move the Sun', style: theme.textTheme.titleSmall),
              ],
            ),
            Slider(
              min: 10,
              max: 170,
              value: sunAngle,
              activeColor: const Color(0xFFF1C40F),
              onChanged: onSunAngleChanged,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Morning', 'Noon', 'Evening']
                    .map((s) => Text(s, style: theme.textTheme.bodySmall))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (activeExperiment.id == 'refraction') ...[
            Text('Beaker State:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MaterialBtn(
                    label: 'Half-fill with water',
                    sublabel: 'Refraction',
                    selected: selectedMaterial != 'refraction_empty',
                    color: const Color(0xFF0EA5A4),
                    onTap: () => onMaterialSelected('refraction_half_fill'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MaterialBtn(
                    label: 'Empty container',
                    sublabel: 'No refraction',
                    selected: selectedMaterial == 'refraction_empty',
                    color: const Color(0xFF64748B),
                    onTap: () => onMaterialSelected('refraction_empty'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // ── 3. Canvas — HERO ────────────────────────────────────
          LayoutBuilder(
            builder: (context, canvasConstraints) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: _canvasHeight(
                    activeExperiment.id,
                    canvasConstraints.maxWidth,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accent.withValues(alpha: 0.18),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: GestureDetector(
                    onPanUpdate: activeExperiment.id == 'refraction'
                        ? null
                        : (d) => onMouseChanged(d.localPosition),
                    onTapDown: activeExperiment.id == 'refraction'
                        ? null
                        : (d) => onMouseChanged(d.localPosition),
                    child: CustomPaint(
                      painter: _Class6ExperimentPainter(
                        experimentId: activeExperiment.id,
                        selectedMaterial: selectedMaterial,
                        sunAngle: sunAngle,
                        mousePosition: mousePosition,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // ── 4. Student Guide ────────────────────────────────────
          _InfoCard(
            icon: Icons.menu_book_outlined,
            title: 'Student Guide',
            body: _getStudentGuide(),
            accent: const Color(0xFF334155),
            bgColor: Colors.white,
            borderColor: const Color(0xFFE8DECF),
          ),
          const SizedBox(height: 10),

          // ── 5. Live Observation ─────────────────────────────────
          _InfoCard(
            icon: Icons.visibility_outlined,
            title: 'Live Observation',
            body: _getObservation(),
            accent: accent,
            bgColor: accent.withValues(alpha: 0.06),
            borderColor: accent.withValues(alpha: 0.18),
          ),
          const SizedBox(height: 10),

          // ── 6. Fun Fact ─────────────────────────────────────────
          _InfoCard(
            icon: Icons.lightbulb_outline,
            title: 'Fun Fact',
            body: _getFunFact(),
            accent: const Color(0xFFD97706),
            bgColor: const Color(0xFFFFFBEB),
            borderColor: const Color(0xFFFDE68A),
          ),
          const SizedBox(height: 12),
          _CheckpointCard(
            accent: accent,
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
      ),
    );
  }
}

// ── Experiment chip ─────────────────────────────────────────────────
class _ExperimentChip extends StatelessWidget {
  const _ExperimentChip({
    required this.experiment,
    required this.active,
    required this.verified,
    required this.onTap,
  });
  final Class6Experiment experiment;
  final bool active;
  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? experiment.accent
              : experiment.accent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active
                ? experiment.accent
                : experiment.accent.withValues(alpha: 0.30),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (verified) ...[
              Icon(
                Icons.verified,
                size: 14,
                color: active ? Colors.white : const Color(0xFF15803D),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              experiment.title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: active ? Colors.white : experiment.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckpointCard extends StatelessWidget {
  const _CheckpointCard({
    required this.accent,
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

  final Color accent;
  final bool active;
  final String prompt;
  final _Class6CheckpointQuestion question;
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
              Icon(Icons.quiz_outlined, color: accent, size: 20),
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
              style: theme.textTheme.labelLarge?.copyWith(color: accent),
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
            if (!verified) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.replay, size: 18),
                label: const Text('Retry Checkpoint'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ── Material button ─────────────────────────────────────────────────
class _MaterialBtn extends StatelessWidget {
  const _MaterialBtn({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final String sublabel;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              sublabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: selected
                    ? Colors.white.withValues(alpha: 0.80)
                    : color.withValues(alpha: 0.70),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable info card ──────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
    required this.bgColor,
    required this.borderColor,
  });
  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final Color bgColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(color: accent),
                ),
                const SizedBox(height: 4),
                Text(body, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlRail extends StatelessWidget {
  const _ControlRail({
    required this.experiments,
    required this.activeExperiment,
    required this.selectedMaterial,
    required this.sunAngle,
    required this.onExperimentSelected,
    required this.onMaterialSelected,
    required this.onSunAngleChanged,
    required this.verifiedExperimentIds,
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

  final List<Class6Experiment> experiments;
  final Class6Experiment activeExperiment;
  final String selectedMaterial;
  final double sunAngle;
  final ValueChanged<Class6Experiment> onExperimentSelected;
  final ValueChanged<String> onMaterialSelected;
  final ValueChanged<double> onSunAngleChanged;
  final Set<String> verifiedExperimentIds;
  final bool checkpointVisible;
  final String checkpointPrompt;
  final _Class6CheckpointQuestion checkpointQuestion;
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

  String get _observation {
    if (activeExperiment.id == 'transparency') {
      switch (selectedMaterial) {
        case 'glass':
          return 'Light passes through completely. Objects are clearly visible.';
        case 'paper':
          return 'Light passes partially. Objects look blurry and faint.';
        case 'wood':
          return 'Light is blocked completely. A dark shadow is formed behind it.';
        default:
          return activeExperiment.observation;
      }
    } else if (activeExperiment.id == 'shadow') {
      if (sunAngle > 80 && sunAngle < 100) {
        return 'Noon: The sun is overhead. The shadow is at its shortest!';
      } else if (sunAngle < 40 || sunAngle > 140) {
        return 'Morning/Evening: The sun is low in the sky. Shadows become very long.';
      }
      return 'As the sun moves in a straight line, the shadow always stays on the opposite side.';
    } else if (activeExperiment.id == 'pinhole') {
      return 'Drag the candle up, down, closer, or farther. Straight-line rays cross at the pinhole, so the image flips and changes size.';
    } else if (activeExperiment.id == 'refraction') {
      if (selectedMaterial == 'refraction_empty') {
        return 'The beaker is empty, so the pencil appears straight and unchanged.';
      }
      return 'When water is present, light bends at the surface and the submerged part looks shifted.';
    }
    return activeExperiment.observation;
  }

  String get _studentGuide {
    switch (activeExperiment.id) {
      case 'transparency':
        return 'What to do: Choose glass, oiled paper, or wood.\n'
            'What to observe: Glass lets most light pass, paper lets some light pass, wood blocks light.\n'
            'Key idea: Materials are transparent, translucent, or opaque.';
      case 'shadow':
        return 'What to do: Move the sun angle from morning to evening.\n'
            'What to observe: Shadow is longest in morning/evening and shortest near noon.\n'
            'Key idea: Shadow forms opposite to light direction.';
      case 'pinhole':
        return 'What to do: Drag the candle around.\n'
            'What to observe: Image inside the pinhole camera is upside down and changes size.\n'
            'Key idea: Light travels in straight lines.';
      case 'refraction':
        return 'What to do: Choose "Half-fill with water" or "Empty container".\n'
            'What to observe: In water, the pencil appears bent at the boundary; in empty beaker, it stays straight.\n'
            'Key idea: Light bends when moving between air and water (refraction).';
      default:
        return activeExperiment.observation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFCF7),
        border: Border(right: BorderSide(color: Color(0xFFE8DECF))),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class 6 Physics', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Chapter 5: Shadows and Light. Discover how light travels and why objects create shadows.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text('Choose Experiment', style: theme.textTheme.titleLarge),
            const SizedBox(height: 14),
            for (final experiment in experiments) ...[
              _ExperimentTile(
                experiment: experiment,
                active: activeExperiment.id == experiment.id,
                verified: verifiedExperimentIds.contains(experiment.id),
                onTap: () => onExperimentSelected(experiment),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 24),
            if (activeExperiment.id == 'transparency') ...[
              Text('Materials Control', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              _MaterialButton(
                label: 'Clear Glass (Transparent)',
                selected: selectedMaterial == 'glass',
                onTap: () => onMaterialSelected('glass'),
                color: const Color(0xFF4A69BD),
              ),
              const SizedBox(height: 8),
              _MaterialButton(
                label: 'Oiled Paper (Translucent)',
                selected: selectedMaterial == 'paper',
                onTap: () => onMaterialSelected('paper'),
                color: const Color(0xFFF1C40F),
              ),
              const SizedBox(height: 8),
              _MaterialButton(
                label: 'Wooden Block (Opaque)',
                selected: selectedMaterial == 'wood',
                onTap: () => onMaterialSelected('wood'),
                color: const Color(0xFF8B4513),
              ),
            ],
            if (activeExperiment.id == 'shadow') ...[
              Text('Sun Position', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              Text(
                'Move the Sun from morning to evening',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Slider(
                min: 10,
                max: 170,
                value: sunAngle,
                onChanged: onSunAngleChanged,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Morning', style: theme.textTheme.bodySmall),
                  Text('Noon', style: theme.textTheme.bodySmall),
                  Text('Evening', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
            if (activeExperiment.id == 'refraction') ...[
              Text('Beaker State', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              _MaterialButton(
                label: 'Half-fill with water',
                selected: selectedMaterial != 'refraction_empty',
                onTap: () => onMaterialSelected('refraction_half_fill'),
                color: const Color(0xFF0EA5A4),
              ),
              const SizedBox(height: 8),
              _MaterialButton(
                label: 'Empty container',
                selected: selectedMaterial == 'refraction_empty',
                onTap: () => onMaterialSelected('refraction_empty'),
                color: const Color(0xFF64748B),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE8DECF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Guide',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_studentGuide, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _CheckpointCard(
              accent: activeExperiment.accent,
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
        ),
      ),
    );
  }
}

class _ExperimentTile extends StatelessWidget {
  const _ExperimentTile({
    required this.experiment,
    required this.active,
    required this.verified,
    required this.onTap,
  });

  final Class6Experiment experiment;
  final bool active;
  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: active
              ? experiment.accent.withValues(alpha: 0.12)
              : const Color(0xFFF8F5EE),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: active
                ? experiment.accent.withValues(alpha: 0.32)
                : const Color(0xFFE8DECF),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(experiment.title, style: theme.textTheme.titleMedium),
            if (verified) ...[
              const SizedBox(height: 4),
              Text(
                'Verified',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF15803D),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(experiment.subtitle, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _MaterialButton extends StatelessWidget {
  const _MaterialButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.15)
              : const Color(0xFFF8F5EE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: 0.4)
                : const Color(0xFFE8DECF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: selected ? color : null,
          ),
        ),
      ),
    );
  }
}

class _StageArea extends StatelessWidget {
  const _StageArea({
    required this.experiment,
    required this.selectedMaterial,
    required this.sunAngle,
    required this.mousePosition,
    required this.onMouseChanged,
  });

  final Class6Experiment experiment;
  final String selectedMaterial;
  final double sunAngle;
  final Offset mousePosition;
  final ValueChanged<Offset> onMouseChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MouseRegion(
            onHover: experiment.id == 'refraction'
                ? null
                : (event) {
                    final box = context.findRenderObject() as RenderBox?;
                    if (box == null || box.size.isEmpty) return;
                    final local = box.globalToLocal(event.position);
                    onMouseChanged(local);
                  },
            child: CustomPaint(
              painter: _Class6ExperimentPainter(
                experimentId: experiment.id,
                selectedMaterial: selectedMaterial,
                sunAngle: sunAngle,
                mousePosition: mousePosition,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        Positioned(
          top: 24,
          left: 24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: _OverlayCard(
              title: 'Quick Fact',
              accent: experiment.accent,
              body: experiment.fact,
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _OverlayCard(
              title: 'Live Observation',
              accent: experiment.accent,
              body: _getObservation(),
            ),
          ),
        ),
      ],
    );
  }

  String _getObservation() {
    if (experiment.id == 'transparency') {
      switch (selectedMaterial) {
        case 'glass':
          return 'Light passes through completely. Objects are clearly visible.';
        case 'paper':
          return 'Light passes partially. Objects look blurry and faint.';
        case 'wood':
          return 'Light is blocked completely. A dark shadow is formed behind it.';
        default:
          return experiment.observation;
      }
    } else if (experiment.id == 'shadow') {
      if (sunAngle > 80 && sunAngle < 100) {
        return 'Noon: The sun is overhead. The shadow is at its shortest!';
      } else if (sunAngle < 40 || sunAngle > 140) {
        return 'Morning/Evening: The sun is low in the sky. Shadows become very long.';
      }
      return 'As the sun moves in a straight line, the shadow always stays on the opposite side.';
    } else if (experiment.id == 'pinhole') {
      return 'Drag the candle up, down, closer, or farther. Straight-line rays cross at the pinhole, so the image flips and changes size on the screen.';
    } else if (experiment.id == 'refraction') {
      if (selectedMaterial == 'refraction_empty') {
        return 'The beaker is empty, so the pencil appears straight and unchanged.';
      }
      return 'With water in the beaker, the submerged part appears bent at the surface due to refraction.';
    }
    return experiment.observation;
  }
}

class _OverlayCard extends StatelessWidget {
  const _OverlayCard({
    required this.title,
    required this.accent,
    required this.body,
  });

  final String title;
  final Color accent;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DECF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(color: accent),
            ),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _Class6ExperimentPainter extends CustomPainter {
  _Class6ExperimentPainter({
    required this.experimentId,
    required this.selectedMaterial,
    required this.sunAngle,
    required this.mousePosition,
  });

  final String experimentId;
  final String selectedMaterial;
  final double sunAngle;
  final Offset mousePosition;

  @override
  void paint(Canvas canvas, Size size) {
    switch (experimentId) {
      case 'transparency':
        _drawTransparencyExperiment(canvas, size);
        break;
      case 'shadow':
        _drawShadowExperiment(canvas, size);
        break;
      case 'pinhole':
        _drawPinholeExperiment(canvas, size);
        break;
      case 'refraction':
        _drawRefractionExperiment(canvas, size);
        break;
    }
  }

  // ── Shared label helper — always clamps inside canvas ──────────
  void _label(
    Canvas canvas,
    Size size,
    String text,
    Offset pos, {
    Color color = const Color(0xFF64748B),
    double fontSize = 11,
    bool bold = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width * 0.45);
    final x = pos.dx.clamp(4.0, size.width - tp.width - 4).toDouble();
    final y = pos.dy.clamp(4.0, size.height - tp.height - 4).toDouble();
    // Small white bg for readability
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 3, y - 2, tp.width + 6, tp.height + 4),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.78),
    );
    tp.paint(canvas, Offset(x, y));
  }

  void _drawTransparencyExperiment(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF8FBFF), Color(0xFFF7F0E6)],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = background);

    final torchX = size.width * 0.14;
    final torchY = size.height * 0.5;
    final objectX = size.width * 0.42;

    canvas.drawRect(
      Rect.fromLTWH(torchX - 40.0, torchY - 15.0, 60.0, 30.0),
      Paint()..color = const Color(0xFF2D3436),
    );
    canvas.drawCircle(
      Offset(torchX + 20.0, torchY),
      15.0,
      Paint()..color = const Color(0xFF2D3436),
    );

    final lightColor = const Color(0xFFFFF8B8).withValues(alpha: 0.75);
    final lightPath = Path()
      ..moveTo(torchX + 20.0, torchY)
      ..lineTo(objectX, torchY - 60.0)
      ..lineTo(objectX, torchY + 60.0)
      ..close();
    canvas.drawPath(lightPath, Paint()..color = lightColor);

    double opacity = 0.1;
    double passThrough = 0.9;
    if (selectedMaterial == 'paper') {
      opacity = 0.5;
      passThrough = 0.3;
    } else if (selectedMaterial == 'wood') {
      opacity = 1.0;
      passThrough = 0.0;
    }

    final objectRect = Rect.fromLTWH(
      objectX - 20.0,
      torchY - 60.0,
      40.0,
      120.0,
    );
    canvas.drawRect(
      objectRect,
      Paint()..color = const Color(0xFF646464).withValues(alpha: opacity),
    );
    canvas.drawRect(
      objectRect,
      Paint()
        ..color = const Color(0xFF2D3436)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    if (passThrough > 0) {
      final passPath = Path()
        ..moveTo(objectX + 20.0, torchY - 60.0)
        ..lineTo(size.width, torchY - 100.0)
        ..lineTo(size.width, torchY + 100.0)
        ..lineTo(objectX + 20.0, torchY + 60.0)
        ..close();
      canvas.drawPath(
        passPath,
        Paint()
          ..color = const Color(
            0xFFFFFFC8,
          ).withValues(alpha: passThrough * 0.5),
      );
    }

    if (passThrough < 0.5) {
      final shadowPath = Path()
        ..moveTo(objectX + 20.0, torchY - 60.0)
        ..lineTo(size.width, torchY - 80.0)
        ..lineTo(size.width, torchY + 80.0)
        ..lineTo(objectX + 20.0, torchY + 60.0)
        ..close();
      canvas.drawPath(
        shadowPath,
        Paint()
          ..color = Colors.black.withValues(alpha: (1 - passThrough) * 0.15),
      );
    }

    _label(canvas, size, 'Light Source', Offset(torchX - 32.0, torchY + 25.0));
    _label(
      canvas,
      size,
      selectedMaterial == 'glass'
          ? 'Transparent'
          : selectedMaterial == 'paper'
          ? 'Translucent'
          : 'Opaque',
      Offset(objectX - 25.0, torchY + 75.0),
    );
  }

  void _drawShadowExperiment(Canvas canvas, Size size) {
    // ── proportional layout ───────────────────────────────────────
    final groundY = size.height * 0.62; // ground at 62% height
    final skyH = groundY;
    final pillarH = skyH * 0.38; // pillar = 38% of sky height
    final pillarW = size.width * 0.055;
    final centerX = size.width * 0.5;
    final pillarX = centerX - pillarW / 2;

    // ── sky ───────────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, groundY),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFCEE8FF), Color(0xFFFFF8DA), Color(0xFFF5F0DB)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, groundY)),
    );

    // ── ground ────────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
      Paint()
        ..shader =
            const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD8D2B8), Color(0xFFB6C98C), Color(0xFF89A663)],
            ).createShader(
              Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
            ),
    );

    // ── sun position ──────────────────────────────────────────────
    // Sun orbits on a semicircle ABOVE ground, radius = 42% of sky height
    // so at noon (90°) sun is at top-center, never below pillar top
    final rad = sunAngle * math.pi / 180.0;
    final orbitR = skyH * 0.72; // orbit radius in pixels
    final sunX = centerX + orbitR * math.cos(math.pi - rad);
    final sunY = groundY - orbitR * math.sin(math.pi - rad);
    // clamp so sun never dips below top of pillar
    final sunYClamped = sunY.clamp(8.0, groundY - pillarH - 12.0).toDouble();
    final sunR = size.width * 0.055; // sun radius scales too

    // ── shadow on ground ─────────────────────────────────────────
    // shadow length from tan of elevation angle
    final elevation = math.max(0.05, math.sin(rad));
    final shadowLen = (pillarH / math.tan(math.max(0.05, rad))).clamp(
      -size.width * 0.8,
      size.width * 0.8,
    );
    final shadowW = math
        .max(pillarW, shadowLen.abs() * 0.18)
        .clamp(pillarW, size.width * 0.35);
    final shadowCx = centerX + shadowLen * 0.5;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(shadowCx, groundY + 5),
        width: shadowW * 2,
        height: pillarW * 0.8,
      ),
      Paint()
        ..color = Color.fromRGBO(
          45,
          52,
          54,
          math.max(0.06, 0.28 - elevation * 0.18),
        ),
    );

    // ── pillar ────────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(pillarX - 3, groundY - pillarH, pillarW + 6, pillarH),
      Paint()..color = const Color(0xFF9A8A76),
    );
    canvas.drawRect(
      Rect.fromLTWH(pillarX, groundY - pillarH, pillarW, pillarH),
      Paint()..color = const Color(0xFF7F7364),
    );

    // ── sun glow + rays ───────────────────────────────────────────
    canvas.drawCircle(
      Offset(sunX, sunYClamped),
      sunR * 1.8,
      Paint()
        ..color = const Color(0xFFF1C40F).withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawCircle(
      Offset(sunX, sunYClamped),
      sunR,
      Paint()
        ..shader =
            RadialGradient(
              colors: const [
                Color(0xFFFFFFFF),
                Color(0xFFFFF4B3),
                Color(0xFFF1C40F),
                Color(0x00F1C40F),
              ],
            ).createShader(
              Rect.fromCircle(center: Offset(sunX, sunYClamped), radius: sunR),
            ),
    );
    for (int i = 0; i < 8; i++) {
      final a = (math.pi * 2.0 * i) / 8.0;
      canvas.drawLine(
        Offset(
          sunX + math.cos(a) * sunR * 0.85,
          sunYClamped + math.sin(a) * sunR * 0.85,
        ),
        Offset(
          sunX + math.cos(a) * sunR * 1.5,
          sunYClamped + math.sin(a) * sunR * 1.5,
        ),
        Paint()
          ..color = const Color(0xFFFFDC6B).withValues(alpha: 0.5)
          ..strokeWidth = 2,
      );
    }

    // ── label — always inside canvas ─────────────────────────────
    final lbl = sunAngle < 40
        ? 'Morning'
        : sunAngle > 140
        ? 'Evening'
        : 'Noon ☀️';
    _label(
      canvas,
      size,
      lbl,
      Offset(sunX - 20, sunYClamped + sunR + 6),
      color: const Color(0xFF7A6300),
      bold: true,
    );
  }

  void _drawPinholeExperiment(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFCFAF4),
    );

    // ── Camera box — right 40% ────────────────────────────────────
    final boxW = size.width * 0.40;
    final boxH = size.height * 0.60;
    final boxX = size.width * 0.56;
    final boxY = (size.height - boxH) * 0.50;
    final pinY = boxY + boxH * 0.50;
    final screenX = boxX + boxW * 0.88;

    canvas.drawRect(
      Rect.fromLTWH(boxX - 8, boxY - 8, boxW + 16, boxH + 16),
      Paint()..color = const Color(0xFFE6C898),
    );
    canvas.drawRect(
      Rect.fromLTWH(boxX, boxY, boxW, boxH),
      Paint()..color = const Color(0xFF231E17),
    );
    canvas.drawCircle(
      Offset(boxX, pinY),
      3,
      Paint()..color = const Color(0xFFFFE566),
    );

    // ── Candle zone: left portion ─────────────────────────────────
    final zoneLeft = size.width * 0.04;
    final zoneRight = boxX - size.width * 0.05;

    final candleX = mousePosition.dx.clamp(zoneLeft, zoneRight).toDouble();
    final candleBaseY = mousePosition.dy
        .clamp(size.height * 0.15, size.height * 0.92)
        .toDouble();

    final bodyH = size.height * 0.16;
    final bodyW = size.width * 0.04;
    final flameH = size.height * 0.07;

    // Key Y positions on real candle (small Y = higher on screen)
    final flameTipY = candleBaseY - bodyH - flameH; // topmost = smallest Y
    final flameBaseY = candleBaseY - bodyH; // top of body

    // ── Pinhole projection: point (candleX, srcY) → (screenX, dstY) ──
    // Through pinhole at (boxX, pinY):
    //   dstY = pinY + (pinY - srcY) * dImg / dObj
    // Inversion: if flameTip is ABOVE pinY (srcY < pinY), dstY > pinY (below)
    final dObj = (boxX - candleX).clamp(1.0, double.infinity);
    final dImg = (screenX - boxX).abs();
    double proj(double srcY) => pinY + (pinY - srcY) * dImg / dObj;

    final scrTip = proj(flameTipY); // flame tip   → projects below pinY
    final scrBase = proj(flameBaseY); // body top    → projects above scrTip
    final scrBot = proj(candleBaseY); // candle base → projects highest above

    // Outside rays: candle → pinhole (left of box)
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, boxX + 1, size.height));
    _drawGlowRay(
      canvas,
      Offset(candleX, flameTipY),
      Offset(boxX, pinY),
      Offset(boxX, pinY),
    );
    _drawGlowRay(
      canvas,
      Offset(candleX, candleBaseY),
      Offset(boxX, pinY),
      Offset(boxX, pinY),
    );
    canvas.restore();

    // Inside box: rays + projected inverted candle
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(boxX, boxY, boxW, boxH));
    _drawGlowRay(
      canvas,
      Offset(candleX, flameTipY),
      Offset(boxX, pinY),
      Offset(screenX, scrTip),
    );
    _drawGlowRay(
      canvas,
      Offset(candleX, candleBaseY),
      Offset(boxX, pinY),
      Offset(screenX, scrBot),
    );

    // Inverted image: flame tip projects LOW, candle base projects HIGH
    // scrBot < scrTip (base is higher = smaller Y value)
    // Draw body from scrBot to scrBase, then flame from scrBase to scrTip
    _drawProjectedCandleInverted(
      canvas,
      screenX,
      scrBot,
      scrBase,
      scrTip,
      bodyW * 0.7,
    );
    canvas.restore();

    // Real candle
    _drawCandle(canvas, candleX, candleBaseY, bodyH, bodyW, flameH);

    // Labels
    _label(
      canvas,
      size,
      'PINHOLE CAMERA',
      Offset(boxX + 6, boxY + 4),
      color: const Color(0xFF6B4B24),
      bold: true,
    );
    _label(
      canvas,
      size,
      'Drag candle ↕',
      Offset(zoneLeft, boxY + 4),
      color: const Color(0xFF64748B),
    );
  }

  void _drawGlowRay(Canvas canvas, Offset from, Offset via, Offset to) {
    canvas.drawLine(
      from,
      via,
      Paint()
        ..color = const Color(0xFFFFB054).withValues(alpha: 0.22)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      from,
      via,
      Paint()
        ..color = const Color(0xFFFFB054).withValues(alpha: 0.85)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      via,
      to,
      Paint()
        ..color = const Color(0xFF77C4FF).withValues(alpha: 0.22)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      via,
      to,
      Paint()
        ..color = const Color(0xFF77C4FF).withValues(alpha: 0.85)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawCandle(
    Canvas canvas,
    double cx,
    double baseY,
    double bodyH,
    double bodyW,
    double flameH,
  ) {
    final bodyX = cx - bodyW / 2;
    final bodyY = baseY - bodyH;

    final waxGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFF9BE7A6), Color(0xFF78E08F), Color(0xFF58B36A)],
    ).createShader(Rect.fromLTWH(bodyX, bodyY, bodyW, bodyH));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyX, bodyY, bodyW, bodyH),
        Radius.circular(bodyW * 0.3),
      ),
      Paint()..shader = waxGrad,
    );
    // Wick
    canvas.drawLine(
      Offset(cx, bodyY - bodyW * 0.2),
      Offset(cx, bodyY + bodyW * 0.4),
      Paint()
        ..color = const Color(0xFF5B4636)
        ..strokeWidth = 1.5,
    );
    // Glow
    canvas.drawCircle(
      Offset(cx, bodyY - flameH * 0.5),
      flameH * 0.9,
      Paint()
        ..color = const Color(0xFFF1C40F).withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    // Flame shape — pointed tip UP, wide base
    final flamePath = Path()
      ..moveTo(cx, bodyY - flameH) // tip (top)
      ..quadraticBezierTo(
        cx + flameH * 0.45,
        bodyY - flameH * 0.35,
        cx,
        bodyY,
      ) // base right
      ..quadraticBezierTo(
        cx - flameH * 0.45,
        bodyY - flameH * 0.35,
        cx,
        bodyY - flameH,
      ); // base left
    canvas.drawPath(flamePath, Paint()..color = const Color(0xFFFFF4B3));
    canvas.drawPath(
      flamePath,
      Paint()
        ..color = const Color(0xFFF1C40F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  // Draws the inverted candle image on the screen inside the box.
  // bodyTop = projected candle base (highest = smallest Y)
  // bodyBot = projected body top
  // flameTip = projected flame tip (lowest = largest Y)
  void _drawProjectedCandleInverted(
    Canvas canvas,
    double cx,
    double bodyTop,
    double bodyBot,
    double flameTip,
    double bodyW,
  ) {
    final bH = (bodyBot - bodyTop).abs().clamp(6.0, double.infinity);
    final bW = bodyW.clamp(4.0, 20.0);
    final bX = cx - bW / 2;
    final bY = math.min(bodyTop, bodyBot);

    // Body (green wax)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bX, bY, bW, bH),
        Radius.circular(bW * 0.3),
      ),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFA6EDB1), Color(0xFF4D9D61)],
        ).createShader(Rect.fromLTWH(bX, bY, bW, bH)),
    );

    // Flame (inverted — tip points DOWN)
    // flameTip > bodyBot  (further down the screen)
    final fH = (flameTip - bodyBot).abs().clamp(4.0, double.infinity);
    final fHalfW = (fH * 0.4).clamp(3.0, 12.0);
    final fBaseY = math.min(flameTip, bodyBot); // top of flame zone
    final fTipY = math.max(flameTip, bodyBot); // bottom = inverted tip

    // Glow
    canvas.drawCircle(
      Offset(cx, fTipY),
      fH * 0.55,
      Paint()
        ..color = const Color(0xFFF1C40F).withValues(alpha: 0.40)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // Flame shape — tip points DOWN
    final fp = Path()
      ..moveTo(cx, fTipY) // tip (down)
      ..quadraticBezierTo(cx + fHalfW, fBaseY + fH * 0.4, cx, fBaseY) // right
      ..quadraticBezierTo(cx - fHalfW, fBaseY + fH * 0.4, cx, fTipY); // left
    canvas.drawPath(fp, Paint()..color = const Color(0xFFFFF4B3));
    canvas.drawPath(
      fp,
      Paint()
        ..color = const Color(0xFFF1C40F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  void _drawRefractionExperiment(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF8FBFF),
    );

    // ── Table ─────────────────────────────────────────────────────
    final tableY = size.height * 0.84;
    canvas.drawRect(
      Rect.fromLTWH(0, tableY, size.width, size.height - tableY),
      Paint()..color = const Color(0xFFE4D8C4),
    );

    // ── Glass — centered beaker ────────────────────────────────────
    final isDesktopCanvas = size.width >= 900;
    final glassW = size.width * (isDesktopCanvas ? 0.22 : 0.30);
    final glassH = size.height * (isDesktopCanvas ? 0.42 : 0.52);
    final glassX = (size.width - glassW) / 2;
    final glassY = size.height * 0.14;
    final waterLv = glassY + glassH * 0.44;
    final hasWater = selectedMaterial != 'refraction_empty';

    // Glass outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(glassX, glassY, glassW, glassH),
        const Radius.circular(10),
      ),
      Paint()
        ..color = const Color(0xFFA0C3DC).withValues(alpha: 0.50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    final wH = glassY + glassH - waterLv - 4;
    if (hasWater) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(glassX + 4, waterLv, glassW - 8, wH),
          const Radius.circular(7),
        ),
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF48CEC8), Color(0xFF2DD4BF)],
          ).createShader(Rect.fromLTWH(glassX + 4, waterLv, glassW - 8, wH)),
      );
      canvas.drawLine(
        Offset(glassX + 6, waterLv),
        Offset(glassX + glassW - 6, waterLv),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.75)
          ..strokeWidth = 1.5,
      );
    }

    // ── Pencil: fixed placement; mode decides bent vs straight ────
    const angle = 0.78;
    final strokeW = math.max(
      6.0,
      size.width * (isDesktopCanvas ? 0.020 : 0.028),
    );
    final crossX = glassX + glassW * 0.46;
    final crossY = waterLv;
    final aboveLen = size.height * (isDesktopCanvas ? 0.34 : 0.42);
    final belowLen = size.height * (isDesktopCanvas ? 0.22 : 0.28);

    // Above-water tip
    final tipX = crossX - math.cos(angle) * aboveLen;
    final tipY = crossY - math.sin(angle) * aboveLen;

    final botX = crossX + math.cos(angle) * belowLen;
    final botY = crossY + math.sin(angle) * belowLen;
    final drawTipX = tipX.clamp(0.0, size.width).toDouble();
    final drawTipY = tipY.clamp(0.0, size.height).toDouble();
    final drawBotX = botX.clamp(glassX + 2.0, glassX + glassW - 2.0).toDouble();
    final drawBotY = botY.clamp(glassY + 2.0, glassY + glassH - 4.0).toDouble();

    if (isDesktopCanvas || hasWater) {
      canvas.drawLine(
        Offset(drawTipX, drawTipY),
        Offset(crossX, crossY),
        Paint()
          ..color = const Color(0xFFF4C542)
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
    } else {
      // Mobile empty mode: one straight pencil.
      canvas.drawLine(
        Offset(drawTipX, drawTipY),
        Offset(drawBotX, drawBotY),
        Paint()
          ..color = const Color(0xFFF4C542)
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
    }

    if (hasWater) {
      if (isDesktopCanvas) {
        const shift = 15.0;
        final xMin = glassX + 2.0;
        final xMax = glassX + glassW - 2.0;
        final yMin = waterLv + 2.0;
        final yMax = glassY + glassH - 4.0;
        final shiftedStartX = (crossX + shift).clamp(xMin, xMax).toDouble();
        final shiftedStartY = (crossY + 1.0).clamp(yMin, yMax).toDouble();
        final dirX = math.cos(angle);
        final dirY = math.sin(angle);
        final maxTByX = dirX > 0
            ? (xMax - shiftedStartX) / dirX
            : double.infinity;
        final maxTByY = dirY > 0
            ? (yMax - shiftedStartY) / dirY
            : double.infinity;
        final maxT = math.max(0.0, math.min(maxTByX, maxTByY));
        final underwaterLen = math.min(belowLen, maxT);
        final shiftedEndX = shiftedStartX + (dirX * underwaterLen);
        final shiftedEndY = shiftedStartY + (dirY * underwaterLen);

        canvas.save();
        canvas.clipRect(Rect.fromLTWH(glassX + 2, waterLv, glassW - 4, wH - 2));
        canvas.drawLine(
          Offset(shiftedStartX, shiftedStartY),
          Offset(shiftedEndX, shiftedEndY),
          Paint()
            ..color = const Color(0xFFF4C542).withValues(alpha: 0.88)
            ..strokeWidth = strokeW
            ..strokeCap = StrokeCap.round,
        );
        canvas.restore();
      } else {
        // Mobile half-filled mode: one broken pencil (no duplicate line).
        // Keep same top and bottom endpoints as empty mode, but shift the
        // underwater start to create the refraction break at surface.
        const shift = 12.0;
        final shiftedStartX = (crossX + shift)
            .clamp(glassX + 2.0, glassX + glassW - 2.0)
            .toDouble();
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(glassX + 2, waterLv, glassW - 4, wH - 2));
        canvas.drawLine(
          Offset(shiftedStartX, crossY + 1.0),
          Offset(drawBotX, drawBotY),
          Paint()
            ..color = const Color(0xFFF4C542)
            ..strokeWidth = strokeW
            ..strokeCap = StrokeCap.round,
        );
        canvas.restore();
      }
    } else {
      if (isDesktopCanvas) {
        canvas.drawLine(
          Offset(crossX, crossY),
          Offset(drawBotX, drawBotY),
          Paint()
            ..color = const Color(0xFFF4C542)
            ..strokeWidth = strokeW
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // ── Labels ────────────────────────────────────────────────────
    _label(
      canvas,
      size,
      hasWater ? 'water surface' : 'empty beaker',
      Offset(glassX + glassW + 6, waterLv - 2),
      color: hasWater ? const Color(0xFF0D9488) : const Color(0xFF64748B),
    );
    if (hasWater) {
      _label(
        canvas,
        size,
        'looks bent!',
        Offset(glassX + glassW + 6, waterLv + 14),
        color: const Color(0xFF475569),
      );
    } else {
      _label(
        canvas,
        size,
        'looks straight',
        Offset(4, glassY + 4),
        color: const Color(0xFF94A3B8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Class6ExperimentPainter oldDelegate) {
    return oldDelegate.experimentId != experimentId ||
        oldDelegate.selectedMaterial != selectedMaterial ||
        oldDelegate.sunAngle != sunAngle ||
        oldDelegate.mousePosition != mousePosition;
  }
}
