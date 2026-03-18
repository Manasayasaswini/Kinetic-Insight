import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/class6_experiment.dart';

class Class6LabScreen extends StatefulWidget {
  const Class6LabScreen({super.key});

  @override
  State<Class6LabScreen> createState() => _Class6LabScreenState();
}

class _Class6LabScreenState extends State<Class6LabScreen> {
  static const _experiments = <Class6Experiment>[
    Class6Experiment(
      id: 'transparency',
      title: '1. Light & Materials',
      subtitle: 'Test transparent, translucent, and opaque objects.',
      observation: 'Transparent objects let most light pass through.',
      fact: 'Transparent objects let most light pass, translucent let some, and opaque block it completely.',
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
      observation: 'Light bends when it enters water, making the pencil appear broken.',
      fact: 'Light changes speed in water, so the underwater part appears shifted.',
      accent: Color(0xFF0D9488),
    ),
  ];

  late Class6Experiment _activeExperiment = _experiments.first;
  String _selectedMaterial = 'glass';
  double _sunAngle = 45;
  Offset _mousePosition = const Offset(150, 220);

  void _setExperiment(Class6Experiment experiment) {
    if (!experiment.enabled) return;
    setState(() {
      _activeExperiment = experiment;
    });
  }

  void _setMaterial(String material) {
    setState(() {
      _selectedMaterial = material;
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
              colors: <Color>[Color(0xFFF9F9F7), Color(0xFFF0E8D9)],
            ),
          ),
          child: compact
              ? Column(
                  children: [
                    _ControlRail(
                      experiments: _experiments,
                      activeExperiment: _activeExperiment,
                      selectedMaterial: _selectedMaterial,
                      sunAngle: _sunAngle,
                      onExperimentSelected: _setExperiment,
                      onMaterialSelected: _setMaterial,
                      onSunAngleChanged: (value) {
                        setState(() => _sunAngle = value);
                      },
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

class _ControlRail extends StatelessWidget {
  const _ControlRail({
    required this.experiments,
    required this.activeExperiment,
    required this.selectedMaterial,
    required this.sunAngle,
    required this.onExperimentSelected,
    required this.onMaterialSelected,
    required this.onSunAngleChanged,
  });

  final List<Class6Experiment> experiments;
  final Class6Experiment activeExperiment;
  final String selectedMaterial;
  final double sunAngle;
  final ValueChanged<Class6Experiment> onExperimentSelected;
  final ValueChanged<String> onMaterialSelected;
  final ValueChanged<double> onSunAngleChanged;

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
      return 'Light bends when it enters water, so the underwater part of the pencil appears shifted at the surface.';
    }
    return activeExperiment.observation;
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
              Text('Move the Sun from morning to evening', style: theme.textTheme.bodyMedium),
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
            const SizedBox(height: 24),
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
                    'Quick Fact',
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

  final Class6Experiment experiment;
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
            Text(
              experiment.title,
              style: theme.textTheme.titleMedium,
            ),
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
          color: selected ? color.withValues(alpha: 0.15) : const Color(0xFFF8F5EE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color.withValues(alpha: 0.4) : const Color(0xFFE8DECF),
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
            onHover: (event) {
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
          child: _OverlayCard(
            title: 'Live Observation',
            accent: experiment.accent,
            body: _getObservation(),
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
      return 'Light bends when it enters water, so the underwater part of the pencil appears shifted at the surface.';
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

    final objectRect = Rect.fromLTWH(objectX - 20.0, torchY - 60.0, 40.0, 120.0);
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
        Paint()..color = const Color(0xFFFFFFC8).withValues(alpha: passThrough * 0.5),
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
        Paint()..color = Colors.black.withValues(alpha: (1 - passThrough) * 0.15),
      );
    }

    final labelStyle = TextPainter(textDirection: TextDirection.ltr);
    labelStyle.text = const TextSpan(
      text: 'Light Source',
      style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
    );
    labelStyle.layout();
    labelStyle.paint(canvas, Offset(torchX - 32.0, torchY + 25.0));

    labelStyle.text = TextSpan(
      text: selectedMaterial == 'glass' 
          ? 'Transparent' 
          : selectedMaterial == 'paper' 
              ? 'Translucent' 
              : 'Opaque',
      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
    );
    labelStyle.layout();
    labelStyle.paint(canvas, Offset(objectX - 25.0, torchY + 75.0));
  }

  void _drawShadowExperiment(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final groundY = size.height - 120.0;
    final pillarHeight = 132.0;
    final pillarWidth = 34.0;
    final pillarX = centerX - pillarWidth / 2;

    final sky = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFFEEF7FF), Color(0xFFFFF8DA), Color(0xFFF5F0DB)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, groundY));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, groundY), Paint()..shader = sky);

    final groundGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFFD8D2B8), Color(0xFFB6C98C), Color(0xFF89A663)],
    ).createShader(Rect.fromLTWH(0, groundY, size.width, size.height - groundY));
    canvas.drawRect(Rect.fromLTWH(0, groundY, size.width, size.height - groundY), Paint()..shader = groundGrad);

    final rad = sunAngle * math.pi / 180.0;
    final sunRadius = math.min(280.0, size.width * 0.28);
    final sunX = centerX + sunRadius * math.cos(math.pi - rad);
    final sunY = groundY - sunRadius * math.sin(math.pi - rad);

    final shadowLen = pillarHeight / math.tan(rad);
    final shadowOpacity = math.max(0.06, 0.24 - math.min(shadowLen.abs() / 1200.0, 0.14));
    final shadowWidth = math.max(18.0, shadowLen.abs() * 0.42);
    final shadowCenterX = centerX + shadowLen / 2;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(shadowCenterX, groundY + 8.0), width: shadowWidth * 2.0, height: 28.0),
      Paint()..color = Color.fromRGBO(45, 52, 54, shadowOpacity),
    );

    canvas.drawRect(
      Rect.fromLTWH(pillarX - 12.0, groundY - pillarHeight - 2.0, pillarWidth + 24.0, pillarHeight + 4.0),
      Paint()..color = const Color(0xFF9A8A76),
    );
    canvas.drawRect(
      Rect.fromLTWH(pillarX, groundY - pillarHeight, pillarWidth, pillarHeight),
      Paint()..color = const Color(0xFF7F7364),
    );

    final sunGrad = RadialGradient(
      colors: const [Color(0xFFFFFFFF), Color(0xFFFFF4B3), Color(0xFFF1C40F), Color(0x00F1C40F)],
    ).createShader(Rect.fromCircle(center: Offset(sunX, sunY), radius: 44.0));
    canvas.drawCircle(Offset(sunX, sunY), 44.0, Paint()..shader = sunGrad);

    for (int i = 0; i < 8; i++) {
      final angle = (math.pi * 2.0 * i) / 8.0;
      canvas.drawLine(
        Offset(sunX + math.cos(angle) * 34.0, sunY + math.sin(angle) * 34.0),
        Offset(sunX + math.cos(angle) * 54.0, sunY + math.sin(angle) * 54.0),
        Paint()
          ..color = const Color(0xFFFFDC6B).withValues(alpha: 0.4)
          ..strokeWidth = 2,
      );
    }

    final labelStyle = TextPainter(textDirection: TextDirection.ltr);
    labelStyle.text = TextSpan(
      text: sunAngle < 40 ? 'Morning' : sunAngle > 140 ? 'Evening' : 'Sun Position',
      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
    );
    labelStyle.layout();
    labelStyle.paint(canvas, Offset(sunX - 30, sunY - 60));
  }

  void _drawPinholeExperiment(Canvas canvas, Size size) {
    final boxW = math.min(300.0, size.width * 0.38);
    final boxH = math.min(250.0, size.height * 0.52);
    final boxX = size.width * 0.54;
    final boxY = (size.height - boxH) / 2;
    final pinholeY = boxY + boxH / 2;
    final screenX = boxX + boxW - 20;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFCFAF4),
    );

    final candleX = mousePosition.dx.clamp(size.width * 0.12, boxX - 95.0);
    final candleBaseY = (mousePosition.dy + 36.0).clamp(boxY + 70.0, boxY + boxH + 70.0);
    final scale = 0.95 + ((boxX - candleX) / math.max(160.0, boxX - size.width * 0.12)) * 0.35;
    final bodyTopY = candleBaseY - 62 * scale;
    final flameTopY = candleBaseY - 88 * scale;
    final flameBottomY = candleBaseY - 54 * scale;

    final ratio = (screenX - boxX) / math.max(40.0, boxX - candleX);
    final projectedBodyBottom = pinholeY + (pinholeY - candleBaseY) * ratio;
    final projectedBodyTop = pinholeY + (pinholeY - bodyTopY) * ratio;
    final projectedFlameTop = pinholeY + (pinholeY - flameTopY) * ratio;
    final projectedFlameBottom = pinholeY + (pinholeY - flameBottomY) * ratio;

    canvas.drawRect(
      Rect.fromLTWH(boxX - 12.0, boxY - 10.0, boxW + 24.0, boxH + 20.0),
      Paint()..color = const Color(0xFFE6C898),
    );
    canvas.drawRect(
      Rect.fromLTWH(boxX, boxY, boxW, boxH),
      Paint()..color = const Color(0xFF231E17),
    );

    canvas.drawCircle(
      Offset(boxX, pinholeY),
      5,
      Paint()..color = const Color(0xFF1A1410),
    );

    _drawGlowRay(canvas, Offset(candleX, flameTopY), Offset(boxX, pinholeY), Offset(screenX, projectedFlameTop));
    _drawGlowRay(canvas, Offset(candleX, flameBottomY), Offset(boxX, pinholeY), Offset(screenX, projectedFlameBottom));

    _drawCandle(canvas, candleX, candleBaseY, scale);

    final projectedBodyWidth = math.max(6.0, (projectedBodyBottom - projectedBodyTop).abs() * 0.32);
    final projX = screenX - projectedBodyWidth / 2;
    final projY = math.min(projectedBodyTop, projectedBodyBottom);

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(boxX + 8.0, boxY + 10.0, boxW - 18.0, boxH - 20.0));
    _drawProjectedCandle(canvas, screenX, projectedBodyTop, projectedBodyBottom, projectedFlameTop, projectedFlameBottom);
    canvas.restore();

    final labelStyle = TextPainter(textDirection: TextDirection.ltr);
    labelStyle.text = const TextSpan(
      text: 'PINHOLE CAMERA',
      style: TextStyle(color: Color(0xFF6B4B24), fontSize: 11, fontWeight: FontWeight.w700),
    );
    labelStyle.layout();
    labelStyle.paint(canvas, Offset(boxX + 18.0, boxY - 22.0));

    labelStyle.text = const TextSpan(
      text: 'Move the candle with your mouse',
      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
    );
    labelStyle.layout();
    labelStyle.paint(canvas, Offset(36.0, boxY - 22.0));
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

  void _drawCandle(Canvas canvas, double cx, double baseY, double scale) {
    final bodyW = 20 * scale;
    final bodyH = 62 * scale;
    final flameH = 26 * scale;
    final bodyX = cx - bodyW / 2;
    final bodyY = baseY - bodyH;

    final waxGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFF9BE7A6), Color(0xFF78E08F), Color(0xFF58B36A)],
    ).createShader(Rect.fromLTWH(bodyX, bodyY, bodyW, bodyH));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bodyX, bodyY, bodyW, bodyH), Radius.circular(6 * scale)),
      Paint()..shader = waxGrad,
    );

    canvas.drawLine(
      Offset(cx, bodyY - 4 * scale),
      Offset(cx, bodyY + 8 * scale),
      Paint()
        ..color = const Color(0xFF5B4636)
        ..strokeWidth = 1.2 * scale,
    );

    canvas.drawCircle(
      Offset(cx, bodyY - flameH),
      18 * scale,
      Paint()
        ..color = const Color(0xFFF1C40F).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
    final flamePath = Path()
      ..moveTo(cx, bodyY - flameH)
      ..quadraticBezierTo(cx + 12 * scale, bodyY - 12 * scale, cx, bodyY + 2 * scale)
      ..quadraticBezierTo(cx - 12 * scale, bodyY - 12 * scale, cx, bodyY - flameH);
    canvas.drawPath(
      flamePath,
      Paint()..color = const Color(0xFFFFF4B3),
    );
    canvas.drawPath(
      flamePath,
      Paint()
        ..color = const Color(0xFFF1C40F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawProjectedCandle(Canvas canvas, double cx, double bodyTop, double bodyBottom, double flameTop, double flameBottom) {
    final bodyHeight = math.max(10.0, (bodyBottom - bodyTop).abs());
    final bodyWidth = math.max(6.0, bodyHeight * 0.32);
    final bodyX = cx - bodyWidth / 2;
    final bodyY = math.min(bodyTop, bodyBottom);

    final waxGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFFA6EDB1), Color(0xFF78E08F), Color(0xFF4D9D61)],
    ).createShader(Rect.fromLTWH(bodyX, bodyY, bodyWidth, bodyHeight));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bodyX, bodyY, bodyWidth, bodyHeight), const Radius.circular(4)),
      Paint()..shader = waxGrad,
    );

    final flameHalfW = math.max(4.0, (flameBottom - flameTop).abs() * 0.28);
    final flamePath = Path()
      ..moveTo(cx, flameTop)
      ..quadraticBezierTo(cx + flameHalfW, (flameTop + flameBottom) / 2, cx, flameBottom)
      ..quadraticBezierTo(cx - flameHalfW, (flameTop + flameBottom) / 2, cx, flameTop);
    canvas.drawCircle(
      Offset(cx, flameTop),
      12,
      Paint()..color = const Color(0xFFF1C40F).withValues(alpha: 0.45)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawPath(flamePath, Paint()..color = const Color(0xFFF1C40F));
  }

  void _drawRefractionExperiment(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final glassW = math.min(170.0, size.width * 0.2);
    final glassH = math.min(260.0, size.height * 0.42);
    final glassX = centerX - glassW / 2;
    final glassY = centerY - glassH / 2 - 10.0;
    final waterLevel = glassY + glassH * 0.48;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF8FBFF),
    );

    canvas.drawRect(
      Rect.fromLTWH(0.0, glassY + glassH - 15.0, size.width, size.height - glassY - glassH + 15.0),
      Paint()..color = const Color(0xFFE4D8C4),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(glassX, glassY, glassW, glassH), const Radius.circular(20)),
      Paint()
        ..color = const Color(0xFFA0C3DC).withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final waterGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFF48CEC8), Color(0xFF2DD4BF)],
    ).createShader(Rect.fromLTWH(glassX + 6.0, waterLevel, glassW - 12.0, glassY + glassH - waterLevel - 6.0));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(glassX + 6.0, waterLevel, glassW - 12.0, glassY + glassH - waterLevel - 6.0),
        const Radius.circular(16),
      ),
      Paint()..shader = waterGrad,
    );

    canvas.drawLine(
      Offset(glassX + 12, waterLevel),
      Offset(glassX + glassW - 12, waterLevel),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.65)
        ..strokeWidth = 2,
    );

    final pivotX = mousePosition.dx.clamp(glassX - 150.0, glassX + glassW - 10.0);
    final pivotY = mousePosition.dy.clamp(glassY - 110.0, waterLevel - 8.0);
    const pencilAngle = 0.92;
    const topLength = 145.0;
    const bottomLength = 128.0;
    final topX = pivotX - math.cos(pencilAngle) * topLength;
    final topY = pivotY - math.sin(pencilAngle) * topLength;
    final rawBottomX = pivotX + math.cos(pencilAngle) * bottomLength;
    final rawBottomY = pivotY + math.sin(pencilAngle) * bottomLength;

    final entersWater = pivotX > glassX + 16.0 && pivotX < glassX + glassW - 16.0 && pivotY > glassY + 20.0;
    final visibleUnderwater = entersWater && rawBottomY > waterLevel;
    const refractShift = 24.0;

    canvas.drawLine(
      Offset(topX, topY),
      Offset(pivotX, pivotY),
      Paint()
        ..color = const Color(0xFFF4C542)
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round,
    );

    if (visibleUnderwater) {
      canvas.drawLine(
        Offset(pivotX + refractShift, pivotY + 2.0),
        Offset(rawBottomX + refractShift, rawBottomY),
        Paint()
          ..color = const Color(0xFFF4C542).withValues(alpha: 0.72)
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round,
      );

      canvas.drawCircle(
        Offset(pivotX, waterLevel),
        5,
        Paint()..color = const Color(0xFF2DD4BF),
      );
    } else {
      canvas.drawLine(
        Offset(pivotX, pivotY),
        Offset(rawBottomX, rawBottomY),
        Paint()
          ..color = const Color(0xFFF4C542)
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round,
      );
    }

    final labelStyle = TextPainter(textDirection: TextDirection.ltr);
    labelStyle.text = const TextSpan(
      text: 'water surface',
      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
    );
    labelStyle.layout();
    labelStyle.paint(canvas, Offset(glassX + glassW + 18.0, waterLevel + 4.0));

    labelStyle.text = const TextSpan(
      text: 'move the pencil into the glass',
      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
    );
    labelStyle.layout();
    labelStyle.paint(canvas, Offset(glassX - 148.0, glassY - 18.0));

    if (visibleUnderwater) {
      labelStyle.text = const TextSpan(
        text: 'inside water it looks bent',
        style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
      );
      labelStyle.layout();
      labelStyle.paint(canvas, Offset(glassX + glassW + 18.0, waterLevel + 24.0));
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
