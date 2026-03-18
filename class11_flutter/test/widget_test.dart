import 'package:class11_flutter/app/kinetic_insight_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders app landing with class selectors', (tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const KineticInsightApp());

    expect(find.text('Physics Lab'), findsOneWidget);
    expect(find.text('Class 11 - Optics Lab'), findsOneWidget);
    expect(find.text('Class 7 - Mirrors & Light'), findsOneWidget);
    expect(find.text('Class 6 - Shadows & Light'), findsOneWidget);
  });
}
