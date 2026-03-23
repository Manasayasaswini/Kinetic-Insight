import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../ai/data/ai_tutor_models.dart';
import '../../ai/data/ai_tutor_service.dart';
import '../domain/class11_experiment.dart';
import '../domain/class11_optics_calculator.dart';

class _Class11CheckpointQuestion {
  const _Class11CheckpointQuestion({
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

class Class11LabScreen extends StatefulWidget {
  const Class11LabScreen({super.key});

  @override
  State<Class11LabScreen> createState() => _Class11LabScreenState();
}

class _Class11LabScreenState extends State<Class11LabScreen> {
  static const String _checkpointPrompt =
      'Do the experiment and answer the checkpoint questions.';
  static const _experiments = <Class11Experiment>[
    Class11Experiment(
      id: 'tir',
      title: 'Critical Angle & TIR',
      subtitle:
          'Input refractive index and incident angle, then verify critical-angle behavior.',
      observation:
          'Below critical angle: refraction. Above it: total internal reflection.',
      fact:
          'Optical fibers guide light using repeated total internal reflection.',
      accent: Color(0xFF0F766E),
    ),
    Class11Experiment(
      id: 'prism',
      title: 'Prism Formula',
      subtitle:
          'Use apex angle A and minimum deviation δ to calculate prism refractive index.',
      observation:
          'At minimum deviation, prism index is n = sin((A+δ)/2) / sin(A/2).',
      fact:
          'Dispersion and refractive index are tightly linked in prism optics.',
      accent: Color(0xFF7C3AED),
    ),
    Class11Experiment(
      id: 'lens',
      title: 'Lens Image Formation',
      subtitle:
          'Input object distance and focal length to compute image distance and magnification.',
      observation:
          'Lens equation predicts image position, orientation, and size.',
      fact: '1/f = 1/v - 1/u unifies all thin-lens image cases.',
      accent: Color(0xFFC97D10),
    ),
  ];
  static const Map<String, List<_Class11CheckpointQuestion>>
  _checkpointQuestionBank = {
    'tir': <_Class11CheckpointQuestion>[
      _Class11CheckpointQuestion(
        prompt: 'Total internal reflection is possible when light travels:',
        options: <String>[
          'From denser to rarer medium',
          'From rarer to denser medium only',
          'Only in vacuum',
          'Only through a lens',
        ],
        correctIndex: 0,
        explanation:
            'TIR requires light to go from optically denser to rarer medium.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'Critical angle ic is defined when angle of refraction is:',
        options: <String>['0°', '45°', '90°', '180°'],
        correctIndex: 2,
        explanation:
            'At critical angle, refracted ray grazes interface (r=90°).',
      ),
      _Class11CheckpointQuestion(
        prompt: 'For TIR, incident angle i must be:',
        options: <String>[
          'Less than ic',
          'Equal to ic only',
          'Greater than ic',
          'Always 0°',
        ],
        correctIndex: 2,
        explanation: 'TIR occurs only for i > ic.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'In this experiment, critical angle formula used is:',
        options: <String>[
          'ic = sin⁻¹(1/n1)',
          'ic = cos⁻¹(1/n1)',
          'ic = tan⁻¹(1/n1)',
          'ic = n1 × 90',
        ],
        correctIndex: 0,
        explanation: 'With rarer medium air (n2=1), ic = sin⁻¹(1/n1).',
      ),
      _Class11CheckpointQuestion(
        prompt: 'Optical fiber communication mainly uses:',
        options: <String>[
          'Total internal reflection',
          'Only diffraction',
          'Only dispersion',
          'Only absorption',
        ],
        correctIndex: 0,
        explanation:
            'Fibers guide light by repeated total internal reflection.',
      ),
    ],
    'prism': <_Class11CheckpointQuestion>[
      _Class11CheckpointQuestion(
        prompt: 'At minimum deviation, refractive index of prism is:',
        options: <String>[
          'n = sin((A+δ)/2) / sin(A/2)',
          'n = (A+δ)/A',
          'n = sin(A+δ) / sin(A)',
          'n = A/δ',
        ],
        correctIndex: 0,
        explanation: 'This is the standard minimum-deviation prism formula.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'A in prism formula denotes:',
        options: <String>[
          'Apex angle of prism',
          'Angle of incidence',
          'Critical angle',
          'Angle of reflection',
        ],
        correctIndex: 0,
        explanation: 'A is the prism apex angle.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'δ in this experiment represents:',
        options: <String>[
          'Minimum deviation angle',
          'Scattering angle',
          'Brewster angle',
          'Diffraction angle',
        ],
        correctIndex: 0,
        explanation: 'δ is the minimum deviation through prism.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'If computed refractive index n < 1 for glass, it is:',
        options: <String>[
          'Non-physical for this setup',
          'Always correct',
          'Proof of TIR',
          'A sign of zero deviation',
        ],
        correctIndex: 0,
        explanation:
            'For ordinary glass prism in air, n should be greater than 1.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'As deviation increases (A fixed), computed n generally:',
        options: <String>[
          'Increases',
          'Decreases to zero always',
          'Stays exactly constant',
          'Becomes negative',
        ],
        correctIndex: 0,
        explanation:
            'From the formula, larger δ tends to increase numerator and n.',
      ),
    ],
    'lens': <_Class11CheckpointQuestion>[
      _Class11CheckpointQuestion(
        prompt: 'Thin lens relation used here is:',
        options: <String>[
          '1/f = 1/v - 1/u',
          '1/f = 1/v + 1/u',
          'f = u + v',
          'm = f/u only',
        ],
        correctIndex: 0,
        explanation:
            'The calculator uses Cartesian sign convention: 1/f=1/v-1/u.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'Magnification for lens is:',
        options: <String>['m = v/u', 'm = u/v', 'm = f/v', 'm = v-f'],
        correctIndex: 0,
        explanation: 'By definition in this setup, magnification m = v/u.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'For convex lens with object beyond focus, image is usually:',
        options: <String>[
          'Real and inverted',
          'Virtual and upright',
          'Always at infinity',
          'Always same size',
        ],
        correctIndex: 0,
        explanation:
            'Convex lens generally forms real inverted image for u > f.',
      ),
      _Class11CheckpointQuestion(
        prompt: 'A concave lens usually forms image that is:',
        options: <String>[
          'Virtual, upright, diminished',
          'Real, inverted, magnified',
          'Real, upright',
          'At infinity only',
        ],
        correctIndex: 0,
        explanation:
            'Concave lens typically gives virtual, upright, diminished images.',
      ),
      _Class11CheckpointQuestion(
        prompt:
            'If denominator in lens calculation tends to zero, image forms:',
        options: <String>[
          'At infinity',
          'At lens center',
          'At object position',
          'At focal point always',
        ],
        correctIndex: 0,
        explanation: 'When denominator is near zero, v tends to infinity.',
      ),
    ],
  };

  late Class11Experiment _activeExperiment = _experiments.first;

  final _tirIndexController = TextEditingController(text: '1.52');
  final _tirIncidentController = TextEditingController(text: '42');
  final _prismAController = TextEditingController(text: '60');
  final _prismDeviationController = TextEditingController(text: '40');
  final _lensObjectDistanceController = TextEditingController(text: '60');
  final _lensFocalLengthController = TextEditingController(text: '20');

  LensType _lensType = LensType.convex;

  TirResult _tirResult = Class11OpticsCalculator.calculateTir(
    mediumIndex: 1.52,
    incidentAngleDeg: 42,
  );
  PrismResult _prismResult = Class11OpticsCalculator.calculatePrism(
    apexAngleDeg: 60,
    deviationAngleDeg: 40,
  );
  LensResult _lensResult = Class11OpticsCalculator.calculateLens(
    type: LensType.convex,
    objectDistanceCm: 60,
    focalLengthCm: 20,
  );
  final Map<String, bool> _checkpointVisible = <String, bool>{};
  final Map<String, int> _checkpointIndex = <String, int>{};
  final Map<String, List<int?>> _checkpointAnswers = <String, List<int?>>{};
  final Map<String, List<bool>> _checkpointSubmitted = <String, List<bool>>{};
  final Map<String, String> _checkpointFeedback = <String, String>{};
  final Map<String, int> _checkpointScore = <String, int>{};
  final AiTutorService _aiTutorService = AiTutorService();
  final Map<String, Map<String, McpExplanationResponse>>
  _explanationsByExperiment = <String, Map<String, McpExplanationResponse>>{};
  bool _isExplanationLoading = false;
  String _activeExplanationLanguage = 'en';
  String? _explanationError;
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  bool _isAudioPlaying = false;
  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  String? _activeAudioUrl;

  String? _inputError;

  @override
  void initState() {
    super.initState();
    for (final experiment in _experiments) {
      _resetCheckpoint(experiment.id);
    }
    _playerStateSub = _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isAudioPlaying = state.playing;
      });
    });
    _positionSub = _audioPlayer.positionStream.listen((position) {
      if (!mounted) return;
      setState(() {
        _audioPosition = position;
      });
    });
    _durationSub = _audioPlayer.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() {
        _audioDuration = duration ?? Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _audioPlayer.dispose();
    _tirIndexController.dispose();
    _tirIncidentController.dispose();
    _prismAController.dispose();
    _prismDeviationController.dispose();
    _lensObjectDistanceController.dispose();
    _lensFocalLengthController.dispose();
    super.dispose();
  }

  void _setExperiment(Class11Experiment experiment) {
    setState(() {
      _activeExperiment = experiment;
      _inputError = null;
      _explanationError = null;
    });
    unawaited(_stopExplanationAudio());
  }

  Future<void> _playExplanationAudio(String url) async {
    try {
      if (_activeAudioUrl != url) {
        await _audioPlayer.setUrl(url);
        _activeAudioUrl = url;
      }
      await _audioPlayer.play();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _explanationError = 'Audio playback failed: $error';
      });
    }
  }

  Future<void> _pauseExplanationAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _stopExplanationAudio() async {
    await _audioPlayer.stop();
    if (!mounted) return;
    setState(() {
      _audioPosition = Duration.zero;
      _audioDuration = Duration.zero;
      _isAudioPlaying = false;
      _activeAudioUrl = null;
    });
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _fetchExplanation(String language) async {
    setState(() {
      _isExplanationLoading = true;
      _activeExplanationLanguage = language;
      _explanationError = null;
    });
    try {
      final response = await _aiTutorService.getExperimentExplanation(
        classId: '11',
        experimentId: _activeExperiment.id,
        language: language,
      );
      if (!mounted) return;
      setState(() {
        final experimentBucket =
            _explanationsByExperiment[_activeExperiment.id] ??
            <String, McpExplanationResponse>{};
        experimentBucket[language] = response;
        _explanationsByExperiment[_activeExperiment.id] = experimentBucket;
        _isExplanationLoading = false;
      });
      if (response.audioUrl != null && response.status == 'ready') {
        await _playExplanationAudio(response.audioUrl!);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isExplanationLoading = false;
        _explanationError = error.toString();
      });
    }
  }

  List<_Class11CheckpointQuestion> _activeQuestions() {
    return _checkpointQuestionBank[_activeExperiment.id] ??
        const <_Class11CheckpointQuestion>[];
  }

  void _resetCheckpoint(String experimentId) {
    final total = _checkpointQuestionBank[experimentId]?.length ?? 0;
    _checkpointVisible[experimentId] = false;
    _checkpointIndex[experimentId] = 0;
    _checkpointAnswers[experimentId] = List<int?>.filled(total, null);
    _checkpointSubmitted[experimentId] = List<bool>.filled(total, false);
    _checkpointFeedback[experimentId] = '';
    _checkpointScore[experimentId] = 0;
  }

  bool _isExperimentVerified(String experimentId) {
    final questions = _checkpointQuestionBank[experimentId] ?? const [];
    final submitted = _checkpointSubmitted[experimentId] ?? const <bool>[];
    final allAnswered =
        questions.isNotEmpty &&
        submitted.length == questions.length &&
        submitted.every((value) => value);
    final score = _checkpointScore[experimentId] ?? 0;
    return allAnswered && score >= 4;
  }

  void _startCheckpoint() {
    final id = _activeExperiment.id;
    setState(() {
      _checkpointVisible[id] = true;
      _checkpointFeedback[id] = '';
    });
  }

  void _selectCheckpointOption(int optionIndex) {
    final id = _activeExperiment.id;
    final index = _checkpointIndex[id] ?? 0;
    final answers = _checkpointAnswers[id];
    final submitted = _checkpointSubmitted[id];
    if (answers == null || submitted == null || submitted[index]) {
      return;
    }
    setState(() {
      answers[index] = optionIndex;
      _checkpointFeedback[id] = '';
    });
  }

  void _submitCheckpointAnswer() {
    final id = _activeExperiment.id;
    final questions = _activeQuestions();
    if (questions.isEmpty) return;
    final index = (_checkpointIndex[id] ?? 0).clamp(0, questions.length - 1);
    final answers = _checkpointAnswers[id];
    final submitted = _checkpointSubmitted[id];
    if (answers == null || submitted == null) return;

    final selected = answers[index];
    if (selected == null) {
      setState(() {
        _checkpointFeedback[id] = 'Select an option before submitting.';
      });
      return;
    }
    if (submitted[index]) {
      setState(() {
        _checkpointFeedback[id] =
            'This question is already submitted. Use Next Question.';
      });
      return;
    }

    final question = questions[index];
    final isCorrect = selected == question.correctIndex;
    setState(() {
      submitted[index] = true;
      if (isCorrect) {
        _checkpointScore[id] = (_checkpointScore[id] ?? 0) + 1;
      }
      _checkpointFeedback[id] = isCorrect
          ? 'Correct. ${question.explanation}'
          : 'Not correct. ${question.explanation}';
    });
  }

  void _goToNextCheckpointQuestion() {
    final id = _activeExperiment.id;
    final questions = _activeQuestions();
    if (questions.isEmpty) return;
    final index = (_checkpointIndex[id] ?? 0).clamp(0, questions.length - 1);
    final submitted = _checkpointSubmitted[id] ?? const <bool>[];
    if (!submitted[index]) {
      setState(() {
        _checkpointFeedback[id] =
            'Submit this answer before moving to the next question.';
      });
      return;
    }
    if (index < questions.length - 1) {
      setState(() {
        _checkpointIndex[id] = index + 1;
        _checkpointFeedback[id] = '';
      });
    }
  }

  void _restartCheckpoint() {
    final id = _activeExperiment.id;
    setState(() {
      _resetCheckpoint(id);
      _checkpointVisible[id] = true;
    });
  }

  void _calculateTir() {
    final index = double.tryParse(_tirIndexController.text.trim());
    final incident = double.tryParse(_tirIncidentController.text.trim());
    if (index == null || incident == null) {
      setState(
        () => _inputError =
            'Enter valid numbers for refractive index and incident angle.',
      );
      return;
    }

    final result = Class11OpticsCalculator.calculateTir(
      mediumIndex: index,
      incidentAngleDeg: incident,
    );
    setState(() {
      _tirResult = result;
      _inputError = result.isValid ? null : result.message;
    });
  }

  void _resetTir() {
    _tirIndexController.text = '1.52';
    _tirIncidentController.text = '42';
    _calculateTir();
  }

  void _calculatePrism() {
    final a = double.tryParse(_prismAController.text.trim());
    final d = double.tryParse(_prismDeviationController.text.trim());
    if (a == null || d == null) {
      setState(() => _inputError = 'Enter valid numbers for A and δ.');
      return;
    }

    final result = Class11OpticsCalculator.calculatePrism(
      apexAngleDeg: a,
      deviationAngleDeg: d,
    );
    setState(() {
      _prismResult = result;
      _inputError = result.isValid ? null : result.message;
    });
  }

  void _resetPrism() {
    _prismAController.text = '60';
    _prismDeviationController.text = '40';
    _calculatePrism();
  }

  void _calculateLens() {
    final u = double.tryParse(_lensObjectDistanceController.text.trim());
    final f = double.tryParse(_lensFocalLengthController.text.trim());
    if (u == null || f == null) {
      setState(
        () => _inputError =
            'Enter valid numbers for object distance and focal length.',
      );
      return;
    }

    final result = Class11OpticsCalculator.calculateLens(
      type: _lensType,
      objectDistanceCm: u,
      focalLengthCm: f,
    );
    setState(() {
      _lensResult = result;
      _inputError = result.isValid ? null : result.message;
    });
  }

  void _resetLens() {
    _lensType = LensType.convex;
    _lensObjectDistanceController.text = '60';
    _lensFocalLengthController.text = '20';
    _calculateLens();
  }

  @override
  Widget build(BuildContext context) {
    final activeQuestions = _activeQuestions();
    final activeQuestionIndex = activeQuestions.isEmpty
        ? 0
        : (_checkpointIndex[_activeExperiment.id] ?? 0).clamp(
            0,
            activeQuestions.length - 1,
          );
    final activeAnswers =
        _checkpointAnswers[_activeExperiment.id] ?? const <int?>[];
    final activeSubmitted =
        _checkpointSubmitted[_activeExperiment.id] ?? const <bool>[];
    final activeQuestion = activeQuestions.isEmpty
        ? const _Class11CheckpointQuestion(
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 1040;
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFFF7F0E4), Color(0xFFE8EEF7)],
            ),
          ),
          child: compact
              ? _ControlRail(
                  experiments: _experiments,
                  activeExperiment: _activeExperiment,
                  inputError: _inputError,
                  tirIndexController: _tirIndexController,
                  tirIncidentController: _tirIncidentController,
                  prismAController: _prismAController,
                  prismDeviationController: _prismDeviationController,
                  lensObjectDistanceController: _lensObjectDistanceController,
                  lensFocalLengthController: _lensFocalLengthController,
                  lensType: _lensType,
                  tirResult: _tirResult,
                  prismResult: _prismResult,
                  lensResult: _lensResult,
                  onExperimentSelected: _setExperiment,
                  onLensTypeChanged: (value) =>
                      setState(() => _lensType = value),
                  onCalculateTir: _calculateTir,
                  onResetTir: _resetTir,
                  onCalculatePrism: _calculatePrism,
                  onResetPrism: _resetPrism,
                  onCalculateLens: _calculateLens,
                  onResetLens: _resetLens,
                  checkpointPrompt: _checkpointPrompt,
                  checkpointVisible:
                      _checkpointVisible[_activeExperiment.id] ?? false,
                  checkpointQuestion: activeQuestion,
                  checkpointQuestionIndex: activeQuestionIndex,
                  checkpointTotalQuestions: activeQuestions.length,
                  checkpointSelectedOption: selectedCheckpointOption,
                  checkpointSubmitted: activeCheckpointSubmitted,
                  checkpointFeedback:
                      _checkpointFeedback[_activeExperiment.id] ?? '',
                  checkpointScore: _checkpointScore[_activeExperiment.id] ?? 0,
                  experimentVerified: _isExperimentVerified(
                    _activeExperiment.id,
                  ),
                  onStartCheckpoint: _startCheckpoint,
                  onCheckpointOptionSelected: _selectCheckpointOption,
                  onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                  onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                  onRestartCheckpoint: _restartCheckpoint,
                  includePhysicsAndObservation: true,
                  explanationLoading: _isExplanationLoading,
                  explanationLanguage: _activeExplanationLanguage,
                  explanationError: _explanationError,
                  explanation:
                      _explanationsByExperiment[_activeExperiment
                          .id]?[_activeExplanationLanguage],
                  onFetchEnglishExplanation: () => _fetchExplanation('en'),
                  onFetchTeluguExplanation: () => _fetchExplanation('te'),
                  isAudioPlaying: _isAudioPlaying,
                  audioPositionText: _formatDuration(_audioPosition),
                  audioDurationText: _formatDuration(_audioDuration),
                  activeAudioUrl: _activeAudioUrl,
                  onPlayExplanationAudio: _playExplanationAudio,
                  onPauseExplanationAudio: _pauseExplanationAudio,
                  onStopExplanationAudio: _stopExplanationAudio,
                  canvasSection: SizedBox(
                    height: constraints.maxWidth < 480 ? 400 : 500,
                    child: _StageArea(
                      experiment: _activeExperiment,
                      tirResult: _tirResult,
                      prismResult: _prismResult,
                      lensResult: _lensResult,
                      showOverlays: false,
                      showHeading: false,
                    ),
                  ),
                )
              : Row(
                  children: [
                    SizedBox(
                      width: 380,
                      child: _ControlRail(
                        experiments: _experiments,
                        activeExperiment: _activeExperiment,
                        inputError: _inputError,
                        tirIndexController: _tirIndexController,
                        tirIncidentController: _tirIncidentController,
                        prismAController: _prismAController,
                        prismDeviationController: _prismDeviationController,
                        lensObjectDistanceController:
                            _lensObjectDistanceController,
                        lensFocalLengthController: _lensFocalLengthController,
                        lensType: _lensType,
                        tirResult: _tirResult,
                        prismResult: _prismResult,
                        lensResult: _lensResult,
                        onExperimentSelected: _setExperiment,
                        onLensTypeChanged: (value) =>
                            setState(() => _lensType = value),
                        onCalculateTir: _calculateTir,
                        onResetTir: _resetTir,
                        onCalculatePrism: _calculatePrism,
                        onResetPrism: _resetPrism,
                        onCalculateLens: _calculateLens,
                        onResetLens: _resetLens,
                        checkpointPrompt: _checkpointPrompt,
                        checkpointVisible:
                            _checkpointVisible[_activeExperiment.id] ?? false,
                        checkpointQuestion: activeQuestion,
                        checkpointQuestionIndex: activeQuestionIndex,
                        checkpointTotalQuestions: activeQuestions.length,
                        checkpointSelectedOption: selectedCheckpointOption,
                        checkpointSubmitted: activeCheckpointSubmitted,
                        checkpointFeedback:
                            _checkpointFeedback[_activeExperiment.id] ?? '',
                        checkpointScore:
                            _checkpointScore[_activeExperiment.id] ?? 0,
                        experimentVerified: _isExperimentVerified(
                          _activeExperiment.id,
                        ),
                        onStartCheckpoint: _startCheckpoint,
                        onCheckpointOptionSelected: _selectCheckpointOption,
                        onSubmitCheckpointAnswer: _submitCheckpointAnswer,
                        onNextCheckpointQuestion: _goToNextCheckpointQuestion,
                        onRestartCheckpoint: _restartCheckpoint,
                        includePhysicsAndObservation: false,
                        explanationLoading: _isExplanationLoading,
                        explanationLanguage: _activeExplanationLanguage,
                        explanationError: _explanationError,
                        explanation:
                            _explanationsByExperiment[_activeExperiment
                                .id]?[_activeExplanationLanguage],
                        onFetchEnglishExplanation: () =>
                            _fetchExplanation('en'),
                        onFetchTeluguExplanation: () => _fetchExplanation('te'),
                        isAudioPlaying: _isAudioPlaying,
                        audioPositionText: _formatDuration(_audioPosition),
                        audioDurationText: _formatDuration(_audioDuration),
                        activeAudioUrl: _activeAudioUrl,
                        onPlayExplanationAudio: _playExplanationAudio,
                        onPauseExplanationAudio: _pauseExplanationAudio,
                        onStopExplanationAudio: _stopExplanationAudio,
                      ),
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        tirResult: _tirResult,
                        prismResult: _prismResult,
                        lensResult: _lensResult,
                        showOverlays: true,
                        showHeading: true,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ControlRail extends StatelessWidget {
  const _ControlRail({
    required this.experiments,
    required this.activeExperiment,
    required this.inputError,
    required this.tirIndexController,
    required this.tirIncidentController,
    required this.prismAController,
    required this.prismDeviationController,
    required this.lensObjectDistanceController,
    required this.lensFocalLengthController,
    required this.lensType,
    required this.tirResult,
    required this.prismResult,
    required this.lensResult,
    required this.onExperimentSelected,
    required this.onLensTypeChanged,
    required this.onCalculateTir,
    required this.onResetTir,
    required this.onCalculatePrism,
    required this.onResetPrism,
    required this.onCalculateLens,
    required this.onResetLens,
    required this.checkpointPrompt,
    required this.checkpointVisible,
    required this.checkpointQuestion,
    required this.checkpointQuestionIndex,
    required this.checkpointTotalQuestions,
    required this.checkpointSelectedOption,
    required this.checkpointSubmitted,
    required this.checkpointFeedback,
    required this.checkpointScore,
    required this.experimentVerified,
    required this.onStartCheckpoint,
    required this.onCheckpointOptionSelected,
    required this.onSubmitCheckpointAnswer,
    required this.onNextCheckpointQuestion,
    required this.onRestartCheckpoint,
    required this.explanationLoading,
    required this.explanationLanguage,
    required this.explanationError,
    required this.explanation,
    required this.onFetchEnglishExplanation,
    required this.onFetchTeluguExplanation,
    required this.isAudioPlaying,
    required this.audioPositionText,
    required this.audioDurationText,
    required this.activeAudioUrl,
    required this.onPlayExplanationAudio,
    required this.onPauseExplanationAudio,
    required this.onStopExplanationAudio,
    this.includePhysicsAndObservation = false,
    this.canvasSection,
  });

  final List<Class11Experiment> experiments;
  final Class11Experiment activeExperiment;
  final String? inputError;
  final TextEditingController tirIndexController;
  final TextEditingController tirIncidentController;
  final TextEditingController prismAController;
  final TextEditingController prismDeviationController;
  final TextEditingController lensObjectDistanceController;
  final TextEditingController lensFocalLengthController;
  final LensType lensType;
  final TirResult tirResult;
  final PrismResult prismResult;
  final LensResult lensResult;
  final ValueChanged<Class11Experiment> onExperimentSelected;
  final ValueChanged<LensType> onLensTypeChanged;
  final VoidCallback onCalculateTir;
  final VoidCallback onResetTir;
  final VoidCallback onCalculatePrism;
  final VoidCallback onResetPrism;
  final VoidCallback onCalculateLens;
  final VoidCallback onResetLens;
  final String checkpointPrompt;
  final bool checkpointVisible;
  final _Class11CheckpointQuestion checkpointQuestion;
  final int checkpointQuestionIndex;
  final int checkpointTotalQuestions;
  final int? checkpointSelectedOption;
  final bool checkpointSubmitted;
  final String checkpointFeedback;
  final int checkpointScore;
  final bool experimentVerified;
  final VoidCallback onStartCheckpoint;
  final ValueChanged<int> onCheckpointOptionSelected;
  final VoidCallback onSubmitCheckpointAnswer;
  final VoidCallback onNextCheckpointQuestion;
  final VoidCallback onRestartCheckpoint;
  final bool explanationLoading;
  final String explanationLanguage;
  final String? explanationError;
  final McpExplanationResponse? explanation;
  final VoidCallback onFetchEnglishExplanation;
  final VoidCallback onFetchTeluguExplanation;
  final bool isAudioPlaying;
  final String audioPositionText;
  final String audioDurationText;
  final String? activeAudioUrl;
  final Future<void> Function(String url) onPlayExplanationAudio;
  final Future<void> Function() onPauseExplanationAudio;
  final Future<void> Function() onStopExplanationAudio;
  final bool includePhysicsAndObservation;
  final Widget? canvasSection;

  String get _studentGuide {
    switch (activeExperiment.id) {
      case 'tir':
        return 'What to do: Enter refractive index and incident angle, then press Calculate.\n'
            'What to observe: Below critical angle you get refraction, at critical angle r = 90°, above it you get total internal reflection.\n'
            'Key idea: TIR happens only when light goes from denser to rarer medium and i > ic.';
      case 'prism':
        return 'What to do: Enter apex angle A and minimum deviation δ.\n'
            'What to observe: The app computes prism refractive index n using the formula.\n'
            'Key idea: n = sin((A + δ)/2) / sin(A/2) at minimum deviation.';
      case 'lens':
        return 'What to do: Choose lens type, enter object distance and focal length, then calculate.\n'
            'What to observe: Image distance, magnification, orientation, and image type update instantly.\n'
            'Key idea: Thin lens formula predicts where and how the image forms.';
      default:
        return activeExperiment.observation;
    }
  }

  String _equationText() {
    if (activeExperiment.id == 'tir') {
      return 'n1 sin i = n2 sin r\nic = sin⁻¹(n2 / n1), n2 = 1 (air)';
    }
    if (activeExperiment.id == 'prism') {
      return 'At minimum deviation:\nn = sin((A + δ)/2) / sin(A/2)';
    }
    return 'Thin lens formula:\n1/f = 1/v - 1/u\nMagnification m = v/u';
  }

  String _observationText() {
    if (activeExperiment.id == 'tir') return tirResult.message;
    if (activeExperiment.id == 'prism') return prismResult.message;
    return lensResult.message;
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
            Text('Class 11 Optics Lab', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Enter measurements like a real lab record. Compute, observe, and verify physics.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text('Choose Experiment', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final exp in experiments)
                  _ExperimentHeadingChip(
                    title: exp.title,
                    active: activeExperiment.id == exp.id,
                    accent: exp.accent,
                    onTap: () => onExperimentSelected(exp),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (inputError != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Text(
                  inputError!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFB91C1C),
                  ),
                ),
              ),
            if (includePhysicsAndObservation) ...[
              const SizedBox(height: 20),
              Text('Physics (Formula)', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _PlainInfoCard(
                title: 'Physics',
                body: _equationText(),
                accent: activeExperiment.accent,
              ),
            ],
            const SizedBox(height: 20),
            Text('Inputs', style: theme.textTheme.titleMedium),
            if (activeExperiment.id == 'tir') ...[
              const SizedBox(height: 12),
              _NumberInput(
                controller: tirIndexController,
                label: 'Medium refractive index (n1)',
                hint: 'e.g. 1.52',
              ),
              const SizedBox(height: 12),
              _NumberInput(
                controller: tirIncidentController,
                label: 'Incident angle i (degrees)',
                hint: '0 to <90',
              ),
              const SizedBox(height: 12),
              _ActionRow(onCalculate: onCalculateTir, onReset: onResetTir),
              if (canvasSection != null) ...[
                const SizedBox(height: 16),
                Text('Canvas', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                canvasSection!,
              ],
              const SizedBox(height: 12),
              Text('Output', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _ResultCard(
                title: 'Output',
                body:
                    'Critical angle ic = ${_fmt(tirResult.criticalAngleDeg)}°\nRefraction angle r = ${tirResult.refractionAngleDeg == null ? '-' : '${_fmt(tirResult.refractionAngleDeg!)}°'}\nReflected angle = ${_fmt(tirResult.reflectedAngleDeg)}°\nState = ${_tirStateLabel(tirResult.state)}',
              ),
            ],
            if (activeExperiment.id == 'prism') ...[
              const SizedBox(height: 12),
              _NumberInput(
                controller: prismAController,
                label: 'Apex angle A (degrees)',
                hint: 'e.g. 60',
              ),
              const SizedBox(height: 12),
              _NumberInput(
                controller: prismDeviationController,
                label: 'Minimum deviation δ (degrees)',
                hint: 'e.g. 40',
              ),
              const SizedBox(height: 12),
              _ActionRow(onCalculate: onCalculatePrism, onReset: onResetPrism),
              if (canvasSection != null) ...[
                const SizedBox(height: 16),
                Text('Canvas', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                canvasSection!,
              ],
              const SizedBox(height: 12),
              Text('Output', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _ResultCard(
                title: 'Output',
                body:
                    'Formula: n = sin((A+δ)/2) / sin(A/2)\nComputed n = ${prismResult.refractiveIndex.isNaN ? '-' : _fmt(prismResult.refractiveIndex, decimals: 3)}',
              ),
            ],
            if (activeExperiment.id == 'lens') ...[
              const SizedBox(height: 12),
              Text('Lens type', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<LensType>(
                  segments: const [
                    ButtonSegment<LensType>(
                      value: LensType.convex,
                      label: Text('Convex'),
                    ),
                    ButtonSegment<LensType>(
                      value: LensType.concave,
                      label: Text('Concave'),
                    ),
                  ],
                  selected: <LensType>{lensType},
                  onSelectionChanged: (value) => onLensTypeChanged(value.first),
                ),
              ),
              const SizedBox(height: 12),
              _NumberInput(
                controller: lensObjectDistanceController,
                label: 'Object distance |u| (cm)',
                hint: 'e.g. 60',
              ),
              const SizedBox(height: 12),
              _NumberInput(
                controller: lensFocalLengthController,
                label: 'Focal length |f| (cm)',
                hint: 'e.g. 20',
              ),
              const SizedBox(height: 12),
              _ActionRow(onCalculate: onCalculateLens, onReset: onResetLens),
              if (canvasSection != null) ...[
                const SizedBox(height: 16),
                Text('Canvas', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                canvasSection!,
              ],
              const SizedBox(height: 12),
              Text('Output', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _ResultCard(
                title: 'Output',
                body:
                    'Image distance v = ${lensResult.imageDistanceCm == null ? '∞' : '${_fmt(lensResult.imageDistanceCm!)} cm'}\nMagnification m = ${lensResult.magnification == null ? '-' : _fmt(lensResult.magnification!, decimals: 2)}\nNature = ${_lensNatureLabel(lensResult.imageNature)}\nOrientation = ${_lensOrientationLabel(lensResult.orientation)}\nSize = ${_lensSizeLabel(lensResult.size)}',
              ),
            ],
            if (includePhysicsAndObservation) ...[
              const SizedBox(height: 16),
              Text('Observation', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _PlainInfoCard(
                title: 'Observation',
                body: _observationText(),
                accent: activeExperiment.accent,
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
              isVerified: experimentVerified,
              visible: checkpointVisible,
              onStart: onStartCheckpoint,
              onOptionSelected: onCheckpointOptionSelected,
              onSubmitAnswer: onSubmitCheckpointAnswer,
              onNextQuestion: onNextCheckpointQuestion,
              onRestart: onRestartCheckpoint,
            ),
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
                  const SizedBox(height: 14),
                  Text(
                    'AI Audio Explanation',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: activeExperiment.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: explanationLoading
                            ? null
                            : onFetchEnglishExplanation,
                        icon: const Icon(Icons.volume_up_outlined, size: 18),
                        label: const Text('Listen in English'),
                      ),
                      OutlinedButton.icon(
                        onPressed: explanationLoading
                            ? null
                            : onFetchTeluguExplanation,
                        icon: const Icon(Icons.record_voice_over, size: 18),
                        label: const Text('తెలుగులో వినండి'),
                      ),
                    ],
                  ),
                  if (explanationLoading) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Fetching AI explanation...',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                  if (explanationError != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      explanationError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                  if (explanation != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Language: ${explanationLanguage == 'te' ? 'Telugu' : 'English'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Audio status: ${explanation!.status}${explanation!.audioUrl == null ? '' : ' (URL available)'}',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (explanation!.audioError != null) ...[
                      const SizedBox(height: 4),
                      SelectableText(
                        'Audio error: ${explanation!.audioError}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFB91C1C),
                        ),
                      ),
                    ],
                    if (explanation!.audioUrl != null) ...[
                      const SizedBox(height: 4),
                      SelectableText(
                        'Audio URL: ${explanation!.audioUrl}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF1D4ED8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                onPlayExplanationAudio(explanation!.audioUrl!),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play'),
                          ),
                          OutlinedButton.icon(
                            onPressed: isAudioPlaying
                                ? onPauseExplanationAudio
                                : null,
                            icon: const Icon(Icons.pause),
                            label: const Text('Pause'),
                          ),
                          OutlinedButton.icon(
                            onPressed: activeAudioUrl != null
                                ? onStopExplanationAudio
                                : null,
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Playback: $audioPositionText / $audioDurationText',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Transcript',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF334155),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      explanation!.script,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(double value, {int decimals = 1}) {
    if (value.isNaN || value.isInfinite) return '-';
    return value.toStringAsFixed(decimals);
  }

  static String _tirStateLabel(TirState state) {
    switch (state) {
      case TirState.refraction:
        return 'Refraction';
      case TirState.critical:
        return 'Critical angle';
      case TirState.totalInternalReflection:
        return 'Total internal reflection';
      case TirState.invalid:
        return 'Invalid input';
    }
  }

  static String _lensNatureLabel(LensImageNature nature) {
    switch (nature) {
      case LensImageNature.real:
        return 'Real';
      case LensImageNature.virtual:
        return 'Virtual';
      case LensImageNature.atInfinity:
        return 'At infinity';
      case LensImageNature.invalid:
        return 'Invalid input';
    }
  }

  static String _lensOrientationLabel(LensOrientation orientation) {
    switch (orientation) {
      case LensOrientation.inverted:
        return 'Inverted';
      case LensOrientation.upright:
        return 'Upright';
      case LensOrientation.none:
        return '-';
    }
  }

  static String _lensSizeLabel(LensSize size) {
    switch (size) {
      case LensSize.magnified:
        return 'Magnified';
      case LensSize.diminished:
        return 'Diminished';
      case LensSize.sameSize:
        return 'Same size';
      case LensSize.undefined:
        return '-';
    }
  }
}

class _NumberInput extends StatelessWidget {
  const _NumberInput({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.onCalculate, required this.onReset});

  final VoidCallback onCalculate;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onCalculate,
            child: const Text('Calculate'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(onPressed: onReset, child: const Text('Reset')),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.title, required this.body});

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

class _PlainInfoCard extends StatelessWidget {
  const _PlainInfoCard({
    required this.title,
    required this.body,
    required this.accent,
  });

  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(color: accent),
          ),
          const SizedBox(height: 6),
          Text(body, style: theme.textTheme.bodyMedium),
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
  final _Class11CheckpointQuestion question;
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

class _ExperimentHeadingChip extends StatelessWidget {
  const _ExperimentHeadingChip({
    required this.title,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? accent : accent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? accent : accent.withValues(alpha: 0.30),
          ),
        ),
        child: Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: active ? Colors.white : accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StageArea extends StatelessWidget {
  const _StageArea({
    required this.experiment,
    required this.tirResult,
    required this.prismResult,
    required this.lensResult,
    this.showOverlays = true,
    this.showHeading = true,
  });

  final Class11Experiment experiment;
  final TirResult tirResult;
  final PrismResult prismResult;
  final LensResult lensResult;
  final bool showOverlays;
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 860;

        final canvasPainter = CustomPaint(
          painter: _ExperimentPainter(
            experimentId: experiment.id,
            tirResult: tirResult,
            prismResult: prismResult,
            lensResult: lensResult,
          ),
          child: const SizedBox.expand(),
        );

        final stageContent = showOverlays
            ? Stack(
                children: [
                  Positioned.fill(child: canvasPainter),
                  Positioned(
                    top: 24,
                    left: 24,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? 240 : 360,
                      ),
                      child: _OverlayCard(
                        title: 'Physics',
                        accent: experiment.accent,
                        body: _equationText(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? 500 : 600,
                      ),
                      child: _OverlayCard(
                        title: 'Observation',
                        accent: experiment.accent,
                        body: _observationText(),
                      ),
                    ),
                  ),
                ],
              )
            : canvasPainter;

        if (!showHeading) return stageContent;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text('Canvas', style: theme.textTheme.titleMedium),
            ),
            Expanded(child: stageContent),
          ],
        );
      },
    );
  }

  String _equationText() {
    if (experiment.id == 'tir') {
      return 'n1 sin i = n2 sin r\nic = sin⁻¹(n2 / n1), n2 = 1 (air)';
    }
    if (experiment.id == 'prism') {
      return 'At minimum deviation:\nn = sin((A + δ)/2) / sin(A/2)';
    }
    return 'Thin lens formula:\n1/f = 1/v - 1/u\nMagnification m = v/u';
  }

  String _observationText() {
    if (experiment.id == 'tir') return tirResult.message;
    if (experiment.id == 'prism') return prismResult.message;
    return lensResult.message;
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
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DECF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(color: accent),
            ),
            const SizedBox(height: 6),
            Text(body, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ExperimentPainter extends CustomPainter {
  _ExperimentPainter({
    required this.experimentId,
    required this.tirResult,
    required this.prismResult,
    required this.lensResult,
  });

  final String experimentId;
  final TirResult tirResult;
  final PrismResult prismResult;
  final LensResult lensResult;

  @override
  void paint(Canvas canvas, Size size) {
    switch (experimentId) {
      case 'tir':
        _drawTir(canvas, size);
        break;
      case 'prism':
        _drawPrism(canvas, size);
        break;
      case 'lens':
        _drawLens(canvas, size);
        break;
    }
  }

  void _drawTir(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final boundaryY = size.height * 0.56;
    final hit = Offset(size.width * 0.5, boundaryY);
    final rayLength = math.min(size.width * 0.32, size.height * 0.34);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEAF3FF),
            Color(0xFFE0F2FE),
            Color(0xFF0D9488),
          ],
          stops: <double>[0, 0.55, 1],
        ).createShader(rect),
    );

    canvas.drawRect(
      Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY),
      Paint()..color = const Color(0xFF0F766E).withValues(alpha: 0.35),
    );

    canvas.drawLine(
      Offset(0, boundaryY),
      Offset(size.width, boundaryY),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 3.2,
    );
    _drawLabel(
      canvas,
      'Interface',
      Offset(12, boundaryY - 26),
      color: const Color(0xFF334155),
      bounds: size,
    );
    _drawLabel(
      canvas,
      'Rarer medium (air)',
      const Offset(12, 10),
      color: const Color(0xFF1E3A8A),
      bounds: size,
    );
    _drawLabel(
      canvas,
      'Denser medium (glass/water)',
      Offset(12, boundaryY + 10),
      color: const Color(0xFF065F46),
      bounds: size,
    );

    _drawDashedLine(
      canvas,
      start: Offset(hit.dx, 8),
      end: Offset(hit.dx, size.height - 8),
      color: const Color(0xFF64748B),
      strokeWidth: 2,
    );
    _drawLabel(
      canvas,
      'Normal',
      Offset(hit.dx + 8, 14),
      color: const Color(0xFF334155),
      bounds: size,
    );

    final iRad = tirResult.incidentAngleDeg * math.pi / 180;
    final incidentStart = Offset(
      hit.dx - math.sin(iRad) * rayLength,
      hit.dy + math.cos(iRad) * rayLength,
    );
    _drawDirectionalRay(
      canvas,
      from: incidentStart,
      to: hit,
      color: const Color(0xFFF97316),
      strokeWidth: 4,
    );
    _drawLabel(
      canvas,
      'Incident ray',
      Offset(
        (incidentStart.dx + hit.dx) / 2 - 52,
        (incidentStart.dy + hit.dy) / 2 + 10,
      ),
      color: const Color(0xFF9A3412),
      bounds: size,
    );

    final incidentDirection = math.atan2(
      incidentStart.dy - hit.dy,
      incidentStart.dx - hit.dx,
    );
    canvas.drawArc(
      Rect.fromCircle(center: hit, radius: 34),
      math.pi / 2,
      incidentDirection - math.pi / 2,
      false,
      Paint()
        ..color = const Color(0xFFF97316)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );
    _drawLabel(
      canvas,
      'i',
      Offset(hit.dx - 26, hit.dy + 24),
      color: const Color(0xFFF97316),
      fontSize: 13,
      bounds: size,
    );

    if (tirResult.criticalAngleDeg.isFinite) {
      final icRad = tirResult.criticalAngleDeg * math.pi / 180;
      final criticalEnd = Offset(
        hit.dx - math.sin(icRad) * (rayLength * 0.58),
        hit.dy + math.cos(icRad) * (rayLength * 0.58),
      );
      _drawDashedLine(
        canvas,
        start: hit,
        end: criticalEnd,
        color: const Color(0xFF0F766E),
        strokeWidth: 1.8,
      );
      _drawLabel(
        canvas,
        'ic',
        Offset(criticalEnd.dx - 18, criticalEnd.dy + 4),
        color: const Color(0xFF0F766E),
        fontSize: 12,
        bounds: size,
      );
    }

    if (tirResult.state == TirState.refraction &&
        tirResult.refractionAngleDeg != null) {
      final rRad = tirResult.refractionAngleDeg! * math.pi / 180;
      final refractedEnd = Offset(
        hit.dx + math.sin(rRad) * rayLength,
        hit.dy - math.cos(rRad) * rayLength,
      );
      _drawDirectionalRay(
        canvas,
        from: hit,
        to: refractedEnd,
        color: const Color(0xFF2563EB),
        strokeWidth: 4,
      );
      _drawLabel(
        canvas,
        'Refracted ray',
        Offset(
          (hit.dx + refractedEnd.dx) / 2 - 48,
          (hit.dy + refractedEnd.dy) / 2 - 24,
        ),
        color: const Color(0xFF1D4ED8),
        bounds: size,
      );
      final refractedDirection = math.atan2(
        refractedEnd.dy - hit.dy,
        refractedEnd.dx - hit.dx,
      );
      canvas.drawArc(
        Rect.fromCircle(center: hit, radius: 34),
        -math.pi / 2,
        refractedDirection + math.pi / 2,
        false,
        Paint()
          ..color = const Color(0xFF2563EB)
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke,
      );
      _drawLabel(
        canvas,
        'r',
        Offset(hit.dx + 12, hit.dy - 32),
        color: const Color(0xFF2563EB),
        fontSize: 13,
        bounds: size,
      );
    } else if (tirResult.state == TirState.critical) {
      final grazingEnd = Offset(size.width - 16, boundaryY - 1);
      _drawDirectionalRay(
        canvas,
        from: hit,
        to: grazingEnd,
        color: const Color(0xFF2563EB),
        strokeWidth: 4,
      );
      _drawLabel(
        canvas,
        'Refracted ray (r = 90°)',
        Offset(hit.dx + 20, boundaryY - 28),
        color: const Color(0xFF1D4ED8),
        bounds: size,
      );
    }

    if (tirResult.state != TirState.refraction) {
      final reflectedEnd = Offset(
        hit.dx + math.sin(iRad) * rayLength,
        hit.dy + math.cos(iRad) * rayLength,
      );
      _drawDirectionalRay(
        canvas,
        from: hit,
        to: reflectedEnd,
        color: const Color(0xFFFDE047),
        strokeWidth: 4,
      );
      _drawLabel(
        canvas,
        'Reflected ray',
        Offset(
          (hit.dx + reflectedEnd.dx) / 2 - 44,
          (hit.dy + reflectedEnd.dy) / 2 - 16,
        ),
        color: const Color(0xFFA16207),
        bounds: size,
      );
    }

    canvas.drawCircle(hit, 5, Paint()..color = Colors.white);
    _drawLabel(
      canvas,
      'Point of incidence',
      Offset(hit.dx + 8, hit.dy + 6),
      color: const Color(0xFF334155),
      bounds: size,
    );

    _drawTirReadoutPanel(canvas, size);
  }

  void _drawDirectionalRay(
    Canvas canvas, {
    required Offset from,
    required Offset to,
    required Color color,
    double strokeWidth = 3,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to, paint);
    final direction = to - from;
    final len = direction.distance;
    if (len < 1) return;
    final unit = direction / len;
    final perp = Offset(-unit.dy, unit.dx);
    const arrowLen = 11.0;
    const arrowWidth = 5.0;
    final base = to - unit * arrowLen;
    final p1 = base + perp * arrowWidth;
    final p2 = base - perp * arrowWidth;
    final path = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawTirReadoutPanel(Canvas canvas, Size size) {
    final panelWidth = math.min(size.width * 0.34, 260.0);
    final panelRect = Rect.fromLTWH(
      size.width - panelWidth - 14,
      12,
      panelWidth,
      114,
    );
    final panelRRect = RRect.fromRectAndRadius(
      panelRect,
      const Radius.circular(12),
    );
    canvas.drawRRect(
      panelRRect,
      Paint()..color = const Color(0xFF0F172A).withValues(alpha: 0.84),
    );
    canvas.drawRRect(
      panelRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFF93C5FD).withValues(alpha: 0.6),
    );

    final critical = tirResult.criticalAngleDeg.isFinite
        ? '${tirResult.criticalAngleDeg.toStringAsFixed(1)}°'
        : '-';
    final refracted = tirResult.refractionAngleDeg == null
        ? '-'
        : '${tirResult.refractionAngleDeg!.toStringAsFixed(1)}°';
    final lines = <String>[
      'i: ${tirResult.incidentAngleDeg.toStringAsFixed(1)}°',
      'ic: $critical',
      'r: $refracted',
      'State: ${_tirStateLabelText(tirResult.state)}',
    ];
    final painter = TextPainter(
      text: TextSpan(
        text: lines.join('\n'),
        style: const TextStyle(
          color: Color(0xFFBFDBFE),
          fontSize: 11.5,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: panelWidth - 16);
    painter.paint(canvas, Offset(panelRect.left + 8, panelRect.top + 8));
  }

  String _tirStateLabelText(TirState state) {
    switch (state) {
      case TirState.refraction:
        return 'Refraction';
      case TirState.critical:
        return 'Critical angle';
      case TirState.totalInternalReflection:
        return 'TIR';
      case TirState.invalid:
        return 'Invalid';
    }
  }

  void _drawPrism(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        ).createShader(rect),
    );

    final cx = size.width * 0.42;
    final cy = size.height * 0.5;
    final p = math.min(size.width, size.height) * 0.24;

    final triangle = Path()
      ..moveTo(cx, cy - p)
      ..lineTo(cx + p * 0.86, cy + p * 0.5)
      ..lineTo(cx - p * 0.86, cy + p * 0.5)
      ..close();

    canvas.drawPath(
      triangle,
      Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.22),
    );
    canvas.drawPath(
      triangle,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFF38BDF8)
        ..strokeWidth = 3,
    );

    final entry = Offset(size.width * 0.1, cy);
    final hit = Offset(cx - p * 0.6, cy + p * 0.15);
    final exit = Offset(cx + p * 0.6, cy + p * 0.1);

    canvas.drawLine(
      entry,
      hit,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      hit,
      exit,
      Paint()
        ..color = Colors.white70
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    final dispersionFactor = prismResult.refractiveIndex.isFinite
        ? (prismResult.refractiveIndex - 1).clamp(0.2, 0.8)
        : 0.4;
    final colors = <Color>[
      const Color(0xFFFF0000),
      const Color(0xFFFF7F00),
      const Color(0xFFFFFF00),
      const Color(0xFF00FF00),
      const Color(0xFF0000FF),
      const Color(0xFF4B0082),
      const Color(0xFF9400D3),
    ];

    for (var i = 0; i < colors.length; i++) {
      final spread = (i - 3) * 0.09 * dispersionFactor;
      final end = Offset(
        size.width * 0.95,
        exit.dy + spread * size.height * 0.35,
      );
      canvas.drawLine(
        exit,
        end,
        Paint()
          ..color = colors[i].withValues(alpha: 0.85)
          ..strokeWidth = 3.5,
      );
    }
  }

  void _drawLens(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFF8FBFF), Color(0xFFEEF2FF)],
        ).createShader(rect),
    );

    final cx = size.width * 0.52;
    final cy = size.height * 0.52;
    final focalPx = (lensResult.focalLengthCm * 3).clamp(40, 180);

    canvas.drawLine(
      Offset(0, cy),
      Offset(size.width, cy),
      Paint()
        ..color = const Color(0xFF64748B)
        ..strokeWidth = 2,
    );
    _drawLabel(
      canvas,
      'Principal axis',
      Offset(12, cy + 8),
      color: const Color(0xFF334155),
    );
    canvas.drawCircle(
      Offset(cx - focalPx, cy),
      4,
      Paint()..color = const Color(0xFFEF4444),
    );
    canvas.drawCircle(
      Offset(cx + focalPx, cy),
      4,
      Paint()..color = const Color(0xFFEF4444),
    );
    canvas.drawCircle(
      Offset(cx - focalPx * 2, cy),
      3,
      Paint()..color = const Color(0xFFB91C1C),
    );
    canvas.drawCircle(
      Offset(cx + focalPx * 2, cy),
      3,
      Paint()..color = const Color(0xFFB91C1C),
    );
    _drawLabel(
      canvas,
      'F1',
      Offset(cx - focalPx - 18, cy + 10),
      color: const Color(0xFFB91C1C),
    );
    _drawLabel(
      canvas,
      'F2',
      Offset(cx + focalPx + 8, cy + 10),
      color: const Color(0xFFB91C1C),
    );
    _drawLabel(
      canvas,
      '2F1',
      Offset(cx - focalPx * 2 - 20, cy + 10),
      color: const Color(0xFF991B1B),
    );
    _drawLabel(
      canvas,
      '2F2',
      Offset(cx + focalPx * 2 + 8, cy + 10),
      color: const Color(0xFF991B1B),
    );

    final lensHeight = size.height * 0.46;
    const lensHalfWidth = 18.0;
    final lensPath = lensResult.type == LensType.convex
        ? (Path()
            ..moveTo(cx, cy - lensHeight / 2)
            ..quadraticBezierTo(cx + lensHalfWidth, cy, cx, cy + lensHeight / 2)
            ..quadraticBezierTo(
              cx - lensHalfWidth,
              cy,
              cx,
              cy - lensHeight / 2,
            ))
        : (Path()
            ..moveTo(cx - lensHalfWidth, cy - lensHeight / 2)
            ..quadraticBezierTo(
              cx - 5,
              cy,
              cx - lensHalfWidth,
              cy + lensHeight / 2,
            )
            ..lineTo(cx + lensHalfWidth, cy + lensHeight / 2)
            ..quadraticBezierTo(
              cx + 5,
              cy,
              cx + lensHalfWidth,
              cy - lensHeight / 2,
            )
            ..close());
    canvas.drawPath(
      lensPath,
      Paint()..color = const Color(0xFF3B82F6).withValues(alpha: 0.7),
    );
    canvas.drawPath(
      lensPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFF1D4ED8)
        ..strokeWidth = 2,
    );
    _drawLabel(
      canvas,
      lensResult.type == LensType.convex ? 'Convex lens' : 'Concave lens',
      Offset(cx - 56, cy - lensHeight / 2 - 22),
      color: const Color(0xFF1E40AF),
      bounds: size,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      3,
      Paint()..color = const Color(0xFF1E40AF),
    );
    _drawLabel(
      canvas,
      'Optical centre (O)',
      Offset(cx + 10, cy - 18),
      color: const Color(0xFF1E40AF),
      bounds: size,
    );

    final objectX = (cx - lensResult.objectDistanceCm * 3)
        .clamp(30.0, cx - 20)
        .toDouble();
    const objectHeight = 90.0;
    final objectTip = Offset(objectX, cy - objectHeight);
    _drawArrow(
      canvas,
      base: Offset(objectX, cy),
      tip: objectTip,
      color: const Color(0xFF059669),
    );
    _drawLabel(
      canvas,
      'Object',
      Offset(objectX - 28, objectTip.dy - 22),
      color: const Color(0xFF065F46),
      bounds: size,
    );

    if (lensResult.imageDistanceCm != null &&
        lensResult.magnification != null) {
      final imageX = (cx + lensResult.imageDistanceCm! * 3)
          .clamp(20.0, size.width - 20)
          .toDouble();
      final imageHeight = -objectHeight * lensResult.magnification!;
      final imageTip = Offset(imageX, cy + imageHeight);
      _drawArrow(
        canvas,
        base: Offset(imageX, cy),
        tip: imageTip,
        color: const Color(0xFFDC2626),
      );
      _drawLabel(
        canvas,
        lensResult.imageNature == LensImageNature.real
            ? 'Real image'
            : 'Virtual image',
        lensResult.imageNature == LensImageNature.real
            ? Offset(imageX + 8, imageTip.dy - 22)
            : Offset(imageX - 92, imageTip.dy + 10),
        color: const Color(0xFF991B1B),
        bounds: size,
      );

      final lensPointParallel = Offset(cx, objectTip.dy);
      final center = Offset(cx, cy);
      final rightEdgeX = size.width - 10;

      canvas.drawLine(
        objectTip,
        lensPointParallel,
        Paint()
          ..color = const Color(0xFF16A34A).withValues(alpha: 0.45)
          ..strokeWidth = 2.2,
      );

      if (lensResult.type == LensType.convex) {
        final ray1End = _rayEndAtX(
          start: lensPointParallel,
          through: Offset(cx + focalPx, cy),
          targetX: rightEdgeX,
        );
        canvas.drawLine(
          lensPointParallel,
          ray1End,
          Paint()
            ..color = const Color(0xFF16A34A).withValues(alpha: 0.75)
            ..strokeWidth = 2.2,
        );
      } else {
        final ray1End = _rayEndAtX(
          start: lensPointParallel,
          through: Offset(cx + 80, lensPointParallel.dy - 30),
          targetX: rightEdgeX,
        );
        canvas.drawLine(
          lensPointParallel,
          ray1End,
          Paint()
            ..color = const Color(0xFF16A34A).withValues(alpha: 0.75)
            ..strokeWidth = 2.2,
        );
        _drawDashedLine(
          canvas,
          start: lensPointParallel,
          end: imageTip,
          color: const Color(0xFF16A34A),
          strokeWidth: 1.5,
        );
      }
      _drawLabel(
        canvas,
        'Ray 1 (parallel to axis)',
        Offset(cx - 175, objectTip.dy - 30),
        color: const Color(0xFF166534),
        bounds: size,
      );

      canvas.drawLine(
        objectTip,
        center,
        Paint()
          ..color = const Color(0xFF2563EB).withValues(alpha: 0.65)
          ..strokeWidth = 2.2,
      );
      final ray2End = _rayEndAtX(
        start: center,
        through: objectTip,
        targetX: rightEdgeX,
      );
      canvas.drawLine(
        center,
        ray2End,
        Paint()
          ..color = const Color(0xFF2563EB).withValues(alpha: 0.65)
          ..strokeWidth = 2.2,
      );
      if (lensResult.imageNature == LensImageNature.virtual) {
        _drawDashedLine(
          canvas,
          start: center,
          end: imageTip,
          color: const Color(0xFF2563EB),
          strokeWidth: 1.5,
        );
      }
      _drawLabel(
        canvas,
        'Ray 2 (through optical centre)',
        Offset(cx - 170, cy + 14),
        color: const Color(0xFF1D4ED8),
        bounds: size,
      );
      if (lensResult.imageNature == LensImageNature.virtual) {
        _drawLabel(
          canvas,
          'Virtual extension',
          Offset(imageX - 84, imageTip.dy + 28),
          color: const Color(0xFF7C3AED),
          bounds: size,
        );
      }
    }
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset position, {
    Color color = const Color(0xFF0F172A),
    double fontSize = 11,
    Size? bounds,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 220);
    final drawX = bounds == null
        ? position.dx
        : position.dx.clamp(6.0, bounds.width - painter.width - 6).toDouble();
    final drawY = bounds == null
        ? position.dy
        : position.dy.clamp(6.0, bounds.height - painter.height - 6).toDouble();
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        drawX - 4,
        drawY - 2,
        painter.width + 8,
        painter.height + 4,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      bgRect,
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
    painter.paint(canvas, Offset(drawX, drawY));
  }

  void _drawArrow(
    Canvas canvas, {
    required Offset base,
    required Offset tip,
    required Color color,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;
    canvas.drawLine(base, tip, paint);
    final headY = tip.dy > base.dy ? -10 : 10;
    canvas.drawLine(Offset(tip.dx - 8, tip.dy + headY), tip, paint);
    canvas.drawLine(Offset(tip.dx + 8, tip.dy + headY), tip, paint);
  }

  void _drawDashedLine(
    Canvas canvas, {
    required Offset start,
    required Offset end,
    required Color color,
    double strokeWidth = 2,
    double dashLength = 7,
    double gapLength = 5,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    final total = (end - start).distance;
    if (total <= 0) return;
    final direction = (end - start) / total;
    var offset = 0.0;
    while (offset < total) {
      final dashStart = start + direction * offset;
      final dashEnd = start + direction * math.min(offset + dashLength, total);
      canvas.drawLine(dashStart, dashEnd, paint);
      offset += dashLength + gapLength;
    }
  }

  Offset _rayEndAtX({
    required Offset start,
    required Offset through,
    required double targetX,
  }) {
    final dx = through.dx - start.dx;
    if (dx.abs() < 1e-6) {
      return Offset(targetX, start.dy);
    }
    final slope = (through.dy - start.dy) / dx;
    return Offset(targetX, start.dy + slope * (targetX - start.dx));
  }

  @override
  bool shouldRepaint(covariant _ExperimentPainter oldDelegate) {
    return oldDelegate.experimentId != experimentId ||
        oldDelegate.tirResult != tirResult ||
        oldDelegate.prismResult != prismResult ||
        oldDelegate.lensResult != lensResult;
  }
}
