import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/main/presentation/main_screen.dart';

class KineticInsightApp extends StatelessWidget {
  const KineticInsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinetic Insight',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const MainScreen(),
    );
  }
}
