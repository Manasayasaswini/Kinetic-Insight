import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class11_experiment.dart';
import '../domain/class11_optics_calculator.dart';

class Class11LabScreen extends StatefulWidget {
  const Class11LabScreen({super.key});

  @override
  State<Class11LabScreen> createState() => _Class11LabScreenState();
}

class _Class11LabScreenState extends State<Class11LabScreen> {
  static const _experiments = <Class11Experiment>[
    Class11Experiment(
      id: 'tir',
      title: 'Experiment 1: Critical Angle & TIR',
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
      title: 'Experiment 2: Prism Formula',
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
      title: 'Experiment 3: Lens Image Formation',
      subtitle:
          'Input object distance and focal length to compute image distance and magnification.',
      observation:
          'Lens equation predicts image position, orientation, and size.',
      fact: '1/f = 1/v - 1/u unifies all thin-lens image cases.',
      accent: Color(0xFFC97D10),
    ),
  ];

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

  String? _inputError;

  @override
  void dispose() {
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
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      _ControlRail(
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
                      ),
                      SizedBox(
                        height: constraints.maxWidth < 480 ? 580 : 660,
                        child: _StageArea(
                          experiment: _activeExperiment,
                          tirResult: _tirResult,
                          prismResult: _prismResult,
                          lensResult: _lensResult,
                        ),
                      ),
                    ],
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
                      ),
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        tirResult: _tirResult,
                        prismResult: _prismResult,
                        lensResult: _lensResult,
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
            for (final exp in experiments) ...[
              _ExperimentTile(
                experiment: exp,
                active: activeExperiment.id == exp.id,
                onTap: () => onExperimentSelected(exp),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
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
            if (activeExperiment.id == 'tir') ...[
              const SizedBox(height: 20),
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
              const SizedBox(height: 12),
              _ResultCard(
                title: 'Output',
                body:
                    'Critical angle ic = ${_fmt(tirResult.criticalAngleDeg)}°\nRefraction angle r = ${tirResult.refractionAngleDeg == null ? '-' : '${_fmt(tirResult.refractionAngleDeg!)}°'}\nReflected angle = ${_fmt(tirResult.reflectedAngleDeg)}°\nState = ${_tirStateLabel(tirResult.state)}',
              ),
            ],
            if (activeExperiment.id == 'prism') ...[
              const SizedBox(height: 20),
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
              const SizedBox(height: 12),
              _ResultCard(
                title: 'Output',
                body:
                    'Formula: n = sin((A+δ)/2) / sin(A/2)\nComputed n = ${prismResult.refractiveIndex.isNaN ? '-' : _fmt(prismResult.refractiveIndex, decimals: 3)}',
              ),
            ],
            if (activeExperiment.id == 'lens') ...[
              const SizedBox(height: 20),
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
              const SizedBox(height: 12),
              _ResultCard(
                title: 'Output',
                body:
                    'Image distance v = ${lensResult.imageDistanceCm == null ? '∞' : '${_fmt(lensResult.imageDistanceCm!)} cm'}\nMagnification m = ${lensResult.magnification == null ? '-' : _fmt(lensResult.magnification!, decimals: 2)}\nNature = ${_lensNatureLabel(lensResult.imageNature)}\nOrientation = ${_lensOrientationLabel(lensResult.orientation)}\nSize = ${_lensSizeLabel(lensResult.size)}',
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: activeExperiment.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: activeExperiment.accent.withValues(alpha: 0.16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lab Note',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: activeExperiment.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeExperiment.observation,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
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

class _ExperimentTile extends StatelessWidget {
  const _ExperimentTile({
    required this.experiment,
    required this.active,
    required this.onTap,
  });

  final Class11Experiment experiment;
  final bool active;
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
            const SizedBox(height: 8),
            Text(experiment.subtitle, style: theme.textTheme.bodyMedium),
          ],
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
  });

  final Class11Experiment experiment;
  final TirResult tirResult;
  final PrismResult prismResult;
  final LensResult lensResult;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
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

        if (isMobile) {
          return Column(
            children: [
              // Canvas takes available space
              Expanded(child: canvasPainter),
              // Info strip below — clean, no overlap
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFCF7),
                  border: Border(top: BorderSide(color: Color(0xFFE8DECF))),
                ),
                child: Column(
                  children: [
                    _MobileInfoTile(
                      title: 'Physics',
                      body: _equationText(),
                      accent: experiment.accent,
                      icon: Icons.functions_outlined,
                    ),
                    Divider(height: 1, color: const Color(0xFFE8DECF)),
                    _MobileInfoTile(
                      title: 'Readout',
                      body: _readoutText(),
                      accent: experiment.accent,
                      icon: Icons.analytics_outlined,
                    ),
                    Divider(height: 1, color: const Color(0xFFE8DECF)),
                    _MobileInfoTile(
                      title: 'Observation',
                      body: _observationText(),
                      accent: experiment.accent,
                      icon: Icons.visibility_outlined,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // Desktop — floating overlay cards
        return Stack(
          children: [
            Positioned.fill(child: canvasPainter),
            Positioned(
              top: 24,
              left: 24,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: compact ? 240 : 360),
                child: _OverlayCard(
                  title: 'Physics',
                  accent: experiment.accent,
                  body: _equationText(),
                ),
              ),
            ),
            Positioned(
              top: 24,
              right: 24,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: compact ? 240 : 340),
                child: _OverlayCard(
                  title: 'Readout',
                  accent: experiment.accent,
                  body: _readoutText(),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: compact ? 500 : 600),
                child: _OverlayCard(
                  title: 'Observation',
                  accent: experiment.accent,
                  body: _observationText(),
                ),
              ),
            ),
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

  String _readoutText() {
    if (experiment.id == 'tir') {
      final critical = tirResult.criticalAngleDeg.isNaN
          ? '-'
          : '${tirResult.criticalAngleDeg.toStringAsFixed(2)}°';
      final refracted = tirResult.refractionAngleDeg == null
          ? '-'
          : '${tirResult.refractionAngleDeg!.toStringAsFixed(2)}°';
      return 'i = ${tirResult.incidentAngleDeg.toStringAsFixed(2)}°\nic = $critical\nr = $refracted\nState = ${tirResult.state.name}';
    }
    if (experiment.id == 'prism') {
      final n = prismResult.refractiveIndex.isNaN
          ? '-'
          : prismResult.refractiveIndex.toStringAsFixed(3);
      return 'A = ${prismResult.apexAngleDeg.toStringAsFixed(2)}°\nδ = ${prismResult.deviationAngleDeg.toStringAsFixed(2)}°\nn = $n';
    }
    final imageDist = lensResult.imageDistanceCm == null
        ? '∞'
        : '${lensResult.imageDistanceCm!.toStringAsFixed(2)} cm';
    final magnification = lensResult.magnification == null
        ? '-'
        : lensResult.magnification!.toStringAsFixed(2);
    return 'Lens = ${lensResult.type.name}\nv = $imageDist\nm = $magnification\nNature = ${lensResult.imageNature.name}';
  }

  String _observationText() {
    if (experiment.id == 'tir') return tirResult.message;
    if (experiment.id == 'prism') return prismResult.message;
    return lensResult.message;
  }
}

class _MobileInfoTile extends StatelessWidget {
  const _MobileInfoTile({
    required this.title,
    required this.body,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String body;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
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
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFF8FBFF), Color(0xFFF7F0E6)],
        ).createShader(rect),
    );

    final boundaryY = size.height * 0.5;
    final hit = Offset(size.width * 0.55, boundaryY);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, boundaryY),
      Paint()..color = const Color(0xFFEAF3FF),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY),
      Paint()..color = const Color(0xFF0F766E).withValues(alpha: 0.45),
    );
    canvas.drawLine(
      Offset(0, boundaryY),
      Offset(size.width, boundaryY),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 3,
    );
    canvas.drawLine(
      Offset(hit.dx, 0),
      Offset(hit.dx, size.height),
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..strokeWidth = 2,
    );
    _drawLabel(
      canvas,
      'Normal',
      Offset(hit.dx + 8, 18),
      color: const Color(0xFF334155),
    );
    _drawLabel(
      canvas,
      'Interface',
      Offset(14, boundaryY - 24),
      color: const Color(0xFF334155),
    );
    _drawLabel(
      canvas,
      'Rarer medium (air)',
      const Offset(14, 14),
      color: const Color(0xFF1E3A8A),
    );
    _drawLabel(
      canvas,
      'Denser medium (glass/water)',
      Offset(14, boundaryY + 10),
      color: const Color(0xFF064E3B),
    );
    if (tirResult.criticalAngleDeg.isFinite) {
      final icRad = tirResult.criticalAngleDeg * math.pi / 180;
      final icEnd = Offset(
        hit.dx - math.sin(icRad) * 90,
        hit.dy + math.cos(icRad) * 90,
      );
      _drawDashedLine(
        canvas,
        start: hit,
        end: icEnd,
        color: const Color(0xFF0F766E),
        strokeWidth: 2,
      );
      _drawLabel(
        canvas,
        'ic',
        Offset(hit.dx - 50, hit.dy + 36),
        color: const Color(0xFF0F766E),
        fontSize: 13,
      );
    }

    final iRad = tirResult.incidentAngleDeg * math.pi / 180;
    final source = Offset(
      hit.dx - math.sin(iRad) * 220,
      hit.dy + math.cos(iRad) * 220,
    );
    canvas.drawLine(
      source,
      hit,
      Paint()
        ..color = const Color(0xFFF97316)
        ..strokeWidth = 4,
    );
    _drawLabel(
      canvas,
      'Incident ray',
      Offset((source.dx + hit.dx) / 2 - 70, (source.dy + hit.dy) / 2 + 12),
      color: const Color(0xFF9A3412),
    );

    final incidentDirection = math.atan2(
      source.dy - hit.dy,
      source.dx - hit.dx,
    );
    canvas.drawArc(
      Rect.fromCircle(center: hit, radius: 34),
      math.pi / 2,
      incidentDirection - (math.pi / 2),
      false,
      Paint()
        ..color = const Color(0xFFF97316)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    _drawLabel(
      canvas,
      'i',
      Offset(hit.dx - 26, hit.dy + 24),
      color: const Color(0xFFF97316),
      fontSize: 13,
    );

    if (tirResult.state == TirState.refraction &&
        tirResult.refractionAngleDeg != null) {
      final rRad = tirResult.refractionAngleDeg! * math.pi / 180;
      final refractedEnd = Offset(
        hit.dx + math.sin(rRad) * 220,
        hit.dy - math.cos(rRad) * 220,
      );
      canvas.drawLine(
        hit,
        refractedEnd,
        Paint()
          ..color = const Color(0xFF2563EB)
          ..strokeWidth = 4,
      );
      _drawLabel(
        canvas,
        'Refracted ray',
        Offset(
          (hit.dx + refractedEnd.dx) / 2 - 54,
          (hit.dy + refractedEnd.dy) / 2 - 24,
        ),
        color: const Color(0xFF1D4ED8),
      );
      final refractedDirection = math.atan2(
        refractedEnd.dy - hit.dy,
        refractedEnd.dx - hit.dx,
      );
      canvas.drawArc(
        Rect.fromCircle(center: hit, radius: 34),
        -math.pi / 2,
        refractedDirection - (-math.pi / 2),
        false,
        Paint()
          ..color = const Color(0xFF2563EB)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
      _drawLabel(
        canvas,
        'r',
        Offset(hit.dx + 10, hit.dy - 32),
        color: const Color(0xFF2563EB),
        fontSize: 13,
      );
    }
    if (tirResult.state == TirState.critical) {
      final grazingEnd = Offset(size.width - 20, boundaryY - 1);
      canvas.drawLine(
        hit,
        grazingEnd,
        Paint()
          ..color = const Color(0xFF2563EB)
          ..strokeWidth = 4,
      );
      _drawLabel(
        canvas,
        'Refracted ray (r = 90°)',
        Offset(hit.dx + 24, boundaryY - 24),
        color: const Color(0xFF1D4ED8),
      );
    }
    if (tirResult.state != TirState.refraction) {
      final reflectedEnd = Offset(
        hit.dx + math.sin(iRad) * 220,
        hit.dy + math.cos(iRad) * 220,
      );
      canvas.drawLine(
        hit,
        reflectedEnd,
        Paint()
          ..color = const Color(0xFFFDE047)
          ..strokeWidth = 4,
      );
      _drawLabel(
        canvas,
        'Reflected ray',
        Offset(
          (hit.dx + reflectedEnd.dx) / 2 - 46,
          (hit.dy + reflectedEnd.dy) / 2 - 18,
        ),
        color: const Color(0xFFA16207),
      );
    }
    canvas.drawCircle(hit, 5, Paint()..color = Colors.white);
    _drawLabel(
      canvas,
      'Point of incidence',
      Offset(hit.dx + 8, hit.dy + 6),
      color: const Color(0xFF334155),
    );
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
