import 'package:flutter_test/flutter_test.dart';

import 'package:class11_flutter/app/kinetic_insight_app.dart';

void main() {
  testWidgets('renders class 11 lab shell content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KineticInsightApp());

    expect(
      find.textContaining('Build the learning platform once'),
      findsOneWidget,
    );
    expect(find.text('Class 11'), findsOneWidget);
    expect(find.text('Experiment 1: Critical Angle & TIR'), findsOneWidget);
  });
}
