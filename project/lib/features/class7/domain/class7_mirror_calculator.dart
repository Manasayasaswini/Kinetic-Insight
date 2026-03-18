enum MirrorType { concave, convex }

enum MirrorImageNature { real, virtual, atInfinity, invalid }

enum MirrorOrientation { inverted, erect, none }

enum MirrorSize { magnified, diminished, sameSize, undefined }

class PlaneMirrorResult {
  const PlaneMirrorResult({
    required this.objectDistanceCm,
    required this.imageDistanceCm,
    required this.isValid,
    required this.message,
  });

  final double objectDistanceCm;
  final double imageDistanceCm;
  final bool isValid;
  final String message;
}

class SphericalMirrorResult {
  const SphericalMirrorResult({
    required this.type,
    required this.objectDistanceCm,
    required this.focalLengthCm,
    required this.imageDistanceCm,
    required this.magnification,
    required this.nature,
    required this.orientation,
    required this.size,
    required this.isValid,
    required this.message,
  });

  final MirrorType type;
  final double objectDistanceCm;
  final double focalLengthCm;
  final double? imageDistanceCm;
  final double? magnification;
  final MirrorImageNature nature;
  final MirrorOrientation orientation;
  final MirrorSize size;
  final bool isValid;
  final String message;
}

class Class7MirrorCalculator {
  static PlaneMirrorResult calculatePlaneMirror(double objectDistanceCm) {
    if (objectDistanceCm <= 0) {
      return const PlaneMirrorResult(
        objectDistanceCm: 0,
        imageDistanceCm: 0,
        isValid: false,
        message: 'Object distance must be positive.',
      );
    }

    return PlaneMirrorResult(
      objectDistanceCm: objectDistanceCm,
      imageDistanceCm: objectDistanceCm,
      isValid: true,
      message: 'For a plane mirror, object distance equals image distance.',
    );
  }

  static SphericalMirrorResult calculateSphericalMirror({
    required MirrorType type,
    required double objectDistanceCm,
    required double focalLengthCm,
  }) {
    if (objectDistanceCm <= 0 || focalLengthCm <= 0) {
      return SphericalMirrorResult(
        type: type,
        objectDistanceCm: objectDistanceCm,
        focalLengthCm: focalLengthCm,
        imageDistanceCm: null,
        magnification: null,
        nature: MirrorImageNature.invalid,
        orientation: MirrorOrientation.none,
        size: MirrorSize.undefined,
        isValid: false,
        message: 'Object distance and focal length must be positive.',
      );
    }

    final u = -objectDistanceCm;
    final f = type == MirrorType.concave ? -focalLengthCm : focalLengthCm;
    final oneByV = (1 / f) - (1 / u);

    if (oneByV.abs() < 1e-9) {
      return SphericalMirrorResult(
        type: type,
        objectDistanceCm: objectDistanceCm,
        focalLengthCm: focalLengthCm,
        imageDistanceCm: null,
        magnification: null,
        nature: MirrorImageNature.atInfinity,
        orientation: MirrorOrientation.none,
        size: MirrorSize.undefined,
        isValid: true,
        message: 'Image forms at infinity (object at focus).',
      );
    }

    final v = 1 / oneByV;
    final m = -v / u;
    final nature = v < 0 ? MirrorImageNature.real : MirrorImageNature.virtual;
    final orientation = m < 0
        ? MirrorOrientation.inverted
        : MirrorOrientation.erect;

    MirrorSize size;
    final absM = m.abs();
    if ((absM - 1).abs() < 0.05) {
      size = MirrorSize.sameSize;
    } else if (absM > 1) {
      size = MirrorSize.magnified;
    } else {
      size = MirrorSize.diminished;
    }

    return SphericalMirrorResult(
      type: type,
      objectDistanceCm: objectDistanceCm,
      focalLengthCm: focalLengthCm,
      imageDistanceCm: v,
      magnification: m,
      nature: nature,
      orientation: orientation,
      size: size,
      isValid: true,
      message: 'Mirror formula applied: 1/f = 1/v + 1/u.',
    );
  }

  static double newtonDiscWhiteOpacity({
    required double speed,
    required double maxSpeed,
  }) {
    if (maxSpeed <= 0) return 0;
    return (speed / maxSpeed).clamp(0.0, 1.0);
  }
}
