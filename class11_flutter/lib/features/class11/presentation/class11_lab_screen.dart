import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class11_experiment.dart';

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
      subtitle: 'Change the angle to see refraction, critical angle, and total internal reflection.',
      observation: 'Below the critical angle, some light escapes into air.',
      fact: 'Fiber optic cables work because light keeps undergoing total internal reflection.',
      accent: Color(0xFF0F766E),
    ),
    Class11Experiment(
      id: 'prism',
      title: 'Experiment 2: Prism Dispersion',
      subtitle: 'White light separates into colors because each wavelength bends differently.',
      observation: 'White light separates into VIBGYOR. Violet bends most, red bends least.',
      fact: 'A prism is not making colors from nothing. It is separating the colors already present in white light.',
      accent: Color(0xFF7C3AED),
    ),
    Class11Experiment(
      id: 'lens',
      title: 'Experiment 3: Lens & Image Formation',
      subtitle: 'Trace how curved surfaces focus light into real or virtual images.',
      observation: 'Convex lens: real inverted image. Concave lens: virtual upright image.',
      fact: 'Lens design connects refraction, curvature, and image distance into one powerful model.',
      accent: Color(0xFFC97D10),
    ),
  ];

  late Class11Experiment _activeExperiment = _experiments.first;
  double _incidentAngle = 44;
  double _refractiveIndex = 1.52;
  double _prismRefractiveIndex = 1.52;
  double _incidentHeight = 0.5;
  Offset _pointer = const Offset(0.52, 0.34);

  void _setExperiment(Class11Experiment experiment) {
    setState(() {
      _activeExperiment = experiment;
    });
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
              ? Column(
                  children: [
                    _ControlRail(
                      experiments: _experiments,
                      activeExperiment: _activeExperiment,
                      incidentAngle: _incidentAngle,
                      refractiveIndex: _refractiveIndex,
                      prismRefractiveIndex: _prismRefractiveIndex,
                      onExperimentSelected: _setExperiment,
                      onIncidentAngleChanged: (value) {
                        setState(() => _incidentAngle = value);
                      },
                      onRefractiveIndexChanged: (value) {
                        setState(() => _refractiveIndex = value);
                      },
                      onPrismRefractiveIndexChanged: (value) {
                        setState(() => _prismRefractiveIndex = value);
                      },
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        incidentAngle: _incidentAngle,
                        refractiveIndex: _refractiveIndex,
                        prismRefractiveIndex: _prismRefractiveIndex,
                        incidentHeight: _incidentHeight,
                        pointer: _pointer,
                        onPointerChanged: (value) {
                          setState(() {
                            _pointer = value;
                            _incidentHeight = value.dy.clamp(0.2, 0.8);
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    SizedBox(
                      width: 352,
                      child: _ControlRail(
                        experiments: _experiments,
                        activeExperiment: _activeExperiment,
                        incidentAngle: _incidentAngle,
                        refractiveIndex: _refractiveIndex,
                        prismRefractiveIndex: _prismRefractiveIndex,
                        onExperimentSelected: _setExperiment,
                        onIncidentAngleChanged: (value) {
                          setState(() => _incidentAngle = value);
                        },
                        onRefractiveIndexChanged: (value) {
                          setState(() => _refractiveIndex = value);
                        },
                        onPrismRefractiveIndexChanged: (value) {
                          setState(() => _prismRefractiveIndex = value);
                        },
                      ),
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        incidentAngle: _incidentAngle,
                        refractiveIndex: _refractiveIndex,
                        prismRefractiveIndex: _prismRefractiveIndex,
                        incidentHeight: _incidentHeight,
                        pointer: _pointer,
                        onPointerChanged: (value) {
                          setState(() {
                            _pointer = value;
                            _incidentHeight = value.dy.clamp(0.2, 0.8);
                          });
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

class _ControlRail extends StatelessWidget {
  const _ControlRail({
    required this.experiments,
    required this.activeExperiment,
    required this.incidentAngle,
    required this.refractiveIndex,
    required this.prismRefractiveIndex,
    required this.onExperimentSelected,
    required this.onIncidentAngleChanged,
    required this.onRefractiveIndexChanged,
    required this.onPrismRefractiveIndexChanged,
  });

  final List<Class11Experiment> experiments;
  final Class11Experiment activeExperiment;
  final double incidentAngle;
  final double refractiveIndex;
  final double prismRefractiveIndex;
  final ValueChanged<Class11Experiment> onExperimentSelected;
  final ValueChanged<double> onIncidentAngleChanged;
  final ValueChanged<double> onRefractiveIndexChanged;
  final ValueChanged<double> onPrismRefractiveIndexChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final criticalAngle = math.asin(1 / refractiveIndex) * 180 / math.pi;

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
              'Start with ray optics. Build intuition for critical angle, prisms, and lenses.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            for (final experiment in experiments) ...[
              _ExperimentTile(
                experiment: experiment,
                active: activeExperiment.id == experiment.id,
                onTap: () => onExperimentSelected(experiment),
              ),
              const SizedBox(height: 12),
            ],
            if (activeExperiment.id == 'tir') ...[
              const SizedBox(height: 24),
              Text('Live Controls', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              Text('Incident Angle', style: theme.textTheme.titleMedium),
              Slider(
                min: 0,
                max: 89,
                value: incidentAngle,
                onChanged: onIncidentAngleChanged,
              ),
              Text(
                '${incidentAngle.toStringAsFixed(1)}° from the normal',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text('Water Refractive Index', style: theme.textTheme.titleMedium),
              Slider(
                min: 1.20,
                max: 1.80,
                value: refractiveIndex,
                onChanged: onRefractiveIndexChanged,
              ),
              Text(
                'n1 (water) = ${refractiveIndex.toStringAsFixed(2)}   |   critical angle ≈ ${criticalAngle.toStringAsFixed(1)}°',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (activeExperiment.id == 'prism') ...[
              const SizedBox(height: 24),
              Text('Prism Controls', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              Text('Glass Refractive Index', style: theme.textTheme.titleMedium),
              Slider(
                min: 1.40,
                max: 1.80,
                value: prismRefractiveIndex,
                onChanged: onPrismRefractiveIndexChanged,
              ),
              Text(
                'n (glass) = ${prismRefractiveIndex.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Move mouse vertically to change light entry point',
                style: theme.textTheme.bodySmall,
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
                    'Did You Know?',
                    style: theme.textTheme.labelMedium?.copyWith(color: activeExperiment.accent),
                  ),
                  const SizedBox(height: 8),
                  Text(activeExperiment.fact, style: theme.textTheme.bodyMedium),
                ],
              ),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    experiment.title,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (!experiment.enabled)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECE7FB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'NEXT',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ),
              ],
            ),
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
    required this.incidentAngle,
    required this.refractiveIndex,
    required this.prismRefractiveIndex,
    required this.incidentHeight,
    required this.pointer,
    required this.onPointerChanged,
  });

  final Class11Experiment experiment;
  final double incidentAngle;
  final double refractiveIndex;
  final double prismRefractiveIndex;
  final double incidentHeight;
  final Offset pointer;
  final ValueChanged<Offset> onPointerChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MouseRegion(
            onHover: (event) {
              final box = context.findRenderObject() as RenderBox?;
              if (box == null || box.size.isEmpty) return;
              final local = box.globalToLocal(event.position);
              onPointerChanged(
                Offset(
                  (local.dx / box.size.width).clamp(0.0, 1.0),
                  (local.dy / box.size.height).clamp(0.0, 1.0),
                ),
              );
            },
            child: CustomPaint(
              painter: _ExperimentPainter(
                experimentId: experiment.id,
                incidentAngle: incidentAngle,
                refractiveIndex: refractiveIndex,
                prismRefractiveIndex: prismRefractiveIndex,
                incidentHeight: incidentHeight,
                pointer: pointer,
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
              title: 'Did You Know?',
              accent: experiment.accent,
              body: experiment.fact,
            ),
          ),
        ),
        Positioned(
          right: 24,
          top: 24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: _OverlayCard(
              title: 'Live Readout',
              accent: experiment.accent,
              body: _getReadout(),
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: _OverlayCard(
            title: 'Live Observation',
            accent: experiment.accent,
            body: _getObservation(),
          ),
        ),
      ],
    );
  }

  String _getReadout() {
    if (experiment.id == 'tir') {
      final criticalAngle = math.asin(1 / refractiveIndex) * 180 / math.pi;
      return 'Angle of incidence (i): ${incidentAngle.toStringAsFixed(1)}°\nCritical angle (ic): ${criticalAngle.toStringAsFixed(1)}°\nState: ${_getState()}';
    } else if (experiment.id == 'prism') {
      return 'Refractive index: ${prismRefractiveIndex.toStringAsFixed(2)}\nLight entry: ${(incidentHeight * 100).toStringAsFixed(0)}% height';
    } else if (experiment.id == 'lens') {
      return 'Lens type: Convex (Converging)\nObject distance: adjustable\nImage: real & inverted';
    }
    return '';
  }

  String _getState() {
    final criticalAngle = math.asin(1 / refractiveIndex) * 180 / math.pi;
    final gap = (incidentAngle - criticalAngle).abs();
    if (gap < 1.5) return 'Critical Angle';
    if (incidentAngle > criticalAngle) return 'Total Internal Reflection';
    return 'Refraction';
  }

  String _getObservation() {
    if (experiment.id == 'tir') {
      final criticalAngle = math.asin(1 / refractiveIndex) * 180 / math.pi;
      final gap = (incidentAngle - criticalAngle).abs();
      if (gap < 1.5) {
        return 'At the critical angle (${criticalAngle.toStringAsFixed(1)}°), the refracted ray travels along the boundary (90°).';
      }
      if (incidentAngle > criticalAngle) {
        return 'The angle (${incidentAngle.toStringAsFixed(1)}°) > critical (${criticalAngle.toStringAsFixed(1)}°). Complete reflection!';
      }
      return 'Light bends away from the normal. Angle of incidence > Angle of refraction.';
    } else if (experiment.id == 'prism') {
      return 'White light separates into VIBGYOR. Violet bends most, red bends least. This is dispersion!';
    } else if (experiment.id == 'lens') {
      return 'Convex lens: rays converge at focal point. Image is real and inverted when object is beyond focal length.';
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

class _ExperimentPainter extends CustomPainter {
  _ExperimentPainter({
    required this.experimentId,
    required this.incidentAngle,
    required this.refractiveIndex,
    required this.prismRefractiveIndex,
    required this.incidentHeight,
    required this.pointer,
  });

  final String experimentId;
  final double incidentAngle;
  final double refractiveIndex;
  final double prismRefractiveIndex;
  final double incidentHeight;
  final Offset pointer;

  @override
  void paint(Canvas canvas, Size size) {
    switch (experimentId) {
      case 'tir':
        _drawTirExperiment(canvas, size);
        break;
      case 'prism':
        _drawPrismExperiment(canvas, size);
        break;
      case 'lens':
        _drawLensExperiment(canvas, size);
        break;
    }
  }

  void _drawTirExperiment(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF8FBFF), Color(0xFFF7F0E6)],
    ).createShader(rect);
    canvas.drawRect(rect, background..shader = background);

    final boundaryY = size.height * 0.44;
    final hitPoint = Offset(size.width * 0.55, boundaryY);

    final airPaint = Paint()..color = const Color(0xFFEAF3FF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, boundaryY), airPaint);

    final waterPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF86D7C8), Color(0xFF0F766E)],
      ).createShader(Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY));
    canvas.drawRect(
      Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY),
      waterPaint,
    );

    canvas.drawLine(
      Offset(0, boundaryY),
      Offset(size.width, boundaryY),
      Paint()..color = const Color(0xFFF9FAFB)..strokeWidth = 3,
    );

    canvas.drawLine(
      Offset(hitPoint.dx, boundaryY - 180),
      Offset(hitPoint.dx, boundaryY + 220),
      Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 2,
    );

    _drawLabel(canvas, 'AIR  n = 1.00', Offset(28, boundaryY - 34), const Color(0xFF64748B));
    _drawLabel(canvas, 'WATER  n = ${refractiveIndex.toStringAsFixed(2)}', Offset(28, boundaryY + 18), Colors.white);

    final incidentRadians = incidentAngle * math.pi / 180;
    final source = Offset(
      hitPoint.dx - math.sin(incidentRadians) * 260,
      hitPoint.dy + math.cos(incidentRadians) * 260,
    );

    canvas.drawLine(
      source,
      hitPoint,
      Paint()
        ..color = const Color(0xFFF97316).withValues(alpha: 0.24)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      source,
      hitPoint,
      Paint()
        ..color = const Color(0xFFF97316)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    _drawLabel(canvas, 'Incident Ray', Offset((source.dx + hitPoint.dx) / 2 - 52, (source.dy + hitPoint.dy) / 2 + 12), const Color(0xFFF97316));

    final criticalAngle = math.asin(1 / refractiveIndex) * 180 / math.pi;
    final gap = (incidentAngle - criticalAngle).abs();

    if (gap >= 1.5 && incidentAngle <= criticalAngle) {
      final refractedRadians = math.asin((1 / refractiveIndex) * math.sin(incidentRadians));
      final refractedEnd = Offset(
        hitPoint.dx + math.sin(refractedRadians) * 280,
        hitPoint.dy - math.cos(refractedRadians) * 280,
      );
      canvas.drawLine(
        hitPoint,
        refractedEnd,
        Paint()
          ..color = const Color(0xFF60A5FA).withValues(alpha: 0.26)
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawLine(
        hitPoint,
        refractedEnd,
        Paint()
          ..color = const Color(0xFF2563EB)
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      _drawLabel(canvas, 'Refracted Ray', Offset((hitPoint.dx + refractedEnd.dx) / 2 + 12, (hitPoint.dy + refractedEnd.dy) / 2 - 10), const Color(0xFF2563EB));
      _drawAngleArc(canvas, hitPoint, 56, -math.pi / 2, incidentRadians, const Color(0xFFF97316), 'i');
      _drawAngleArc(canvas, hitPoint, 78, -math.pi / 2, -refractedRadians, const Color(0xFF2563EB), 'r');
    } else {
      final reflectedEnd = Offset(
        hitPoint.dx + math.sin(incidentRadians) * 260,
        hitPoint.dy + math.cos(incidentRadians) * 260,
      );
      canvas.drawLine(
        hitPoint,
        reflectedEnd,
        Paint()
          ..color = const Color(0xFFFDE047).withValues(alpha: 0.26)
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawLine(
        hitPoint,
        reflectedEnd,
        Paint()
          ..color = const Color(0xFFFDE047)
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      _drawLabel(canvas, 'Reflected Ray', Offset((hitPoint.dx + reflectedEnd.dx) / 2 + 12, (hitPoint.dy + reflectedEnd.dy) / 2 + 14), const Color(0xFFFDE047));
      _drawAngleArc(canvas, hitPoint, 56, -math.pi / 2, incidentRadians, const Color(0xFFF97316), 'i');
      _drawAngleArc(canvas, hitPoint, 78, math.pi / 2, -incidentRadians, const Color(0xFFFDE047), "i'");

      if (gap < 1.5) {
        canvas.drawLine(
          hitPoint,
          Offset(size.width - 70, boundaryY),
          Paint()
            ..color = const Color(0xFF93C5FD)
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round,
        );
        _drawLabel(canvas, 'Critical Ray (r = 90°)', Offset(hitPoint.dx + 18, boundaryY - 18), const Color(0xFF2563EB));
      }
    }

    canvas.drawCircle(hitPoint, 6, Paint()..color = Colors.white);
  }

  void _drawPrismExperiment(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = background);

    final cx = size.width * 0.35;
    final cy = size.height * 0.5;
    final prismSize = math.min(size.width, size.height) * 0.32;

    final path = Path()
      ..moveTo(cx, cy - prismSize)
      ..lineTo(cx + prismSize * 0.866, cy + prismSize * 0.5)
      ..lineTo(cx - prismSize * 0.866, cy + prismSize * 0.5)
      ..close();

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.08),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF0EA5E9).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final entryY = size.height * incidentHeight;
    final entryX = size.width * 0.08;
    final hitX = cx - prismSize * 0.4;
    final hitY = cy + (entryY - size.height / 2) * 0.4;

    final whiteLight = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.9),
          Colors.white.withValues(alpha: 0.6),
        ],
      ).createShader(Rect.fromPoints(Offset(entryX, entryY), Offset(hitX, hitY)));
    canvas.drawLine(
      Offset(entryX, entryY),
      Offset(hitX, hitY),
      Paint()
        ..shader = whiteLight
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(entryX, entryY), 8, Paint()..color = Colors.white);

    final rainbowColors = [
      const Color(0xFFFF0000),
      const Color(0xFFFF7F00),
      const Color(0xFFFFFF00),
      const Color(0xFF00FF00),
      const Color(0xFF0000FF),
      const Color(0xFF4B0082),
      const Color(0xFF9400D3),
    ];

    for (int i = 0; i < rainbowColors.length; i++) {
      final colorN = prismRefractiveIndex + (i * 0.012);
      final angleIn = 30.0 * math.pi / 180;
      final angleInternal = math.asin(math.sin(angleIn) / colorN);

      final internalEndX = cx + prismSize * 0.35;
      final internalEndY = hitY + math.tan(angleInternal - 15 * math.pi / 180) * (internalEndX - hitX) * 0.8;

      canvas.drawLine(
        Offset(hitX, hitY),
        Offset(internalEndX, internalEndY.clamp(cy - prismSize * 0.6, cy + prismSize * 0.3)),
        Paint()
          ..color = rainbowColors[i].withValues(alpha: 0.5)
          ..strokeWidth = 2,
      );

      final angleExit = math.asin(math.sin(angleInternal) * colorN);
      final exitAngle = angleExit - 15 * math.pi / 180;
      final exitEndX = size.width * 0.85;
      final exitEndY = internalEndY + math.tan(exitAngle) * (exitEndX - internalEndX);

      canvas.drawLine(
        Offset(internalEndX, internalEndY.clamp(cy - prismSize * 0.6, cy + prismSize * 0.3)),
        Offset(exitEndX, exitEndY.clamp(size.height * 0.1, size.height * 0.9)),
        Paint()
          ..color = rainbowColors[i]
          ..strokeWidth = 3
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }

    _drawLabel(canvas, 'WHITE LIGHT', Offset(entryX - 60, entryY - 40), Colors.white70);
    _drawLabel(canvas, 'PRISM', Offset(cx - 25, cy - prismSize - 25), const Color(0xFF0EA5E9));
    _drawLabel(canvas, 'DISPERSION', Offset(size.width * 0.55, size.height * 0.15), const Color(0xFFFF6B6B));

    final legendY = size.height * 0.75;
    final colors = ['R', 'O', 'Y', 'G', 'B', 'I', 'V'];
    for (int i = 0; i < 7; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.4 + i * 35, legendY),
        8,
        Paint()..color = rainbowColors[i],
      );
      _drawLabel(canvas, colors[i], Offset(size.width * 0.4 + i * 35 - 4, legendY + 15), rainbowColors[i]);
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset position, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, position);
  }

  void _drawAngleArc(Canvas canvas, Offset center, double radius, double start, double sweep, Color color, String label) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    final midAngle = start + sweep / 2;
    final labelPos = Offset(
      center.dx + math.cos(midAngle) * (radius + 10),
      center.dy + math.sin(midAngle) * (radius + 10),
    );
    _drawLabel(canvas, label, labelPos, color);
  }

  void _drawLensExperiment(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF8FBFF), Color(0xFFEEF2FF)],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = background);

    final cx = size.width / 2;
    final cy = size.height / 2;
    final lensHeight = size.height * 0.5;
    final lensWidth = 20.0;
    final focalLength = size.width * 0.2;

    final principalAxis = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, cy),
      Offset(size.width, cy),
      principalAxis,
    );

    final lensPath = Path()
      ..moveTo(cx - lensWidth / 2, cy - lensHeight / 2)
      ..quadraticBezierTo(cx + lensWidth, cy, cx - lensWidth / 2, cy + lensHeight / 2)
      ..quadraticBezierTo(cx - lensWidth, cy, cx - lensWidth / 2, cy - lensHeight / 2);

    canvas.drawPath(
      lensPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF60A5FA), Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: lensWidth, height: lensHeight.toInt()))
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      lensPath,
      Paint()
        ..color = const Color(0xFF2563EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final focalPointLeft = Offset(cx - focalLength, cy);
    final focalPointRight = Offset(cx + focalLength, cy);

    canvas.drawCircle(focalPointLeft, 6, Paint()..color = const Color(0xFFEF4444));
    canvas.drawCircle(focalPointRight, 6, Paint()..color = const Color(0xFFEF4444));

    final objectX = size.width * 0.18;
    final objectY = cy - lensHeight * 0.25;
    final arrowPath = Path()
      ..moveTo(objectX, objectY + 40)
      ..lineTo(objectX, objectY)
      ..lineTo(objectX - 10, objectY + 15)
      ..moveTo(objectX, objectY)
      ..lineTo(objectX + 10, objectY + 15);
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = const Color(0xFF059669)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final ray1End = Offset(cx, objectY);
    canvas.drawLine(
      Offset(objectX, objectY),
      ray1End,
      Paint()
        ..color = const Color(0xFF059669).withValues(alpha: 0.3)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(objectX, objectY),
      ray1End,
      Paint()
        ..color = const Color(0xFF059669)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      ray1End,
      focalPointRight,
      Paint()
        ..color = const Color(0xFF059669).withValues(alpha: 0.3)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      ray1End,
      focalPointRight,
      Paint()
        ..color = const Color(0xFF059669)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    final ray2Start = Offset(objectX, objectY);
    final ray2LensY = cy + (objectY - cy) * (cx - objectX) / (cx - objectX);
    final ray2Through = Offset(cx, objectY);
    canvas.drawLine(
      ray2Start,
      ray2Through,
      Paint()
        ..color = const Color(0xFF059669).withValues(alpha: 0.3)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      ray2Start,
      ray2Through,
      Paint()
        ..color = const Color(0xFF059669)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      ray2Through,
      focalPointRight,
      Paint()
        ..color = const Color(0xFF059669).withValues(alpha: 0.3)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      ray2Through,
      focalPointRight,
      Paint()
        ..color = const Color(0xFF059669)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    final imageX = cx + focalLength * 0.8;
    final imageY = cy + (objectY - cy) * (focalLength * 0.8) / focalLength;
    final imageArrowPath = Path()
      ..moveTo(imageX, imageY + 30)
      ..lineTo(imageX, imageY)
      ..lineTo(imageX - 8, imageY + 12)
      ..moveTo(imageX, imageY)
      ..lineTo(imageX + 8, imageY + 12);
    canvas.drawPath(
      imageArrowPath,
      Paint()
        ..color = const Color(0xFFDC2626)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      Offset(objectX, objectY),
      Offset(imageX, imageY),
      Paint()
        ..color = const Color(0xFFDC2626).withValues(alpha: 0.3)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    _drawLabel(canvas, 'OBJECT', Offset(objectX - 25, objectY + 50), const Color(0xFF059669));
    _drawLabel(canvas, 'IMAGE', Offset(imageX - 20, imageY + 45), const Color(0xFFDC2626));
    _drawLabel(canvas, 'F', Offset(focalPointLeft.dx - 8, focalPointLeft.dy + 15), const Color(0xFFEF4444));
    _drawLabel(canvas, 'F', Offset(focalPointRight.dx - 8, focalPointRight.dy + 15), const Color(0xFFEF4444));
    _drawLabel(canvas, 'CONVEX LENS', Offset(cx - 45, cy - lensHeight / 2 - 20), const Color(0xFF2563EB));
    _drawLabel(canvas, 'Real Inverted Image', Offset(imageX - 55, size.height - 40), const Color(0xFFDC2626));
  }

  @override
  bool shouldRepaint(covariant _ExperimentPainter oldDelegate) {
    return oldDelegate.experimentId != experimentId ||
        oldDelegate.incidentAngle != incidentAngle ||
        oldDelegate.refractiveIndex != refractiveIndex ||
        oldDelegate.prismRefractiveIndex != prismRefractiveIndex ||
        oldDelegate.incidentHeight != incidentHeight ||
        oldDelegate.pointer != pointer;
  }
}
