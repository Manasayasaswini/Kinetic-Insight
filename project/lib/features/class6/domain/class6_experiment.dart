import 'package:flutter/material.dart';

class Class6Experiment {
  const Class6Experiment({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.observation,
    required this.fact,
    required this.accent,
    this.enabled = true,
  });

  final String id;
  final String title;
  final String subtitle;
  final String observation;
  final String fact;
  final Color accent;
  final bool enabled;
}
