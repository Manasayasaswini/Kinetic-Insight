import 'dart:math' as math;

import 'package:flutter/material.dart';

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
  });

  final TextEditingController distanceController;
  final PlaneMirrorResult result;
  final VoidCallback onCalculate;

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
        const SizedBox(height: 12),
        _ResultPanel(
          title: 'Output',
          body:
              'Object distance = ${result.objectDistanceCm.toStringAsFixed(1)} cm\nImage distance = ${result.imageDistanceCm.toStringAsFixed(1)} cm\nRule: d(object) = d(image)',
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: _PlaneMirrorStage(distanceCm: result.objectDistanceCm),
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
  });

  final MirrorType mirrorType;
  final TextEditingController objectDistanceController;
  final TextEditingController focalLengthController;
  final SphericalMirrorResult result;
  final ValueChanged<MirrorType> onMirrorTypeChanged;
  final VoidCallback onCalculate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        _ResultPanel(
          title: 'Output',
          body:
              'Image distance v = ${result.imageDistanceCm == null ? '∞' : '${result.imageDistanceCm!.toStringAsFixed(2)} cm'}\n'
              'Magnification m = ${result.magnification == null ? '-' : result.magnification!.toStringAsFixed(2)}\n'
              'Nature = ${_natureLabel(result.nature)}\n'
              'Orientation = ${_orientationLabel(result.orientation)}\n'
              'Size = ${_sizeLabel(result.size)}',
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: _MirrorStage(result: result),
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
}

class _MirrorStage extends StatelessWidget {
  const _MirrorStage({required this.result});

  final SphericalMirrorResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: CustomPaint(
        painter: _MirrorPainter(result),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _MirrorPainter extends CustomPainter {
  _MirrorPainter(this.result);

  final SphericalMirrorResult result;

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height * 0.62;
    final mirrorX = size.width * 0.72;
    canvas.drawLine(
      Offset(0, cy),
      Offset(size.width, cy),
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..strokeWidth = 2,
    );

    final mirrorPath = Path();
    final mirrorTop = Offset(mirrorX, cy - size.height * 0.33);
    final mirrorBottom = Offset(mirrorX, cy + size.height * 0.22);
    if (result.type == MirrorType.concave) {
      mirrorPath
        ..moveTo(mirrorTop.dx, mirrorTop.dy)
        ..quadraticBezierTo(
          mirrorX + 42,
          cy - 12,
          mirrorBottom.dx,
          mirrorBottom.dy,
        );
    } else {
      mirrorPath
        ..moveTo(mirrorTop.dx, mirrorTop.dy)
        ..quadraticBezierTo(
          mirrorX - 42,
          cy - 12,
          mirrorBottom.dx,
          mirrorBottom.dy,
        );
    }
    canvas.drawPath(
      mirrorPath,
      Paint()
        ..color = const Color(0xFF2563EB)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke,
    );

    final objectX = (mirrorX - result.objectDistanceCm * 6)
        .clamp(30.0, mirrorX - 20)
        .toDouble();
    final objectBase = Offset(objectX, cy);
    final objectTip = Offset(objectX, cy - 80);
    _arrow(canvas, objectBase, objectTip, const Color(0xFF059669));

    if (result.imageDistanceCm != null && result.magnification != null) {
      final imageX = (mirrorX + result.imageDistanceCm! * 6)
          .clamp(20.0, size.width - 20)
          .toDouble();
      final imageHeight = -80 * result.magnification!;
      final imageBase = Offset(imageX, cy);
      final imageTip = Offset(imageX, cy - imageHeight);
      _arrow(canvas, imageBase, imageTip, const Color(0xFFDC2626));
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

class _NewtonsDiscExperiment extends StatelessWidget {
  const _NewtonsDiscExperiment({
    required this.speedLevel,
    required this.controller,
    required this.maxLevel,
    required this.onSpeedLevelChanged,
  });

  final double speedLevel;
  final AnimationController controller;
  final double maxLevel;
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
        const SizedBox(height: 12),
        _ResultPanel(
          title: 'Output',
          body:
              'White blend opacity = ${whiteOpacity.toStringAsFixed(2)}\n'
              'As speed increases, colors merge visually toward white.',
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
