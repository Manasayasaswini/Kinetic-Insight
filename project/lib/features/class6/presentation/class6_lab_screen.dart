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

  String _getObservation() {
    if (activeExperiment.id == 'transparency') {
      switch (selectedMaterial) {
        case 'glass': return 'Light passes through completely. Objects are clearly visible.';
        case 'paper': return 'Light passes partially. Objects look blurry and faint.';
        case 'wood':  return 'Light is blocked completely. A dark shadow forms behind it.';
        default: return activeExperiment.observation;
      }
    } else if (activeExperiment.id == 'shadow') {
      if (sunAngle > 80 && sunAngle < 100) return 'Noon: The sun is overhead. Shadow is shortest!';
      if (sunAngle < 40 || sunAngle > 140) return 'Morning/Evening: Sun is low. Shadows are very long.';
      return 'Shadow always forms on the side opposite the light source.';
    } else if (activeExperiment.id == 'pinhole') {
      return 'Rays cross at the pinhole — image flips and changes size.';
    } else if (activeExperiment.id == 'refraction') {
      return 'Light bends at the water surface — the pencil appears shifted.';
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
        return 'Touch the canvas to place the pencil in the glass.\nThe bend you see is caused by light changing speed when entering water.';
      default: return activeExperiment.observation;
    }
  }

  // Canvas height — enough for each painter to render fully
  double _canvasHeight(String id) {
    switch (id) {
      case 'shadow':     return 360.0;
      case 'pinhole':    return 340.0;
      case 'refraction': return 360.0;
      default:           return 300.0;
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
              children: experiments.map((exp) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _ExperimentChip(
                  experiment: exp,
                  active: activeExperiment.id == exp.id,
                  onTap: () => onExperimentSelected(exp),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // ── 2. Inline controls (ABOVE canvas) ──────────────────
          if (activeExperiment.id == 'transparency') ...[
            Text('Choose a material:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _MaterialBtn(label: 'Glass',
                sublabel: 'Transparent', selected: selectedMaterial == 'glass',
                color: const Color(0xFF4A69BD),
                onTap: () => onMaterialSelected('glass'))),
              const SizedBox(width: 8),
              Expanded(child: _MaterialBtn(label: 'Paper',
                sublabel: 'Translucent', selected: selectedMaterial == 'paper',
                color: const Color(0xFFF1C40F),
                onTap: () => onMaterialSelected('paper'))),
              const SizedBox(width: 8),
              Expanded(child: _MaterialBtn(label: 'Wood',
                sublabel: 'Opaque', selected: selectedMaterial == 'wood',
                color: const Color(0xFF8B4513),
                onTap: () => onMaterialSelected('wood'))),
            ]),
            const SizedBox(height: 12),
          ],

          if (activeExperiment.id == 'shadow') ...[
            Row(children: [
              const Icon(Icons.wb_sunny, size: 18, color: Color(0xFFF1C40F)),
              const SizedBox(width: 8),
              Text('Move the Sun', style: theme.textTheme.titleSmall),
            ]),
            Slider(min: 10, max: 170, value: sunAngle,
              activeColor: const Color(0xFFF1C40F),
              onChanged: onSunAngleChanged),
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

          // ── 3. Canvas — HERO ────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: _canvasHeight(activeExperiment.id),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: accent.withValues(alpha: 0.18), width: 1.5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: GestureDetector(
                onPanUpdate: (d) => onMouseChanged(d.localPosition),
                onTapDown:   (d) => onMouseChanged(d.localPosition),
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
    required this.onTap,
  });
  final Class6Experiment experiment;
  final bool active;
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
        child: Text(
          experiment.title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: active ? Colors.white : experiment.accent,
          ),
        ),
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
            Text(label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected ? Colors.white : color,
              ),
              textAlign: TextAlign.center),
            Text(sublabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: selected
                    ? Colors.white.withValues(alpha: 0.80)
                    : color.withValues(alpha: 0.70),
                fontSize: 10,
              ),
              textAlign: TextAlign.center),
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
                Text(title,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: accent)),
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
        return 'What to do: Observe the pencil at the water surface.\n'
            'What to observe: Pencil looks bent or broken at the boundary.\n'
            'Key idea: Light bends when it moves from air to water.';
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
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: activeExperiment.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeExperiment.fact,
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
            Text(experiment.title, style: theme.textTheme.titleMedium),
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

    _label(canvas, size, 'Light Source',
        Offset(torchX - 32.0, torchY + 25.0));
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
    final groundY    = size.height * 0.62;           // ground at 62% height
    final skyH       = groundY;
    final pillarH    = skyH * 0.38;                  // pillar = 38% of sky height
    final pillarW    = size.width * 0.055;
    final centerX    = size.width * 0.5;
    final pillarX    = centerX - pillarW / 2;

    // ── sky ───────────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, groundY),
      Paint()..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFCEE8FF), Color(0xFFFFF8DA), Color(0xFFF5F0DB)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, groundY)),
    );

    // ── ground ────────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
      Paint()..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFD8D2B8), Color(0xFFB6C98C), Color(0xFF89A663)],
      ).createShader(
        Rect.fromLTWH(0, groundY, size.width, size.height - groundY)),
    );

    // ── sun position ──────────────────────────────────────────────
    // Sun orbits on a semicircle ABOVE ground, radius = 42% of sky height
    // so at noon (90°) sun is at top-center, never below pillar top
    final rad    = sunAngle * math.pi / 180.0;
    final orbitR = skyH * 0.72;                      // orbit radius in pixels
    final sunX   = centerX + orbitR * math.cos(math.pi - rad);
    final sunY   = groundY - orbitR * math.sin(math.pi - rad);
    // clamp so sun never dips below top of pillar
    final sunYClamped = sunY.clamp(8.0, groundY - pillarH - 12.0).toDouble();
    final sunR   = size.width * 0.055;               // sun radius scales too

    // ── shadow on ground ─────────────────────────────────────────
    // shadow length from tan of elevation angle
    final elevation  = math.max(0.05, math.sin(rad));
    final shadowLen  = (pillarH / math.tan(math.max(0.05, rad)))
        .clamp(-size.width * 0.8, size.width * 0.8);
    final shadowW    = math.max(pillarW, shadowLen.abs() * 0.18)
        .clamp(pillarW, size.width * 0.35);
    final shadowCx   = centerX + shadowLen * 0.5;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(shadowCx, groundY + 5),
        width: shadowW * 2,
        height: pillarW * 0.8,
      ),
      Paint()..color = Color.fromRGBO(
        45, 52, 54,
        math.max(0.06, 0.28 - elevation * 0.18)),
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
      Paint()..shader = RadialGradient(
        colors: const [
          Color(0xFFFFFFFF),
          Color(0xFFFFF4B3),
          Color(0xFFF1C40F),
          Color(0x00F1C40F),
        ],
      ).createShader(Rect.fromCircle(
          center: Offset(sunX, sunYClamped), radius: sunR)),
    );
    for (int i = 0; i < 8; i++) {
      final a = (math.pi * 2.0 * i) / 8.0;
      canvas.drawLine(
        Offset(sunX + math.cos(a) * sunR * 0.85,
               sunYClamped + math.sin(a) * sunR * 0.85),
        Offset(sunX + math.cos(a) * sunR * 1.5,
               sunYClamped + math.sin(a) * sunR * 1.5),
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
    _label(canvas, size, lbl,
        Offset(sunX - 20, sunYClamped + sunR + 6),
        color: const Color(0xFF7A6300), bold: true);
  }

  void _drawPinholeExperiment(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFCFAF4),
    );

    // ── Camera box — right 40% ────────────────────────────────────
    final boxW    = size.width  * 0.40;
    final boxH    = size.height * 0.60;
    final boxX    = size.width  * 0.56;
    final boxY    = (size.height - boxH) * 0.50;
    final pinY    = boxY + boxH * 0.50;
    final screenX = boxX + boxW * 0.88;

    canvas.drawRect(
      Rect.fromLTWH(boxX - 8, boxY - 8, boxW + 16, boxH + 16),
      Paint()..color = const Color(0xFFE6C898),
    );
    canvas.drawRect(
      Rect.fromLTWH(boxX, boxY, boxW, boxH),
      Paint()..color = const Color(0xFF231E17),
    );
    canvas.drawCircle(Offset(boxX, pinY), 3,
        Paint()..color = const Color(0xFFFFE566));

    // ── Candle zone: left portion ─────────────────────────────────
    final zoneLeft  = size.width * 0.04;
    final zoneRight = boxX - size.width * 0.05;

    final candleX     = mousePosition.dx.clamp(zoneLeft, zoneRight).toDouble();
    final candleBaseY = mousePosition.dy.clamp(size.height * 0.15, size.height * 0.92).toDouble();

    final bodyH  = size.height * 0.16;
    final bodyW  = size.width  * 0.04;
    final flameH = size.height * 0.07;

    // Key Y positions on real candle (small Y = higher on screen)
    final flameTipY  = candleBaseY - bodyH - flameH; // topmost = smallest Y
    final flameBaseY = candleBaseY - bodyH;           // top of body

    // ── Pinhole projection: point (candleX, srcY) → (screenX, dstY) ──
    // Through pinhole at (boxX, pinY):
    //   dstY = pinY + (pinY - srcY) * dImg / dObj
    // Inversion: if flameTip is ABOVE pinY (srcY < pinY), dstY > pinY (below)
    final dObj = (boxX - candleX).clamp(1.0, double.infinity);
    final dImg = (screenX - boxX).abs();
    double proj(double srcY) => pinY + (pinY - srcY) * dImg / dObj;

    final scrTip  = proj(flameTipY);   // flame tip   → projects below pinY
    final scrBase = proj(flameBaseY);  // body top    → projects above scrTip
    final scrBot  = proj(candleBaseY); // candle base → projects highest above

    // Outside rays: candle → pinhole (left of box)
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, boxX + 1, size.height));
    _drawGlowRay(canvas, Offset(candleX, flameTipY),  Offset(boxX, pinY), Offset(boxX, pinY));
    _drawGlowRay(canvas, Offset(candleX, candleBaseY), Offset(boxX, pinY), Offset(boxX, pinY));
    canvas.restore();

    // Inside box: rays + projected inverted candle
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(boxX, boxY, boxW, boxH));
    _drawGlowRay(canvas, Offset(candleX, flameTipY),   Offset(boxX, pinY), Offset(screenX, scrTip));
    _drawGlowRay(canvas, Offset(candleX, candleBaseY), Offset(boxX, pinY), Offset(screenX, scrBot));

    // Inverted image: flame tip projects LOW, candle base projects HIGH
    // scrBot < scrTip (base is higher = smaller Y value)
    // Draw body from scrBot to scrBase, then flame from scrBase to scrTip
    _drawProjectedCandleInverted(canvas, screenX,
        scrBot, scrBase, scrTip, bodyW * 0.7);
    canvas.restore();

    // Real candle
    _drawCandle(canvas, candleX, candleBaseY, bodyH, bodyW, flameH);

    // Labels
    _label(canvas, size, 'PINHOLE CAMERA',
        Offset(boxX + 6, boxY + 4), color: const Color(0xFF6B4B24), bold: true);
    _label(canvas, size, 'Drag candle ↕',
        Offset(zoneLeft, boxY + 4), color: const Color(0xFF64748B));
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

  void _drawCandle(Canvas canvas, double cx, double baseY,
      double bodyH, double bodyW, double flameH) {
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
      ..moveTo(cx, bodyY - flameH)                         // tip (top)
      ..quadraticBezierTo(
          cx + flameH * 0.45, bodyY - flameH * 0.35,
          cx, bodyY)                                        // base right
      ..quadraticBezierTo(
          cx - flameH * 0.45, bodyY - flameH * 0.35,
          cx, bodyY - flameH);                              // base left
    canvas.drawPath(flamePath, Paint()..color = const Color(0xFFFFF4B3));
    canvas.drawPath(flamePath, Paint()
      ..color = const Color(0xFFF1C40F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);
  }

  // Draws the inverted candle image on the screen inside the box.
  // bodyTop = projected candle base (highest = smallest Y)
  // bodyBot = projected body top
  // flameTip = projected flame tip (lowest = largest Y)
  void _drawProjectedCandleInverted(
    Canvas canvas, double cx,
    double bodyTop, double bodyBot,
    double flameTip, double bodyW) {

    final bH = (bodyBot - bodyTop).abs().clamp(6.0, double.infinity);
    final bW = bodyW.clamp(4.0, 20.0);
    final bX = cx - bW / 2;
    final bY = math.min(bodyTop, bodyBot);

    // Body (green wax)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bX, bY, bW, bH), Radius.circular(bW * 0.3)),
      Paint()..shader = const LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFFA6EDB1), Color(0xFF4D9D61)],
      ).createShader(Rect.fromLTWH(bX, bY, bW, bH)),
    );

    // Flame (inverted — tip points DOWN)
    // flameTip > bodyBot  (further down the screen)
    final fH = (flameTip - bodyBot).abs().clamp(4.0, double.infinity);
    final fHalfW = (fH * 0.4).clamp(3.0, 12.0);
    final fBaseY = math.min(flameTip, bodyBot); // top of flame zone
    final fTipY  = math.max(flameTip, bodyBot); // bottom = inverted tip

    // Glow
    canvas.drawCircle(
      Offset(cx, fTipY), fH * 0.55,
      Paint()
        ..color = const Color(0xFFF1C40F).withValues(alpha: 0.40)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // Flame shape — tip points DOWN
    final fp = Path()
      ..moveTo(cx, fTipY)                                         // tip (down)
      ..quadraticBezierTo(cx + fHalfW, fBaseY + fH * 0.4, cx, fBaseY)  // right
      ..quadraticBezierTo(cx - fHalfW, fBaseY + fH * 0.4, cx, fTipY);  // left
    canvas.drawPath(fp, Paint()..color = const Color(0xFFFFF4B3));
    canvas.drawPath(fp, Paint()
      ..color = const Color(0xFFF1C40F)
      ..style = PaintingStyle.stroke ..strokeWidth = 1.2);
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

    // ── Glass — centred, proportional ────────────────────────────
    final glassW  = size.width  * 0.30;
    final glassH  = size.height * 0.52;
    final glassX  = (size.width  - glassW) / 2;
    final glassY  = size.height  * 0.14;
    final waterLv = glassY + glassH * 0.44;

    // Glass outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(glassX, glassY, glassW, glassH),
        const Radius.circular(10)),
      Paint()
        ..color = const Color(0xFFA0C3DC).withValues(alpha: 0.50)
        ..style = PaintingStyle.stroke ..strokeWidth = 2.5,
    );
    // Water fill
    final wH = glassY + glassH - waterLv - 4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(glassX + 4, waterLv, glassW - 8, wH),
        const Radius.circular(7)),
      Paint()..shader = const LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFF48CEC8), Color(0xFF2DD4BF)],
      ).createShader(Rect.fromLTWH(glassX + 4, waterLv, glassW - 8, wH)),
    );
    // Water surface
    canvas.drawLine(
      Offset(glassX + 6, waterLv), Offset(glassX + glassW - 6, waterLv),
      Paint()..color = Colors.white.withValues(alpha: 0.75) ..strokeWidth = 1.5,
    );

    // ── Pencil physics ────────────────────────────────────────────
    // The pencil is a straight rod held at an angle.
    // The user controls WHERE along the rod the water surface intersects.
    // Touch X anywhere → pencil slides left/right freely.
    // Touch Y → how deep pencil dips (pivot Y above water).
    //
    // Key design: pivot (entry point) X is FREE (follows touch X across canvas)
    //             pivot Y stays ABOVE waterLv
    //             The rod extends both up-left and down-right from pivot.

    const angle = 0.88; // radians ~50° from horizontal
    final strokeW = size.width * 0.030;

    // Pivot follows touch freely — only Y is clamped above water
    final pivotX = mousePosition.dx.clamp(8.0, size.width - 8.0).toDouble();
    final pivotY = mousePosition.dy.clamp(glassY + 6, waterLv - 4).toDouble();

    // Above-water portion (tip goes up-left)
    final aboveLen = size.height * 0.42;
    final topX = pivotX - math.cos(angle) * aboveLen;
    final topY = pivotY - math.sin(angle) * aboveLen;

    // Below-water raw end (goes down-right)
    final belowLen = size.height * 0.34;
    final botRawX  = pivotX + math.cos(angle) * belowLen;
    final botRawY  = pivotY + math.sin(angle) * belowLen;

    // Refraction shift — lateral displacement when entering water
    final shift = glassW * 0.20;

    // Is pivot inside glass horizontally?
    final pivotInGlass = pivotX >= glassX + 8 && pivotX <= glassX + glassW - 8;
    // Does the pencil actually reach below water?
    final belowWater = pivotInGlass && botRawY > waterLv;

    // Draw above-water part (clamp tip to canvas bounds)
    canvas.drawLine(
      Offset(topX.clamp(2.0, size.width - 2).toDouble(),
             topY.clamp(2.0, size.height - 2).toDouble()),
      Offset(pivotX, pivotY),
      Paint()
        ..color = const Color(0xFFF4C542)
        ..strokeWidth = strokeW ..strokeCap = StrokeCap.round,
    );

    if (belowWater) {
      // Shifted below-water segment clipped inside glass water zone
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(
          glassX + 2, waterLv, glassW - 4, wH - 2));
      canvas.drawLine(
        Offset(pivotX + shift * 0.12, waterLv + 1),
        Offset(
          (botRawX + shift).clamp(glassX + 4, glassX + glassW - 4).toDouble(),
          botRawY.clamp(waterLv + 2, glassY + glassH - 4).toDouble()),
        Paint()
          ..color = const Color(0xFFF4C542).withValues(alpha: 0.82)
          ..strokeWidth = strokeW ..strokeCap = StrokeCap.round,
      );
      canvas.restore();

      // Entry dot at water surface
      canvas.drawCircle(Offset(pivotX, waterLv), 4,
          Paint()..color = const Color(0xFF2DD4BF));
    } else {
      // Pencil straight through (not in water or outside glass)
      canvas.drawLine(
        Offset(pivotX, pivotY),
        Offset(botRawX.clamp(2.0, size.width - 2).toDouble(),
               botRawY.clamp(2.0, size.height - 2).toDouble()),
        Paint()
          ..color = const Color(0xFFF4C542)
          ..strokeWidth = strokeW ..strokeCap = StrokeCap.round,
      );
    }

    // ── Labels ────────────────────────────────────────────────────
    _label(canvas, size, 'water surface',
        Offset(glassX + glassW + 6, waterLv - 2),
        color: const Color(0xFF0D9488));
    if (belowWater) {
      _label(canvas, size, 'looks bent! 👀',
          Offset(glassX + glassW + 6, waterLv + 14),
          color: const Color(0xFF475569));
    } else if (pivotInGlass) {
      _label(canvas, size, 'dip pencil deeper',
          Offset(4, glassY + 4), color: const Color(0xFF94A3B8));
    } else {
      _label(canvas, size, 'move pencil over glass',
          Offset(4, glassY + 4), color: const Color(0xFF94A3B8));
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
