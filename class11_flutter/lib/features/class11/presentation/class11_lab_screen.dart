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
  double _prismAngleA = 60;
  double _deviationAngle = 40;
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
                      prismAngleA: _prismAngleA,
                      deviationAngle: _deviationAngle,
                      onExperimentSelected: _setExperiment,
                      onIncidentAngleChanged: (value) => setState(() => _incidentAngle = value),
                      onRefractiveIndexChanged: (value) => setState(() => _refractiveIndex = value),
                      onPrismRefractiveIndexChanged: (value) => setState(() => _prismRefractiveIndex = value),
                      onPrismAngleChanged: (value) => setState(() => _prismAngleA = value),
                      onDeviationAngleChanged: (value) => setState(() => _deviationAngle = value),
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        incidentAngle: _incidentAngle,
                        refractiveIndex: _refractiveIndex,
                        prismRefractiveIndex: _prismRefractiveIndex,
                        prismAngleA: _prismAngleA,
                        deviationAngle: _deviationAngle,
                        incidentHeight: _incidentHeight,
                        pointer: _pointer,
                        onPointerChanged: (value) => setState(() {
                          _pointer = value;
                          _incidentHeight = value.dy.clamp(0.2, 0.8);
                        }),
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
                        prismAngleA: _prismAngleA,
                        deviationAngle: _deviationAngle,
                        onExperimentSelected: _setExperiment,
                        onIncidentAngleChanged: (value) => setState(() => _incidentAngle = value),
                        onRefractiveIndexChanged: (value) => setState(() => _refractiveIndex = value),
                        onPrismRefractiveIndexChanged: (value) => setState(() => _prismRefractiveIndex = value),
                        onPrismAngleChanged: (value) => setState(() => _prismAngleA = value),
                        onDeviationAngleChanged: (value) => setState(() => _deviationAngle = value),
                      ),
                    ),
                    Expanded(
                      child: _StageArea(
                        experiment: _activeExperiment,
                        incidentAngle: _incidentAngle,
                        refractiveIndex: _refractiveIndex,
                        prismRefractiveIndex: _prismRefractiveIndex,
                        prismAngleA: _prismAngleA,
                        deviationAngle: _deviationAngle,
                        incidentHeight: _incidentHeight,
                        pointer: _pointer,
                        onPointerChanged: (value) => setState(() {
                          _pointer = value;
                          _incidentHeight = value.dy.clamp(0.2, 0.8);
                        }),
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
    required this.prismAngleA,
    required this.deviationAngle,
    required this.onExperimentSelected,
    required this.onIncidentAngleChanged,
    required this.onRefractiveIndexChanged,
    required this.onPrismRefractiveIndexChanged,
    required this.onPrismAngleChanged,
    required this.onDeviationAngleChanged,
  });

  final List<Class11Experiment> experiments;
  final Class11Experiment activeExperiment;
  final double incidentAngle;
  final double refractiveIndex;
  final double prismRefractiveIndex;
  final double prismAngleA;
  final double deviationAngle;
  final ValueChanged<Class11Experiment> onExperimentSelected;
  final ValueChanged<double> onIncidentAngleChanged;
  final ValueChanged<double> onRefractiveIndexChanged;
  final ValueChanged<double> onPrismRefractiveIndexChanged;
  final ValueChanged<double> onPrismAngleChanged;
  final ValueChanged<double> onDeviationAngleChanged;

  double _calcRefractiveIndex(double a, double d) {
    final ar = a * math.pi / 180;
    final dr = d * math.pi / 180;
    return math.sin((ar + dr) / 2) / math.sin(ar / 2);
  }

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
            Text('Start with ray optics. Build intuition for critical angle, prisms, and lenses.', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            for (final exp in experiments) ...[
              _ExperimentTile(experiment: exp, active: activeExperiment.id == exp.id, onTap: () => onExperimentSelected(exp)),
              const SizedBox(height: 12),
            ],
            if (activeExperiment.id == 'tir') ...[
              const SizedBox(height: 24),
              Text('Live Controls', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              Text('Incident Angle', style: theme.textTheme.titleMedium),
              Slider(min: 0, max: 89, value: incidentAngle, onChanged: onIncidentAngleChanged),
              Text('${incidentAngle.toStringAsFixed(1)}° from the normal', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text('Water Refractive Index', style: theme.textTheme.titleMedium),
              Slider(min: 1.20, max: 1.80, value: refractiveIndex, onChanged: onRefractiveIndexChanged),
              Text('n1 = ${refractiveIndex.toStringAsFixed(2)} | critical ≈ ${criticalAngle.toStringAsFixed(1)}°', style: theme.textTheme.bodyMedium),
            ],
            if (activeExperiment.id == 'prism') ...[
              const SizedBox(height: 24),
              Text('Prism Parameters', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              Text('Prism Angle (A)', style: theme.textTheme.titleMedium),
              Slider(min: 40, max: 80, value: prismAngleA, onChanged: onPrismAngleChanged),
              Text('A = ${prismAngleA.toStringAsFixed(0)}°', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text('Angle of Deviation (δ)', style: theme.textTheme.titleMedium),
              Slider(min: 20, max: 60, value: deviationAngle, onChanged: onDeviationAngleChanged),
              Text('δ = ${deviationAngle.toStringAsFixed(0)}°', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prism Formula', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('n = sin((A + δ)/2) / sin(A/2)', style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF60A5FA), fontSize: 14)),
                    const SizedBox(height: 8),
                    Text('n = ${_calcRefractiveIndex(prismAngleA, deviationAngle).toStringAsFixed(3)}', style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF34D399), fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: activeExperiment.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: activeExperiment.accent.withValues(alpha: 0.16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Did You Know?', style: theme.textTheme.labelMedium?.copyWith(color: activeExperiment.accent)),
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
  const _ExperimentTile({required this.experiment, required this.active, required this.onTap});
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
          color: active ? experiment.accent.withValues(alpha: 0.12) : const Color(0xFFF8F5EE),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: active ? experiment.accent.withValues(alpha: 0.32) : const Color(0xFFE8DECF)),
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
    required this.incidentAngle,
    required this.refractiveIndex,
    required this.prismRefractiveIndex,
    required this.prismAngleA,
    required this.deviationAngle,
    required this.incidentHeight,
    required this.pointer,
    required this.onPointerChanged,
  });

  final Class11Experiment experiment;
  final double incidentAngle;
  final double refractiveIndex;
  final double prismRefractiveIndex;
  final double prismAngleA;
  final double deviationAngle;
  final double incidentHeight;
  final Offset pointer;
  final ValueChanged<Offset> onPointerChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MouseRegion(
            onHover: (e) {
              final box = context.findRenderObject() as RenderBox?;
              if (box == null) return;
              final local = box.globalToLocal(e.position);
              onPointerChanged(Offset((local.dx / box.size.width).clamp(0.0, 1.0), (local.dy / box.size.height).clamp(0.0, 1.0)));
            },
            child: CustomPaint(
              painter: _ExperimentPainter(
                experimentId: experiment.id,
                incidentAngle: incidentAngle,
                refractiveIndex: refractiveIndex,
                prismRefractiveIndex: prismRefractiveIndex,
                prismAngleA: prismAngleA,
                deviationAngle: deviationAngle,
                incidentHeight: incidentHeight,
                pointer: pointer,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        Positioned(
          top: 24, left: 24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: _OverlayCard(title: 'Did You Know?', accent: experiment.accent, body: experiment.fact),
          ),
        ),
        Positioned(
          right: 24, top: 24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: _OverlayCard(title: 'Live Readout', accent: experiment.accent, body: _getReadout()),
          ),
        ),
        Positioned(
          left: 24, right: 24, bottom: 24,
          child: _OverlayCard(title: 'Live Observation', accent: experiment.accent, body: _getObservation()),
        ),
      ],
    );
  }

  String _getReadout() {
    if (experiment.id == 'tir') {
      final ca = math.asin(1 / refractiveIndex) * 180 / math.pi;
      return 'i = ${incidentAngle.toStringAsFixed(1)}°\nCritical (ic) = ${ca.toStringAsFixed(1)}°\nState: ${_getState()}';
    } else if (experiment.id == 'prism') {
      final calcN = _calcRefractiveIndex(prismAngleA, deviationAngle);
      return 'A = ${prismAngleA.toStringAsFixed(0)}°\nδ = ${deviationAngle.toStringAsFixed(0)}°\nn = ${calcN.toStringAsFixed(3)}';
    }
    return '';
  }

  String _getState() {
    final ca = math.asin(1 / refractiveIndex) * 180 / math.pi;
    final gap = (incidentAngle - ca).abs();
    if (gap < 1.5) return 'Critical';
    if (incidentAngle > ca) return 'TIR';
    return 'Refraction';
  }

  String _getObservation() {
    if (experiment.id == 'tir') {
      final ca = math.asin(1 / refractiveIndex) * 180 / math.pi;
      final gap = (incidentAngle - ca).abs();
      if (gap < 1.5) return 'At critical angle, refracted ray grazes along boundary (90°).';
      if (incidentAngle > ca) return 'Complete reflection! Angle > critical angle.';
      return 'Light bends away from normal. i > r';
    } else if (experiment.id == 'prism') {
      return 'Violet bends most (short λ), Red bends least (long λ). This is dispersion!';
    }
    return experiment.observation;
  }

  double _calcRefractiveIndex(double a, double d) {
    final ar = a * math.pi / 180;
    final dr = d * math.pi / 180;
    return math.sin((ar + dr) / 2) / math.sin(ar / 2);
  }
}

class _OverlayCard extends StatelessWidget {
  const _OverlayCard({required this.title, required this.accent, required this.body});
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
            Text(title, style: theme.textTheme.labelMedium?.copyWith(color: accent)),
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
    required this.prismAngleA,
    required this.deviationAngle,
    required this.incidentHeight,
    required this.pointer,
  });

  final String experimentId;
  final double incidentAngle;
  final double refractiveIndex;
  final double prismRefractiveIndex;
  final double prismAngleA;
  final double deviationAngle;
  final double incidentHeight;
  final Offset pointer;

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
    canvas.drawRect(rect, Paint()..shader = const LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFF7F0E6)]).createShader(rect));

    final boundaryY = size.height * 0.44;
    final hit = Offset(size.width * 0.55, boundaryY);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, boundaryY), Paint()..color = const Color(0xFFEAF3FF));
    canvas.drawRect(Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY), Paint()..shader = const LinearGradient(colors: [Color(0xFF86D7C8), Color(0xFF0F766E)]).createShader(Rect.fromLTWH(0, boundaryY, size.width, size.height - boundaryY)));
    canvas.drawLine(Offset(0, boundaryY), Offset(size.width, boundaryY), Paint()..color = const Color(0xFFF9FAFB)..strokeWidth = 3);
    canvas.drawLine(Offset(hit.dx, boundaryY - 180), Offset(hit.dx, boundaryY + 220), Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 2);

    _drawText(canvas, 'AIR n=1.00', Offset(28, boundaryY - 34), const Color(0xFF64748B));
    _drawText(canvas, 'WATER n=${refractiveIndex.toStringAsFixed(2)}', Offset(28, boundaryY + 18), Colors.white);

    final incRad = incidentAngle * math.pi / 180;
    final source = Offset(hit.dx - math.sin(incRad) * 260, hit.dy + math.cos(incRad) * 260);

    canvas.drawLine(source, hit, Paint()..color = const Color(0xFFF97316)..strokeWidth = 5..strokeCap = StrokeCap.round);
    canvas.drawLine(source, hit, Paint()..color = const Color(0xFFF97316).withValues(alpha: 0.24)..strokeWidth = 12..strokeCap = StrokeCap.round);
    _drawText(canvas, 'Incident', Offset((source.dx + hit.dx) / 2 - 26, (source.dy + hit.dy) / 2 + 12), const Color(0xFFF97316));

    final ca = math.asin(1 / refractiveIndex) * 180 / math.pi;
    final gap = (incidentAngle - ca).abs();

    if (gap >= 1.5 && incidentAngle <= ca) {
      final refrRad = math.asin((1 / refractiveIndex) * math.sin(incRad));
      final end = Offset(hit.dx + math.sin(refrRad) * 280, hit.dy - math.cos(refrRad) * 280);
      canvas.drawLine(hit, end, Paint()..color = const Color(0xFF2563EB)..strokeWidth = 5..strokeCap = StrokeCap.round);
      _drawText(canvas, 'Refracted', Offset((hit.dx + end.dx) / 2 + 12, (hit.dy + end.dy) / 2 - 10), const Color(0xFF2563EB));
      _drawArc(canvas, hit, 56, -math.pi / 2, incRad, const Color(0xFFF97316), 'i');
      _drawArc(canvas, hit, 78, -math.pi / 2, -refrRad, const Color(0xFF2563EB), 'r');
    } else {
      final reflEnd = Offset(hit.dx + math.sin(incRad) * 260, hit.dy + math.cos(incRad) * 260);
      canvas.drawLine(hit, reflEnd, Paint()..color = const Color(0xFFFDE047)..strokeWidth = 5..strokeCap = StrokeCap.round);
      _drawText(canvas, 'Reflected', Offset((hit.dx + reflEnd.dx) / 2 + 12, (hit.dy + reflEnd.dy) / 2 + 14), const Color(0xFFFDE047));
      _drawArc(canvas, hit, 56, -math.pi / 2, incRad, const Color(0xFFF97316), 'i');
      _drawArc(canvas, hit, 78, math.pi / 2, -incRad, const Color(0xFFFDE047), "i'");
      if (gap < 1.5) {
        canvas.drawLine(hit, Offset(size.width - 70, boundaryY), Paint()..color = const Color(0xFF93C5FD)..strokeWidth = 4..strokeCap = StrokeCap.round);
        _drawText(canvas, 'Critical r=90°', Offset(hit.dx + 18, boundaryY - 18), const Color(0xFF2563EB));
      }
    }
    canvas.drawCircle(hit, 6, Paint()..color = Colors.white);
  }

  void _drawPrism(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..shader = const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]).createShader(Offset.zero & size));

    final cx = size.width * 0.35;
    final cy = size.height * 0.5;
    final pSize = math.min(size.width, size.height) * 0.32;
    final aRad = prismAngleA * math.pi / 180;

    final path = Path()..moveTo(cx, cy - pSize)..lineTo(cx + pSize * 0.866, cy + pSize * 0.5)..lineTo(cx - pSize * 0.866, cy + pSize * 0.5)..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.08));
    canvas.drawPath(path, Paint()..color = const Color(0xFF0EA5E9).withValues(alpha: 0.4)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawText(canvas, 'A=${prismAngleA.toStringAsFixed(0)}°', Offset(cx - 40, cy + pSize * 0.6), const Color(0xFF60A5FA));

    final entryY = size.height * incidentHeight;
    final entryX = size.width * 0.08;
    final hitX = cx - pSize * 0.4;
    final hitY = cy + (entryY - size.height / 2) * 0.4;

    canvas.drawLine(Offset(entryX, entryY), Offset(hitX, hitY), Paint()..color = Colors.white..strokeWidth = 8..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(entryX, entryY), 8, Paint()..color = Colors.white);

    final colors = [const Color(0xFFFF0000), const Color(0xFFFF7F00), const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFF0000FF), const Color(0xFF4B0082), const Color(0xFF9400D3)];
    final factors = [1.0, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7];

    for (int i = 0; i < 7; i++) {
      final n = prismRefractiveIndex * factors[i];
      final angIn = aRad / 2;
      final angInt = math.asin(math.sin(angIn) / n);
      final intEndX = cx + pSize * 0.35;
      final intEndY = (hitY + math.tan(angInt - aRad / 2) * (intEndX - hitX) * 0.8).clamp(cy - pSize * 0.6, cy + pSize * 0.3);

      canvas.drawLine(Offset(hitX, hitY), Offset(intEndX, intEndY), Paint()..color = colors[i].withValues(alpha: 0.5)..strokeWidth = 2);

      final devF = deviationAngle / 50.0;
      final angEx = (angInt + devF * (0.7 - i * 0.1)) * n / 1.5;
      final exitX = size.width * 0.85;
      final exitY = (intEndY + math.tan(angEx) * (exitX - intEndX)).clamp(size.height * 0.1, size.height * 0.9);

      canvas.drawLine(Offset(intEndX, intEndY), Offset(exitX, exitY), Paint()..color = colors[i]..strokeWidth = 3..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    }

    canvas.drawLine(Offset(entryX, entryY), Offset(size.width * 0.85, entryY - deviationAngle * 2), Paint()..color = Colors.white.withValues(alpha: 0.15)..strokeWidth = 1);
    _drawText(canvas, 'δ=${deviationAngle.toStringAsFixed(0)}°', Offset(size.width * 0.5, entryY - deviationAngle * 2 - 20), const Color(0xFFFFD700));
    _drawText(canvas, 'WHITE LIGHT', Offset(entryX - 60, entryY - 40), Colors.white70);
    _drawText(canvas, 'PRISM', Offset(cx - 25, cy - pSize - 25), const Color(0xFF0EA5E9));
    _drawText(canvas, 'Since Violet (short λ) slows more → bends more', Offset(size.width * 0.08, size.height * 0.92), const Color(0xFFDDD6FE));
    _drawText(canvas, 'Red (long λ) slows less → bends less', Offset(size.width * 0.08, size.height * 0.97), const Color(0xFFFCA5A5));

    final ly = size.height * 0.75;
    final names = ['R', 'O', 'Y', 'G', 'B', 'I', 'V'];
    for (int i = 0; i < 7; i++) {
      canvas.drawCircle(Offset(size.width * 0.4 + i * 35.0, ly), 8, Paint()..color = colors[i]);
      _drawText(canvas, names[i], Offset(size.width * 0.4 + i * 35.0 - 4, ly + 15), colors[i]);
    }
  }

  void _drawLens(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..shader = const LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFEEF2FF)]).createShader(Offset.zero & size));

    final cx = size.width / 2;
    final cy = size.height / 2;
    final h = size.height * 0.5;
    final f = size.width * 0.2;

    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), Paint()..color = const Color(0xFF64748B)..strokeWidth = 2);

    final lp = Path()..moveTo(cx - 10, cy - h / 2)..quadraticBezierTo(cx + 10, cy, cx - 10, cy + h / 2)..quadraticBezierTo(cx - 10, cy, cx - 10, cy - h / 2);
    canvas.drawPath(lp, Paint()..color = const Color(0xFF3B82F6)..style = PaintingStyle.fill);
    canvas.drawPath(lp, Paint()..color = const Color(0xFF2563EB)..style = PaintingStyle.stroke..strokeWidth = 2);

    canvas.drawCircle(Offset(cx - f, cy), 6, Paint()..color = const Color(0xFFEF4444));
    canvas.drawCircle(Offset(cx + f, cy), 6, Paint()..color = const Color(0xFFEF4444));

    final ox = size.width * 0.18;
    final oy = cy - h * 0.25;
    canvas.drawLine(Offset(ox, oy + 40), Offset(ox, oy), Paint()..color = const Color(0xFF059669)..strokeWidth = 3);
    canvas.drawLine(Offset(ox - 10, oy + 15), Offset(ox, oy), Paint()..color = const Color(0xFF059669)..strokeWidth = 3);
    canvas.drawLine(Offset(ox + 10, oy + 15), Offset(ox, oy), Paint()..color = const Color(0xFF059669)..strokeWidth = 3);

    canvas.drawLine(Offset(ox, oy), Offset(cx, oy), Paint()..color = const Color(0xFF059669).withValues(alpha: 0.3)..strokeWidth = 8..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset(cx, oy), Offset(cx + f, cy), Paint()..color = const Color(0xFF059669)..strokeWidth = 2);

    canvas.drawLine(Offset(ox, oy), Offset(cx, oy), Paint()..color = const Color(0xFF059669).withValues(alpha: 0.3)..strokeWidth = 8..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset(cx, oy), Offset(cx + f, cy), Paint()..color = const Color(0xFF059669)..strokeWidth = 2);

    final ix = cx + f * 0.8;
    final iy = cy + (oy - cy) * 0.8 / f;
    canvas.drawLine(Offset(ix, iy + 30), Offset(ix, iy), Paint()..color = const Color(0xFFDC2626)..strokeWidth = 3);
    canvas.drawLine(Offset(ix - 8, iy + 12), Offset(ix, iy), Paint()..color = const Color(0xFFDC2626)..strokeWidth = 3);
    canvas.drawLine(Offset(ix + 8, iy + 12), Offset(ix, iy), Paint()..color = const Color(0xFFDC2626)..strokeWidth = 3);

    _drawText(canvas, 'OBJECT', Offset(ox - 25, oy + 50), const Color(0xFF059669));
    _drawText(canvas, 'IMAGE', Offset(ix - 20, iy + 45), const Color(0xFFDC2626));
    _drawText(canvas, 'F', Offset(cx - f - 8, cy + 15), const Color(0xFFEF4444));
    _drawText(canvas, 'F', Offset(cx + f - 8, cy + 15), const Color(0xFFEF4444));
    _drawText(canvas, 'CONVEX LENS', Offset(cx - 45, cy - h / 2 - 20), const Color(0xFF2563EB));
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)), textDirection: TextDirection.ltr)..layout()..paint(canvas, pos);
  }

  void _drawArc(Canvas canvas, Offset c, double r, double s, double sw, Color clr, String lbl) {
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), s, sw, false, Paint()..color = clr..strokeWidth = 2..style = PaintingStyle.stroke);
    final ma = s + sw / 2;
    _drawText(canvas, lbl, Offset(c.dx + math.cos(ma) * (r + 10), c.dy + math.sin(ma) * (r + 10)), clr);
  }

  @override
  bool shouldRepaint(covariant _ExperimentPainter old) => old.experimentId != experimentId || old.incidentAngle != incidentAngle || old.refractiveIndex != refractiveIndex || old.prismRefractiveIndex != prismRefractiveIndex || old.prismAngleA != prismAngleA || old.deviationAngle != deviationAngle || old.incidentHeight != incidentHeight || old.pointer != pointer;
}
