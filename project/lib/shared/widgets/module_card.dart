import 'package:flutter/material.dart';

import '../../features/home/domain/module_spec.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.spec});

  final ModuleSpec spec;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [spec.accent.withValues(alpha: 0.16), Colors.white],
        ),
        border: Border.all(color: spec.accent.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: spec.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    spec.stage,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: spec.accent,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_outward, color: spec.accent),
              ],
            ),
            const SizedBox(height: 16),
            Text(spec.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(spec.subtitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(spec.detail, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
