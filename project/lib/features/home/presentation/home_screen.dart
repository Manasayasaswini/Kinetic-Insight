import 'package:flutter/material.dart';

import '../../../shared/widgets/info_card.dart';
import '../../class11/presentation/class11_lab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF6F0E5),
              Color(0xFFEDEFF5),
              Color(0xFFF1F8F5),
            ],import 'package:flutter/material.dart';
            
            import '../../../shared/widgets/info_card.dart';
            import '../../class11/presentation/class11_lab_screen.dart';
            
            class HomeScreen extends StatelessWidget {
              const HomeScreen({super.key});
            
              @override
              Widget build(BuildContext context) {
                final theme = Theme.of(context);
            
                return Scaffold(
                  body: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFFF6F0E5),
                          Color(0xFFEDEFF5),
                          Color(0xFFF1F8F5),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 600;
                          return SingleChildScrollView(
                        padding: EdgeInsets.all(isMobile ? 16 : 24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1320),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2F2EE),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'KINETIC INSIGHT FLUTTER FRONTEND',
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Build the learning platform once.\nGrow it by module.',
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontSize: isMobile ? 22 : 28,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 760),
                                  child: Text(
                                    'Class 11 is now the active Flutter track. The app shell below is structured like the Class 6 experiments you already built, but ready for future migration of every class into one frontend.',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final wide = constraints.maxWidth >= 980;
                                    return wide
                                        ? Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Expanded(
                                                flex: 7,
                                                child: _ClassSelectorPanel(),
                                              ),
                                              SizedBox(width: 24),
                                              Expanded(flex: 5, child: _RoadmapPanel()),
                                            ],
                                          )
                                        : const Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              _ClassSelectorPanel(),
                                              SizedBox(height: 24),
                                              _RoadmapPanel(),
                                            ],
                                          );
                                  },
                                ),
                                const SizedBox(height: 28),
                                const Class11LabPreviewCard(),
                              ],
                            ),
                          ),
                        ),
                      );
                        },
                      ),
                    ),
                  ),
                );
              }
            }
            
            class _ClassSelectorPanel extends StatelessWidget {
              const _ClassSelectorPanel();
            
              @override
              Widget build(BuildContext context) {
                final theme = Theme.of(context);
            
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Class Paths', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        Text(
                          'Use one frontend shell, but treat each class as a feature set with its own experiments, content, and progression.',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        const _ClassCard(
                          title: 'Class 11',
                          subtitle: 'Active Flutter Track',
                          detail:
                              'Start here with interactive experiment-style modules for oscillations, waves, and modern physics foundations.',
                          accent: Color(0xFF0F766E),
                          active: true,
                        ),
                        const SizedBox(height: 16),
                        const _ClassCard(
                          title: 'Class 6',
                          subtitle: 'Migration Candidate',
                          detail:
                              'The existing web labs remain the working reference until each experiment is ported feature by feature into Flutter.',
                          accent: Color(0xFFC97D10),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            
            class _RoadmapPanel extends StatelessWidget {
              const _RoadmapPanel();
            
              @override
              Widget build(BuildContext context) {
                final theme = Theme.of(context);
            
                return Column(
                  children: [
                    const InfoCard(
                      eyebrow: 'CURRENT DECISION',
                      title: 'Class 11 becomes the active Flutter module.',
                      body:
                          'We stop treating this app like a landing mockup and start using it as the real frontend prototype for experiment-driven learning.',
                    ),
                    const SizedBox(height: 18),
                    const InfoCard(
                      eyebrow: 'UI DIRECTION',
                      title: 'Keep the lab metaphor from Class 6.',
                      body:
                          'Sidebar experiment selection, active controls, a large stage, and a live observation panel remain the right interaction model.',
                    ),
                    const SizedBox(height: 18),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Suggested expansion', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 16),
                            const _BulletLine(
                              text: 'Build each chapter as its own feature package.',
                            ),
                            const _BulletLine(
                              text: 'Port only proven web experiments into Flutter.',
                            ),
                            const _BulletLine(
                              text: 'Keep shared design tokens and widgets centralized.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            
            class _ClassCard extends StatelessWidget {
              const _ClassCard({
                required this.title,
                required this.subtitle,
                required this.detail,
                required this.accent,
                this.active = false,
              });
            
              final String title;
              final String subtitle;
              final String detail;
              final Color accent;
              final bool active;
            
              @override
              Widget build(BuildContext context) {
                final theme = Theme.of(context);
            
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [accent.withValues(alpha: 0.16), Colors.white],
                    ),
                    border: Border.all(color: accent.withValues(alpha: 0.24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(title, style: theme.textTheme.titleLarge),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                active ? 'ACTIVE' : 'LATER',
                                style: theme.textTheme.labelMedium?.copyWith(color: accent),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(subtitle, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Text(detail, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                );
              }
            }
            
            class _BulletLine extends StatelessWidget {
              const _BulletLine({required this.text});
            
              final String text;
            
              @override
              Widget build(BuildContext context) {
                final theme = Theme.of(context);
            
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F766E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                );
              }
            }
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F2EE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'KINETIC INSIGHT FLUTTER FRONTEND',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Build the learning platform once.\nGrow it by module.',
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Text(
                        'Class 11 is now the active Flutter track. The app shell below is structured like the Class 6 experiments you already built, but ready for future migration of every class into one frontend.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 980;
                        return wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Expanded(
                                    flex: 7,
                                    child: _ClassSelectorPanel(),
                                  ),
                                  SizedBox(width: 24),
                                  Expanded(flex: 5, child: _RoadmapPanel()),
                                ],
                              )
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _ClassSelectorPanel(),
                                  SizedBox(height: 24),
                                  _RoadmapPanel(),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 28),
                    const Class11LabPreviewCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClassSelectorPanel extends StatelessWidget {
  const _ClassSelectorPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class Paths', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(
              'Use one frontend shell, but treat each class as a feature set with its own experiments, content, and progression.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _ClassCard(
              title: 'Class 11',
              subtitle: 'Active Flutter Track',
              detail:
                  'Start here with interactive experiment-style modules for oscillations, waves, and modern physics foundations.',
              accent: Color(0xFF0F766E),
              active: true,
            ),
            const SizedBox(height: 16),
            const _ClassCard(
              title: 'Class 6',
              subtitle: 'Migration Candidate',
              detail:
                  'The existing web labs remain the working reference until each experiment is ported feature by feature into Flutter.',
              accent: Color(0xFFC97D10),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoadmapPanel extends StatelessWidget {
  const _RoadmapPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const InfoCard(
          eyebrow: 'CURRENT DECISION',
          title: 'Class 11 becomes the active Flutter module.',
          body:
              'We stop treating this app like a landing mockup and start using it as the real frontend prototype for experiment-driven learning.',
        ),
        const SizedBox(height: 18),
        const InfoCard(
          eyebrow: 'UI DIRECTION',
          title: 'Keep the lab metaphor from Class 6.',
          body:
              'Sidebar experiment selection, active controls, a large stage, and a live observation panel remain the right interaction model.',
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Suggested expansion', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                const _BulletLine(
                  text: 'Build each chapter as its own feature package.',
                ),
                const _BulletLine(
                  text: 'Port only proven web experiments into Flutter.',
                ),
                const _BulletLine(
                  text: 'Keep shared design tokens and widgets centralized.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.accent,
    this.active = false,
  });

  final String title;
  final String subtitle;
  final String detail;
  final Color accent;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [accent.withValues(alpha: 0.16), Colors.white],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    active ? 'ACTIVE' : 'LATER',
                    style: theme.textTheme.labelMedium?.copyWith(color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(subtitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(detail, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF0F766E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
