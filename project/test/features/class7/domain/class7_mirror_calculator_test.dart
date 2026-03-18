import 'package:class11_flutter/features/class7/domain/class7_mirror_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Plane mirror', () {
    test('returns equal object and image distance', () {
      final result = Class7MirrorCalculator.calculatePlaneMirror(24);

      expect(result.isValid, isTrue);
      expect(result.imageDistanceCm, 24);
    });

    test('invalid when object distance is non-positive', () {
      final result = Class7MirrorCalculator.calculatePlaneMirror(0);
      expect(result.isValid, isFalse);
    });
  });

  group('Spherical mirror', () {
    test('concave beyond focus forms real inverted image', () {
      final result = Class7MirrorCalculator.calculateSphericalMirror(
        type: MirrorType.concave,
        objectDistanceCm: 30,
        focalLengthCm: 10,
      );

      expect(result.isValid, isTrue);
      expect(result.nature, MirrorImageNature.real);
      expect(result.orientation, MirrorOrientation.inverted);
      expect(result.imageDistanceCm, closeTo(-15, 0.3));
      expect(result.magnification, closeTo(-0.5, 0.1));
    });

    test('convex always forms virtual erect diminished image', () {
      final result = Class7MirrorCalculator.calculateSphericalMirror(
        type: MirrorType.convex,
        objectDistanceCm: 30,
        focalLengthCm: 10,
      );

      expect(result.isValid, isTrue);
      expect(result.nature, MirrorImageNature.virtual);
      expect(result.orientation, MirrorOrientation.erect);
      expect(result.size, MirrorSize.diminished);
    });
  });

  group('Newton disc blend', () {
    test('opacity clamps between 0 and 1', () {
      expect(
        Class7MirrorCalculator.newtonDiscWhiteOpacity(speed: 0, maxSpeed: 100),
        0,
      );
      expect(
        Class7MirrorCalculator.newtonDiscWhiteOpacity(
          speed: 130,
          maxSpeed: 100,
        ),
        1,
      );
    });
  });
}
