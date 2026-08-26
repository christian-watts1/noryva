enum CalculationSex { male, female }

enum ActivityLevel { low, light, moderate, high }

enum GoalKind {
  loseWeight,
  maintainWeight,
  gainWeight,
  buildMuscle,
  improveFitness,
  trackNutrition,
}

class EnergyInput {
  const EnergyInput({
    required this.sex,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activity,
    required this.goal,
    this.rateKgPerWeek,
  });
  final CalculationSex sex;
  final int age;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activity;
  final GoalKind goal;
  final double? rateKgPerWeek;
}

class EnergyPlan {
  const EnergyPlan({
    required this.bmr,
    required this.maintenanceCalories,
    required this.goalAdjustment,
    required this.dailyCalories,
    required this.proteinG,
    required this.carbohydrateG,
    required this.fatG,
    required this.wasClamped,
    this.clampReason,
  });
  final double bmr;
  final double maintenanceCalories;
  final double goalAdjustment;
  final double dailyCalories;
  final double proteinG;
  final double carbohydrateG;
  final double fatG;
  final bool wasClamped;
  final String? clampReason;
}

abstract final class EnergyCalculator {
  static const multipliers = {
    ActivityLevel.low: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.high: 1.725,
  };
  static const _kcalPerKg = 7700.0;

  static EnergyPlan calculate(EnergyInput input) {
    if (input.age < 18 ||
        input.age > 100 ||
        input.heightCm < 120 ||
        input.heightCm > 230 ||
        input.weightKg < 35 ||
        input.weightKg > 350) {
      throw ArgumentError(
        'Body information is outside supported sensible ranges.',
      );
    }
    if ((input.goal == GoalKind.loseWeight ||
            input.goal == GoalKind.gainWeight) &&
        !const [0.25, 0.5, 0.75].contains(input.rateKgPerWeek)) {
      throw ArgumentError('A supported goal rate is required.');
    }
    final sexOffset = input.sex == CalculationSex.male ? 5.0 : -161.0;
    final bmr =
        10 * input.weightKg + 6.25 * input.heightCm - 5 * input.age + sexOffset;
    final maintenance = bmr * multipliers[input.activity]!;
    final rateAdjustment = (input.rateKgPerWeek ?? 0) * _kcalPerKg / 7;
    final adjustment = switch (input.goal) {
      GoalKind.loseWeight => -rateAdjustment,
      GoalKind.gainWeight => rateAdjustment,
      GoalKind.buildMuscle => 200.0,
      _ => 0.0,
    };
    final floor = input.sex == CalculationSex.male ? 1500.0 : 1200.0;
    final raw = maintenance + adjustment;
    final calories = raw < floor ? floor : raw;
    final protein =
        input.weightKg *
        (input.goal == GoalKind.buildMuscle || input.goal == GoalKind.gainWeight
            ? 1.8
            : 1.6);
    final fat = input.weightKg * 0.8;
    final carbs = (calories - protein * 4 - fat * 9) / 4;
    return EnergyPlan(
      bmr: bmr,
      maintenanceCalories: maintenance,
      goalAdjustment: adjustment,
      dailyCalories: calories,
      proteinG: protein,
      carbohydrateG: carbs < 0 ? 0 : carbs,
      fatG: fat,
      wasClamped: raw < floor,
      clampReason: raw < floor
          ? 'The estimate was raised to the Phase 1 safety floor.'
          : null,
    );
  }
}
