import 'package:class11_flutter/features/class7/presentation/class7_lab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('class 7 screen renders spec section', (tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Class7LabScreen())),
    );

    expect(find.text('Class 7 - Mirrors and Light'), findsOneWidget);
    expect(find.text('Student Spec Document'), findsOneWidget);

    await tester.tap(find.text("Newton's Disc"));
    await tester.pump();
    expect(find.text('Ask AI'), findsOneWidget);
    expect(find.text('Submit Answer'), findsOneWidget);
    expect(
      find.text(
        'At very high speed, colors blend and the disc appears nearly white.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('spherical mirror experiment calculates output', (tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Class7LabScreen())),
    );

    await tester.tap(find.text('Spherical Mirrors'));
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(TextField, 'Object distance |u| (cm)'),
      '30',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Focal length |f| (cm)'),
      '10',
    );
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    expect(find.textContaining('Nature = Real'), findsOneWidget);
    expect(find.textContaining('Orientation = Inverted'), findsOneWidget);
  });
}
