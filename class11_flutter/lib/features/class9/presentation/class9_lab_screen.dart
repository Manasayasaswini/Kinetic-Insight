import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class9_kaleidoscope_calculator.dart';

enum _Class9Experiment { lawsOfReflection, kaleidoscope }

class Class9LabScreen extends StatefulWidget {
  const Class9LabScreen({super.key});

  @override
  State<Class9LabScreen> createState() => _Class9LabScreenState();
}

class _Class9LabScreenState extends State<Class9LabScreen>
    with SingleTickerProviderStateMixin {
  _Class9Experiment _active = _Class9Experiment.lawsOfReflection;

  double _incidentAngle = 30;
  double _mirrorAngle = 45;
  int _numberOfMirrors = 2;
  KaleidoscopeResult? _result;

  late final AnimationController _rayController;

  String? _inputError;

  @override
  void initState() {
    super.initState();
    _rayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
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
    required this.onIncidentAngleChanged,
  });

  final double incidentAngle;
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
        const SizedBox(height: 12),
        _ResultPanel(
          title: 'Output',
          body:
              'Incident angle θi = ${incidentAngle.toStringAsFixed(0)}°\n'
              'Reflection angle θr = ${incidentAngle.toStringAsFixed(0)}°\n'
              'θi = θr (Law of Reflection confirmed)',
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: _ReflectionLawStage(incidentAngle: incidentAngle),
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
    final cx = size.width * 0.4;
    final cy = size.height * 0.5;
    final mirrorLength = size.width * 0.7;
    final rayLength = size.width * 0.45;

    canvas.drawLine(
      Offset(cx - mirrorLength / 2, cy),
      Offset(cx + mirrorLength / 2, cy),
      Paint()
        ..color = const Color(0xFF64748B)
        ..strokeWidth = 3,
    );

    canvas.drawLine(
      Offset(cx, cy - rayLength),
      Offset(cx, cy + rayLength),
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    final incidentRad = incidentAngle * math.pi / 180;
    final incidentEndX = cx - rayLength * math.sin(incidentRad);
    final incidentEndY = cy - rayLength * math.cos(incidentRad);

    canvas.drawLine(
      Offset(cx, cy),
      Offset(incidentEndX, incidentEndY),
      Paint()
        ..color = const Color(0xFF059669)
        ..strokeWidth = 3,
    );

    final reflectedEndX = cx + rayLength * math.sin(incidentRad);
    final reflectedEndY = cy - rayLength * math.cos(incidentRad);

    canvas.drawLine(
      Offset(cx, cy),
      Offset(reflectedEndX, reflectedEndY),
      Paint()
        ..color = const Color(0xFFDC2626)
        ..strokeWidth = 3,
    );

    final arcRadius = rayLength * 0.35;

    final incidentStartAngle = -math.pi / 2 - incidentRad;
    final arcPaint = Paint()
      ..color = const Color(0xFF059669)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: arcRadius),
      incidentStartAngle,
      incidentRad,
      false,
      arcPaint,
    );

    canvas.drawLine(
      Offset(
        cx + arcRadius * math.sin(incidentStartAngle),
        cy + arcRadius * math.cos(incidentStartAngle),
      ),
      Offset(
        cx + (arcRadius - 8) * math.sin(incidentStartAngle),
        cy + (arcRadius - 8) * math.cos(incidentStartAngle),
      ),
      arcPaint,
    );
    canvas.drawLine(
      Offset(
        cx + arcRadius * math.sin(-math.pi / 2),
        cy + arcRadius * math.cos(-math.pi / 2),
      ),
      Offset(
        cx + (arcRadius - 8) * math.sin(-math.pi / 2),
        cy + (arcRadius - 8) * math.cos(-math.pi / 2),
      ),
      arcPaint,
    );

    final thetaIPainter = TextPainter(
      text: TextSpan(
        text: 'θi = ${incidentAngle.toStringAsFixed(0)}°',
        style: const TextStyle(
          color: Color(0xFF059669),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    thetaIPainter.paint(
      canvas,
      Offset(cx - arcRadius - 55, cy - arcRadius - 15),
    );

    final arcPaint2 = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: arcRadius),
      -math.pi / 2,
      incidentRad,
      false,
      arcPaint2,
    );

    canvas.drawLine(
      Offset(
        cx + arcRadius * math.sin(-math.pi / 2),
        cy + arcRadius * math.cos(-math.pi / 2),
      ),
      Offset(
        cx + (arcRadius - 8) * math.sin(-math.pi / 2),
        cy + (arcRadius - 8) * math.cos(-math.pi / 2),
      ),
      arcPaint2,
    );
    canvas.drawLine(
      Offset(
        cx + arcRadius * math.sin(-math.pi / 2 + incidentRad),
        cy + arcRadius * math.cos(-math.pi / 2 + incidentRad),
      ),
      Offset(
        cx + (arcRadius - 8) * math.sin(-math.pi / 2 + incidentRad),
        cy + (arcRadius - 8) * math.cos(-math.pi / 2 + incidentRad),
      ),
      arcPaint2,
    );

    final thetaRPainter = TextPainter(
      text: TextSpan(
        text: 'θr = ${incidentAngle.toStringAsFixed(0)}°',
        style: const TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    thetaRPainter.paint(canvas, Offset(cx + 15, cy - arcRadius - 15));

    final normalLabelPainter = TextPainter(
      text: const TextSpan(
        text: 'Normal',
        style: TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    normalLabelPainter.paint(canvas, Offset(cx + 8, cy + 10));
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
    required this.onMirrorAngleChanged,
    required this.onNumberOfMirrorsChanged,
    required this.rayController,
  });

  final double mirrorAngle;
  final int numberOfMirrors;
  final KaleidoscopeResult? result;
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
        if (result != null)
          _ResultPanel(
            title: 'Output',
            body:
                'Mirror angle θ = ${result!.mirrorAngleDegrees.toStringAsFixed(0)}°\n'
                'Number of sectors = ${result!.numberOfSectors}\n'
                'Reflection count = ${result!.reflectionCount}\n'
                'Total images visible = ${result!.imageCount}',
          ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 360,
            height: 360,
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
          ),
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
