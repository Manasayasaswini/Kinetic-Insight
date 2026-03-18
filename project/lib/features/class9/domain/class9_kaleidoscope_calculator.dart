import 'dart:math' as math;

class KaleidoscopeResult {
  const KaleidoscopeResult({
    required this.mirrorAngleDegrees,
    required this.numberOfSectors,
    required this.numberOfMirrors,
    required this.reflectionCount,
    required this.imageCount,
    required this.angleStepRadians,
    required this.isValid,
    required this.message,
  });

  final double mirrorAngleDegrees;
  final int numberOfSectors;
  final int numberOfMirrors;
  final int reflectionCount;
  final int imageCount;
  final double angleStepRadians;
  final bool isValid;
  final String message;
}

class KaleidoscopeCalculator {
  static KaleidoscopeResult calculateForTwoMirrors({
    required double mirrorAngleDegrees,
    required int numberOfMirrors,
  }) {
    if (mirrorAngleDegrees <= 0 || mirrorAngleDegrees >= 180) {
      return const KaleidoscopeResult(
        mirrorAngleDegrees: 0,
        numberOfSectors: 0,
        numberOfMirrors: 0,
        reflectionCount: 0,
        imageCount: 0,
        angleStepRadians: 0,
        isValid: false,
        message: 'Mirror angle must be between 0 and 180 degrees.',
      );
    }

    if (numberOfMirrors < 2 || numberOfMirrors > 6) {
      return const KaleidoscopeResult(
        mirrorAngleDegrees: 0,
        numberOfSectors: 0,
        numberOfMirrors: 0,
        reflectionCount: 0,
        imageCount: 0,
        angleStepRadians: 0,
        isValid: false,
        message: 'Number of mirrors must be between 2 and 6.',
      );
    }

    final sectors = 360 / mirrorAngleDegrees;
    final reflectionCount = (360 / mirrorAngleDegrees).floor();
    final angleStepRadians = (mirrorAngleDegrees * math.pi) / 180;
    final imageCount = numberOfMirrors > 2
        ? numberOfMirrors * reflectionCount
        : reflectionCount - 1;

    return KaleidoscopeResult(
      mirrorAngleDegrees: mirrorAngleDegrees,
      numberOfSectors: sectors.floor(),
      numberOfMirrors: numberOfMirrors,
      reflectionCount: reflectionCount,
      imageCount: imageCount,
      angleStepRadians: angleStepRadians,
      isValid: true,
      message:
          'Angle θ = $mirrorAngleDegrees° creates $sectors sectors. '
          'Each ray bounces $reflectionCount times.',
    );
  }

  static List<ReflectionPoint> simulateReflection({
    required double startAngleRadians,
    required double mirrorAngleRadians,
    required int numberOfMirrors,
    required double objectX,
    required double objectY,
    required double centerX,
    required double centerY,
  }) {
    final points = <ReflectionPoint>[];
    final numReflections = (math.pi * 2 / mirrorAngleRadians).floor();

    for (var i = 0; i < numReflections; i++) {
      final angle = startAngleRadians + (i * mirrorAngleRadians);
      final radius = 140.0;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      points.add(
        ReflectionPoint(
          x: x,
          y: y,
          angle: angle,
          isObject: i == 0,
          isReflection: i > 0,
        ),
      );
    }

    return points;
  }
}

class ReflectionPoint {
  const ReflectionPoint({
    required this.x,
    required this.y,
    required this.angle,
    required this.isObject,
    required this.isReflection,
  });

  final double x;
  final double y;
  final double angle;
  final bool isObject;
  final bool isReflection;
}
