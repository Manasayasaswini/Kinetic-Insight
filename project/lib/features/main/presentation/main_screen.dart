import 'package:flutter/material.dart';

import '../../class11/presentation/class11_lab_screen.dart';
import '../../class6/presentation/class6_lab_screen.dart';
import '../../class7/presentation/class7_lab_screen.dart';
import '../../class9/presentation/class9_lab_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 48,
                  vertical: isMobile ? 32 : 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            'KINETIC INSIGHT',
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Physics Lab',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontSize: isMobile ? 26 : 38,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Interactive experiments for learning',
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        if (isMobile)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _MobileLabButton(
                                label: 'Class 6 – Shadows & Light',
                                color: const Color(0xFF4A69BD),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class6LabScreenEntry(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _MobileLabButton(
                                label: 'Class 7 – Mirrors & Light',
                                color: const Color(0xFF2563EB),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class7LabScreenEntry(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _MobileLabButton(
                                label: 'Class 9 – Kaleidoscope',
                                color: const Color(0xFF7C3AED),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class9LabScreenEntry(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _MobileLabButton(
                                label: 'Class 11 – Optics Lab',
                                color: const Color(0xFF0F766E),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class11LabScreenEntry(),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 24,
                            runSpacing: 16,
                            children: [
                              _DesktopLabButton(
                                label: 'Class 6 - Shadows & Light',
                                color: const Color(0xFF4A69BD),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class6LabScreenEntry(),
                                  ),
                                ),
                              ),
                              _DesktopLabButton(
                                label: 'Class 7 - Mirrors & Light',
                                color: const Color(0xFF2563EB),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class7LabScreenEntry(),
                                  ),
                                ),
                              ),
                              _DesktopLabButton(
                                label: 'Class 9 - Kaleidoscope',
                                color: const Color(0xFF7C3AED),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class9LabScreenEntry(),
                                  ),
                                ),
                              ),
                              _DesktopLabButton(
                                label: 'Class 11 - Optics Lab',
                                color: const Color(0xFF0F766E),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Class11LabScreenEntry(),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

class _MobileLabButton extends StatelessWidget {
  const _MobileLabButton({
    required this.label,
    required this.color,
    required this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DesktopLabButton extends StatelessWidget {
  const _DesktopLabButton({
    required this.label,
    required this.color,
    required this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class Class6LabScreenEntry extends StatelessWidget {
  const Class6LabScreenEntry({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class 6 – Shadows and Light'),
        backgroundColor: const Color(0xFF4A69BD),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Class6LabScreen(),
    );
  }
}

class Class11LabScreenEntry extends StatelessWidget {
  const Class11LabScreenEntry({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class 11 – Optics Lab'),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Class11LabScreen(),
    );
  }
}

class Class7LabScreenEntry extends StatelessWidget {
  const Class7LabScreenEntry({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class 7 – Mirrors and Light'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Class7LabScreen(),
    );
  }
}

class Class9LabScreenEntry extends StatelessWidget {
  const Class9LabScreenEntry({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class 9 – Kaleidoscope'),
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Class9LabScreen(),
    );
  }
}
