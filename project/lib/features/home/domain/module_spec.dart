import 'package:flutter/material.dart';

class ModuleSpec {
  const ModuleSpec({
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.accent,
  });

  final String stage;
  final String title;
  final String subtitle;
  final String detail;
  final Color accent;
}
