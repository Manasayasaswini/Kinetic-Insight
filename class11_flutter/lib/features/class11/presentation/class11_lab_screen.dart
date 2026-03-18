import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class11_experiment.dart';

class Class11LabPreviewCard extends StatelessWidget {
  const Class11LabPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(height: 760, child: const Class11LabScreen()),
    );
  }
}

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
          'Change the angle to see refraction, critical angle, and total internal reflection.',
      observation:
          'Below the critical angle, some light escapes into air. At the critical angle it skims the surface, and beyond it the ray reflects completely inside the denser medium.',
      fact:
          'Fiber optic cables work because light keeps undergoing total internal reflection inside a denser medium.',
      accent: Color(0xFF0F766E),
    ),
    Class11Experiment(
      id: 'prism',
      title: 'Experiment 2: Prism Dispersion',
      subtitle:
          'White light separates into colors because each wavelength bends differently.',
      observation:
          'Coming next: build the prism stage where deviation and dispersion can be explored together.',
      fact:
          'A prism is not making colors from nothing. It is separating the colors already present in white light.',
      accent: Color(0xFF7C3AED),
      enabled: false,
    ),
    Class11Experiment(
      id: 'lens',
      title: 'Experiment 3: Lens & Image Formation',
      subtitle:
          'Trace how curved surfaces focus light into real or virtual images.',
      observation:
          'Coming next: use curved refracting surfaces to build toward lenses and optical instruments.',
      fact:
          'Lens design connects refraction, curvature, and image distance into one powerful model.',
      accent: Color(0xFFC97D10),
      enabled: false,
    ),
  ];

  late Class11Experiment _activeExperiment = _experiments.first;
  double _incidentAngle = 44;
  double _refractiveIndex = 1.52;
  Offset _pointer = const Offset(0.52, 0.34);

  void _setExperiment(Class11Experiment experiment) {
    if (!experiment.enabled) return;
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
                      onExperimentSelected: _setExperiment,
                      onIncidentAngleChanged: (value) {
                        setState(() => _incidentAngle = value);
                      },
                      onRefractiveIndexChanged: (value) {
                        setState(() => _refractiveIndex = value);
                      },
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        incidentAngle: _incidentAngle,
                        refractiveIndex: _refractiveIndex,
                        pointer: _pointer,
                        onPointerChanged: (value) {
                          setState(() => _pointer = value);
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
                        onExperimentSelected: _setExperiment,
                        onIncidentAngleChanged: (value) {
                          setState(() => _incidentAngle = value);
                        },
                        onRefractiveIndexChanged: (value) {
                          setState(() => _refractiveIndex = value);
                        },
                      ),
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        incidentAngle: _incidentAngle,
                        refractiveIndex: _refractiveIndex,
                        pointer: _pointer,
                        onPointerChanged: (value) {
                          setState(() => _pointer = value);
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
    required this.onExperimentSelected,
    required this.onIncidentAngleChanged,
    required this.onRefractiveIndexChanged,
  });

  final List<Class11Experiment> experiments;
  final Class11Experiment activeExperiment;
  final double incidentAngle;
  final double refractiveIndex;
  final ValueChanged<Class11Experiment> onExperimentSelected;
  final ValueChanged<double> onIncidentAngleChanged;
  final ValueChanged<double> onRefractiveIndexChanged;

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
              'Start with ray optics. Build intuition for critical angle and total internal reflection before moving to prisms and lenses.',
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
              child: Text(
                activeExperiment.fact,
                style: theme.textTheme.bodyMedium,
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
    required this.pointer,
    required this.onPointerChanged,
  });

  final Class11Experiment experiment;
  final double incidentAngle;
  final double refractiveIndex;
  final Offset pointer;
  final ValueChanged<Offset> onPointerChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = _RayState.fromAngle(
      incidentAngle: incidentAngle,
      refractiveIndex: refractiveIndex,
    );

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
              painter: _TirExperimentPainter(
                experiment: experiment,
                incidentAngle: incidentAngle,
                refractiveIndex: refractiveIndex,
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
              title: 'Quick Fact',
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
              body:
                  'theta1: ${incidentAngle.toStringAsFixed(1)}°\nCritical angle: ${state.criticalAngle.toStringAsFixed(1)}°\nState: ${state.label}',
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
            body: state.observation,
          ),
        ),
      ],
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

class _TirExperimentPainter extends CustomPainter {
  const _TirExperimentPainter({
    required this.experiment,
    required this.incidentAngle,
    required this.refractiveIndex,
    required this.pointer,
  });

  final Class11Experiment experiment;
  final double incidentAngle;
  final double refractiveIndex;
  final Offset pointer;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF8FBFF), Color(0xFFF7F0E6)],
      ).createShader(rect);
    canvas.drawRect(rect, background);

    final boundaryY = size.height * 0.44;
    final hitPoint = Offset(size.width * 0.55, boundaryY);
    final state = _RayState.fromAngle(
      incidentAngle: incidentAngle,
      refractiveIndex: refractiveIndex,
    );

    final airPaint = Paint()..color = const Color(0xFFEAF3FF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, boundaryY), airPaint);

    final waterPaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF86D7C8), Color(0xFF0F766E)],
          ).createShader(
            Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY),
          );
    canvas.drawRect(
      Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY),
      waterPaint,
    );

    final highlight = Paint()..color = Colors.white.withValues(alpha: 0.08);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.08,
        boundaryY + 18,
        size.width * 0.22,
        size.height * 0.42,
      ),
      highlight,
    );

    final boundaryPaint = Paint()
      ..color = const Color(0xFFF9FAFB)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, boundaryY),
      Offset(size.width, boundaryY),
      boundaryPaint,
    );

    final normalPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2;
    _drawDashedLine(
      canvas,
      Offset(hitPoint.dx, boundaryY - 180),
      Offset(hitPoint.dx, boundaryY + 220),
      8,
      8,
      normalPaint,
    );

    final mediumLabelStyle = TextPainter(textDirection: TextDirection.ltr);
    mediumLabelStyle.text = const TextSpan(
      text: 'AIR  n = 1.00',
      style: TextStyle(
        color: Color(0xFF64748B),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
    mediumLabelStyle.layout();
    mediumLabelStyle.paint(canvas, Offset(28, boundaryY - 34));

    mediumLabelStyle.text = TextSpan(
      text: 'WATER  n = ${refractiveIndex.toStringAsFixed(2)}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
    mediumLabelStyle.layout();
    mediumLabelStyle.paint(canvas, Offset(28, boundaryY + 18));

    final pointerOffset = Offset(
      (pointer.dx - 0.5) * 18,
      (pointer.dy - 0.5) * 16,
    );
    final source = Offset(
      hitPoint.dx - math.sin(state.incidentRadians) * 260 + pointerOffset.dx,
      hitPoint.dy + math.cos(state.incidentRadians) * 260 + pointerOffset.dy,
    );

    final incomingPaint = Paint()
      ..color = const Color(0xFFF97316)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(source, hitPoint, incomingPaint);

    final glowPaint = Paint()
      ..color = const Color(0xFFF97316).withValues(alpha: 0.24)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(source, hitPoint, glowPaint);
    _drawRayLabel(
      canvas,
      text: 'Incident Ray',
      position: Offset(
        (source.dx + hitPoint.dx) / 2 - 26,
        (source.dy + hitPoint.dy) / 2 + 12,
      ),
      color: const Color(0xFFF97316),
    );

    if (state.mode == _RayMode.refract) {
      final refractedEnd = Offset(
        hitPoint.dx + math.sin(state.refractedRadians!) * 280,
        hitPoint.dy - math.cos(state.refractedRadians!) * 280,
      );
      final refractedPaint = Paint()
        ..color = const Color(0xFF2563EB)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      final refractedGlow = Paint()
        ..color = const Color(0xFF60A5FA).withValues(alpha: 0.26)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(hitPoint, refractedEnd, refractedGlow);
      canvas.drawLine(hitPoint, refractedEnd, refractedPaint);
      _drawRayLabel(
        canvas,
        text: 'Refracted Ray',
        position: Offset(
          (hitPoint.dx + refractedEnd.dx) / 2 + 12,
          (hitPoint.dy + refractedEnd.dy) / 2 - 10,
        ),
        color: const Color(0xFF2563EB),
      );
      _drawAngleArc(
        canvas,
        center: hitPoint,
        radius: 56,
        start: -math.pi / 2,
        sweep: state.incidentRadians,
        color: const Color(0xFFF97316),
        label: 'theta1',
      );
      _drawAngleArc(
        canvas,
        center: hitPoint,
        radius: 78,
        start: -math.pi / 2,
        sweep: -state.refractedRadians!,
        color: const Color(0xFF2563EB),
        label: 'theta2',
      );
    } else {
      final reflectedEnd = Offset(
        hitPoint.dx - math.sin(state.incidentRadians) * 260,
        hitPoint.dy + math.cos(state.incidentRadians) * 260,
      );
      final reflectedPaint = Paint()
        ..color = const Color(0xFFFDE047)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      final reflectedGlow = Paint()
        ..color = const Color(0xFFFDE047).withValues(alpha: 0.26)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(hitPoint, reflectedEnd, reflectedGlow);
      canvas.drawLine(hitPoint, reflectedEnd, reflectedPaint);
      _drawRayLabel(
        canvas,
        text: 'Reflected Ray',
        position: Offset(
          (hitPoint.dx + reflectedEnd.dx) / 2 - 2,
          (hitPoint.dy + reflectedEnd.dy) / 2 + 14,
        ),
        color: const Color(0xFFFDE047),
      );
      _drawAngleArc(
        canvas,
        center: hitPoint,
        radius: 56,
        start: -math.pi / 2,
        sweep: state.incidentRadians,
        color: const Color(0xFFF97316),
        label: 'theta1',
      );
      _drawAngleArc(
        canvas,
        center: hitPoint,
        radius: 78,
        start: math.pi / 2,
        sweep: -state.incidentRadians,
        color: const Color(0xFFFDE047),
        label: 'theta2',
      );

      if (state.mode == _RayMode.critical) {
        final grazingPaint = Paint()
          ..color = const Color(0xFF93C5FD)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          hitPoint,
          Offset(size.width - 70, boundaryY),
          grazingPaint,
        );
        _drawRayLabel(
          canvas,
          text: 'Critical Refraction (r = 90°)',
          position: Offset(hitPoint.dx + 18, boundaryY - 18),
          color: const Color(0xFF2563EB),
        );
      }
    }

    final hitPaint = Paint()..color = Colors.white;
    canvas.drawCircle(hitPoint, 6, hitPaint);
  }

  void _drawRayLabel(
    Canvas canvas, {
    required String text,
    required Offset position,
    required Color color,
  }) {
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

  void _drawAngleArc(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double start,
    required double sweep,
    required Color color,
    required String label,
  }) {
    final arcPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      arcPaint,
    );
    final midAngle = start + sweep / 2;
    final labelPos = Offset(
      center.dx + math.cos(midAngle) * (radius + 10),
      center.dy + math.sin(midAngle) * (radius + 10),
    );
    _drawRayLabel(canvas, text: label, position: labelPos, color: color);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    double dash,
    double gap,
    Paint paint,
  ) {
    final totalLength = (end - start).distance;
    final direction = (end - start) / totalLength;
    double drawn = 0;
    while (drawn < totalLength) {
      final from = start + direction * drawn;
      final to = start + direction * math.min(drawn + dash, totalLength);
      canvas.drawLine(from, to, paint);
      drawn += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _TirExperimentPainter oldDelegate) {
    return oldDelegate.experiment != experiment ||
        oldDelegate.incidentAngle != incidentAngle ||
        oldDelegate.refractiveIndex != refractiveIndex ||
        oldDelegate.pointer != pointer;
  }
}

enum _RayMode { refract, critical, tir }

class _RayState {
  const _RayState({
    required this.incidentRadians,
    required this.criticalAngle,
    required this.mode,
    required this.label,
    required this.observation,
    this.refractedRadians,
  });

  final double incidentRadians;
  final double criticalAngle;
  final _RayMode mode;
  final String label;
  final String observation;
  final double? refractedRadians;

  factory _RayState.fromAngle({
    required double incidentAngle,
    required double refractiveIndex,
  }) {
    final incidentRadians = incidentAngle * math.pi / 180;
    final criticalRadians = math.asin(1 / refractiveIndex);
    final criticalAngle = criticalRadians * 180 / math.pi;
    final gap = (incidentAngle - criticalAngle).abs();

    if (gap < 1.5) {
      return _RayState(
        incidentRadians: incidentRadians,
        criticalAngle: criticalAngle,
        mode: _RayMode.critical,
        label: 'Critical Angle',
        observation:
            'The incident angle is almost equal to the critical angle, so the refracted ray grazes along the boundary instead of entering air cleanly.',
      );
    }

    if (incidentAngle > criticalAngle) {
      return _RayState(
        incidentRadians: incidentRadians,
        criticalAngle: criticalAngle,
        mode: _RayMode.tir,
        label: 'Total Internal Reflection',
        observation:
            'The angle is greater than the critical angle. No light escapes into air, so the entire ray reflects back inside the water.',
      );
    }

    final refractedRadians = math.asin(
      refractiveIndex * math.sin(incidentRadians),
    );
    return _RayState(
      incidentRadians: incidentRadians,
      criticalAngle: criticalAngle,
      mode: _RayMode.refract,
      label: 'Refraction',
      refractedRadians: refractedRadians,
      observation:
          'The incident angle is below the critical angle, so part of the light refracts into air and bends away from the normal.',
    );
  }
}
