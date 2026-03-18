import 'package:class11_flutter/features/class11/domain/class11_optics_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TIR calculation', () {
    test('returns refraction below critical angle', () {
      final result = Class11OpticsCalculator.calculateTir(
        mediumIndex: 1.5,
        incidentAngleDeg: 30,
      );

      expect(result.state, TirState.refraction);
      expect(result.refractionAngleDeg, isNotNull);
      expect(result.criticalAngleDeg, closeTo(41.8, 0.2));
    });

    test('returns critical state at critical angle', () {
      final critical = 41.81;
      final result = Class11OpticsCalculator.calculateTir(
        mediumIndex: 1.5,
        incidentAngleDeg: critical,
      );

      expect(result.state, TirState.critical);
      expect(result.refractionAngleDeg, closeTo(90, 0.2));
    });

    test('returns TIR above critical angle', () {
      final result = Class11OpticsCalculator.calculateTir(
        mediumIndex: 1.5,
        incidentAngleDeg: 50,
      );

      expect(result.state, TirState.totalInternalReflection);
      expect(result.refractionAngleDeg, isNull);
    });

    test('returns invalid for non-physical index', () {
      final result = Class11OpticsCalculator.calculateTir(
        mediumIndex: 1,
        incidentAngleDeg: 30,
      );

      expect(result.state, TirState.invalid);
      expect(result.isValid, isFalse);
    });
  });

  group('Prism calculation', () {
    test('computes refractive index for standard values', () {
      final result = Class11OpticsCalculator.calculatePrism(
        apexAngleDeg: 60,
        deviationAngleDeg: 40,
      );

      expect(result.isValid, isTrue);
      expect(result.refractiveIndex, closeTo(1.53, 0.02));
    });

    test('returns invalid for invalid apex angle', () {
      final result = Class11OpticsCalculator.calculatePrism(
        apexAngleDeg: 0,
        deviationAngleDeg: 30,
      );

      expect(result.isValid, isFalse);
      expect(result.refractiveIndex.isNaN, isTrue);
    });
  });

  group('Lens calculation', () {
    test('convex lens gives real inverted image when object beyond 2f', () {
      final result = Class11OpticsCalculator.calculateLens(
        type: LensType.convex,
        objectDistanceCm: 60,
        focalLengthCm: 20,
      );

      expect(result.isValid, isTrue);
      expect(result.imageNature, LensImageNature.real);
      expect(result.orientation, LensOrientation.inverted);
      expect(result.imageDistanceCm, closeTo(30, 0.2));
      expect(result.magnification, closeTo(-0.5, 0.05));
    });

    test('convex lens gives virtual upright image inside focal length', () {
      final result = Class11OpticsCalculator.calculateLens(
        type: LensType.convex,
        objectDistanceCm: 10,
        focalLengthCm: 20,
      );

      expect(result.isValid, isTrue);
      expect(result.imageNature, LensImageNature.virtual);
      expect(result.orientation, LensOrientation.upright);
      expect(result.magnification, greaterThan(1));
    });

    test('concave lens gives virtual upright diminished image', () {
      final result = Class11OpticsCalculator.calculateLens(
        type: LensType.concave,
        objectDistanceCm: 30,
        focalLengthCm: 20,
      );

      expect(result.isValid, isTrue);
      expect(result.imageNature, LensImageNature.virtual);
      expect(result.orientation, LensOrientation.upright);
      expect(result.size, LensSize.diminished);
    });

    test('returns invalid for non-positive distances', () {
      final result = Class11OpticsCalculator.calculateLens(
        type: LensType.convex,
        objectDistanceCm: 0,
        focalLengthCm: 20,
      );

      expect(result.isValid, isFalse);
      expect(result.imageNature, LensImageNature.invalid);
    });
  });
}
