import 'package:class11_flutter/features/class11/presentation/class11_lab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('class 11 lab renders calculator controls', (tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Class11LabScreen())),
    );

    expect(find.text('Experiment 1: Critical Angle & TIR'), findsOneWidget);
    expect(find.text('Calculate'), findsOneWidget);
    expect(find.textContaining('Critical angle ic'), findsOneWidget);
  });

  testWidgets('lens experiment supports student input and output', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Class11LabScreen())),
    );

    await tester.tap(find.text('Experiment 3: Lens Image Formation'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Object distance |u| (cm)'),
      '40',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Focal length |f| (cm)'),
      '20',
    );
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Nature = Real'), findsOneWidget);
    expect(find.textContaining('Magnification m = -1.00'), findsOneWidget);
  });
}
