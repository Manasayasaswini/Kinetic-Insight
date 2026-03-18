import 'dart:math' as math;

enum TirState { refraction, critical, totalInternalReflection, invalid }

enum LensType { convex, concave }

enum LensImageNature { real, virtual, atInfinity, invalid }

enum LensOrientation { inverted, upright, none }

enum LensSize { magnified, diminished, sameSize, undefined }

class TirResult {
  const TirResult({
    required this.state,
    required this.incidentAngleDeg,
    required this.mediumIndex,
    required this.criticalAngleDeg,
    required this.refractionAngleDeg,
    required this.reflectedAngleDeg,
    required this.message,
  });

  final TirState state;
  final double incidentAngleDeg;
  final double mediumIndex;
  final double criticalAngleDeg;
  final double? refractionAngleDeg;
  final double reflectedAngleDeg;
  final String message;

  bool get isValid => state != TirState.invalid;
}

class PrismResult {
  const PrismResult({
    required this.apexAngleDeg,
    required this.deviationAngleDeg,
    required this.refractiveIndex,
    required this.isValid,
    required this.message,
  });

  final double apexAngleDeg;
  final double deviationAngleDeg;
  final double refractiveIndex;
  final bool isValid;
  final String message;
}

class LensResult {
  const LensResult({
    required this.type,
    required this.objectDistanceCm,
    required this.focalLengthCm,
    required this.imageDistanceCm,
    required this.magnification,
    required this.imageNature,
    required this.orientation,
    required this.size,
    required this.message,
  });

  final LensType type;
  final double objectDistanceCm;
  final double focalLengthCm;
  final double? imageDistanceCm;
  final double? magnification;
  final LensImageNature imageNature;
  final LensOrientation orientation;
  final LensSize size;
  final String message;

  bool get isValid => imageNature != LensImageNature.invalid;
}

class Class11OpticsCalculator {
  static TirResult calculateTir({
    required double mediumIndex,
    required double incidentAngleDeg,
  }) {
    if (mediumIndex <= 1) {
      return TirResult(
        state: TirState.invalid,
        incidentAngleDeg: incidentAngleDeg,
        mediumIndex: mediumIndex,
        criticalAngleDeg: double.nan,
        refractionAngleDeg: null,
        reflectedAngleDeg: incidentAngleDeg,
        message: 'Set medium refractive index greater than 1.00.',
      );
    }
    if (incidentAngleDeg < 0 || incidentAngleDeg >= 90) {
      return TirResult(
        state: TirState.invalid,
        incidentAngleDeg: incidentAngleDeg,
        mediumIndex: mediumIndex,
        criticalAngleDeg: double.nan,
        refractionAngleDeg: null,
        reflectedAngleDeg: incidentAngleDeg,
        message: 'Incident angle must be between 0° and 90°.',
      );
    }

    final criticalAngleDeg = math.asin(1 / mediumIndex) * 180 / math.pi;
    final incidentRad = incidentAngleDeg * math.pi / 180;
    final sinRefraction = mediumIndex * math.sin(incidentRad);
    const epsilon = 0.1;

    if ((incidentAngleDeg - criticalAngleDeg).abs() <= epsilon) {
      return TirResult(
        state: TirState.critical,
        incidentAngleDeg: incidentAngleDeg,
        mediumIndex: mediumIndex,
        criticalAngleDeg: criticalAngleDeg,
        refractionAngleDeg: 90,
        reflectedAngleDeg: incidentAngleDeg,
        message:
            'At critical angle: refracted ray grazes the interface (r = 90°).',
      );
    }

    if (incidentAngleDeg > criticalAngleDeg || sinRefraction > 1) {
      return TirResult(
        state: TirState.totalInternalReflection,
        incidentAngleDeg: incidentAngleDeg,
        mediumIndex: mediumIndex,
        criticalAngleDeg: criticalAngleDeg,
        refractionAngleDeg: null,
        reflectedAngleDeg: incidentAngleDeg,
        message: 'Total internal reflection occurs (i > ic).',
      );
    }

    final refractionAngleDeg = math.asin(sinRefraction) * 180 / math.pi;
    return TirResult(
      state: TirState.refraction,
      incidentAngleDeg: incidentAngleDeg,
      mediumIndex: mediumIndex,
      criticalAngleDeg: criticalAngleDeg,
      refractionAngleDeg: refractionAngleDeg,
      reflectedAngleDeg: incidentAngleDeg,
      message: 'Refraction occurs from denser to rarer medium.',
    );
  }

  static PrismResult calculatePrism({
    required double apexAngleDeg,
    required double deviationAngleDeg,
  }) {
    final validAngles =
        apexAngleDeg > 0 && apexAngleDeg < 180 && deviationAngleDeg >= 0;
    if (!validAngles) {
      return PrismResult(
        apexAngleDeg: apexAngleDeg,
        deviationAngleDeg: deviationAngleDeg,
        refractiveIndex: double.nan,
        isValid: false,
        message: 'Provide valid angles: A in (0, 180), δ >= 0.',
      );
    }

    final a = apexAngleDeg * math.pi / 180;
    final d = deviationAngleDeg * math.pi / 180;
    final denominator = math.sin(a / 2);
    if (denominator == 0) {
      return PrismResult(
        apexAngleDeg: apexAngleDeg,
        deviationAngleDeg: deviationAngleDeg,
        refractiveIndex: double.nan,
        isValid: false,
        message: 'Apex angle cannot be 0°.',
      );
    }

    final refractiveIndex = math.sin((a + d) / 2) / denominator;
    final isPhysical = refractiveIndex >= 1;
    return PrismResult(
      apexAngleDeg: apexAngleDeg,
      deviationAngleDeg: deviationAngleDeg,
      refractiveIndex: refractiveIndex,
      isValid: isPhysical,
      message: isPhysical
          ? 'Refractive index computed using minimum deviation formula.'
          : 'Computed n < 1 is non-physical for a glass prism.',
    );
  }

  static LensResult calculateLens({
    required LensType type,
    required double objectDistanceCm,
    required double focalLengthCm,
  }) {
    if (objectDistanceCm <= 0 || focalLengthCm <= 0) {
      return LensResult(
        type: type,
        objectDistanceCm: objectDistanceCm,
        focalLengthCm: focalLengthCm,
        imageDistanceCm: null,
        magnification: null,
        imageNature: LensImageNature.invalid,
        orientation: LensOrientation.none,
        size: LensSize.undefined,
        message: 'Object distance and focal length must be positive.',
      );
    }

    final u = -objectDistanceCm;
    final f = type == LensType.convex ? focalLengthCm : -focalLengthCm;
    final denominator = (1 / f) + (1 / u);

    if (denominator.abs() < 1e-9) {
      return LensResult(
        type: type,
        objectDistanceCm: objectDistanceCm,
        focalLengthCm: focalLengthCm,
        imageDistanceCm: null,
        magnification: null,
        imageNature: LensImageNature.atInfinity,
        orientation: LensOrientation.none,
        size: LensSize.undefined,
        message: 'Image forms at infinity.',
      );
    }

    final v = 1 / denominator;
    final m = v / u;

    final imageNature = v > 0 ? LensImageNature.real : LensImageNature.virtual;
    final orientation = m < 0
        ? LensOrientation.inverted
        : LensOrientation.upright;

    LensSize size;
    final magAbs = m.abs();
    if ((magAbs - 1).abs() < 0.05) {
      size = LensSize.sameSize;
    } else if (magAbs > 1) {
      size = LensSize.magnified;
    } else {
      size = LensSize.diminished;
    }

    return LensResult(
      type: type,
      objectDistanceCm: objectDistanceCm,
      focalLengthCm: focalLengthCm,
      imageDistanceCm: v,
      magnification: m,
      imageNature: imageNature,
      orientation: orientation,
      size: size,
      message: 'Lens equation applied with Cartesian sign convention.',
    );
  }
}
