// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _anonymousUserIdMeta = const VerificationMeta(
    'anonymousUserId',
  );
  @override
  late final GeneratedColumn<String> anonymousUserId = GeneratedColumn<String>(
    'anonymous_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceCreatedAtMeta = const VerificationMeta(
    'deviceCreatedAt',
  );
  @override
  late final GeneratedColumn<String> deviceCreatedAt = GeneratedColumn<String>(
    'device_created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _onboardingStepMeta = const VerificationMeta(
    'onboardingStep',
  );
  @override
  late final GeneratedColumn<int> onboardingStep = GeneratedColumn<int>(
    'onboarding_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calculationSexMeta = const VerificationMeta(
    'calculationSex',
  );
  @override
  late final GeneratedColumn<String> calculationSex = GeneratedColumn<String>(
    'calculation_sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityMeta = const VerificationMeta(
    'activity',
  );
  @override
  late final GeneratedColumn<String> activity = GeneratedColumn<String>(
    'activity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalWeightKgMeta = const VerificationMeta(
    'goalWeightKg',
  );
  @override
  late final GeneratedColumn<double> goalWeightKg = GeneratedColumn<double>(
    'goal_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rateKgWeekMeta = const VerificationMeta(
    'rateKgWeek',
  );
  @override
  late final GeneratedColumn<double> rateKgWeek = GeneratedColumn<double>(
    'rate_kg_week',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bmrMeta = const VerificationMeta('bmr');
  @override
  late final GeneratedColumn<double> bmr = GeneratedColumn<double>(
    'bmr',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maintenanceCaloriesMeta =
      const VerificationMeta('maintenanceCalories');
  @override
  late final GeneratedColumn<double> maintenanceCalories =
      GeneratedColumn<double>(
        'maintenance_calories',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _goalAdjustmentMeta = const VerificationMeta(
    'goalAdjustment',
  );
  @override
  late final GeneratedColumn<double> goalAdjustment = GeneratedColumn<double>(
    'goal_adjustment',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calorieTargetMeta = const VerificationMeta(
    'calorieTarget',
  );
  @override
  late final GeneratedColumn<double> calorieTarget = GeneratedColumn<double>(
    'calorie_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinTargetMeta = const VerificationMeta(
    'proteinTarget',
  );
  @override
  late final GeneratedColumn<double> proteinTarget = GeneratedColumn<double>(
    'protein_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbohydrateTargetMeta =
      const VerificationMeta('carbohydrateTarget');
  @override
  late final GeneratedColumn<double> carbohydrateTarget =
      GeneratedColumn<double>(
        'carbohydrate_target',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fatTargetMeta = const VerificationMeta(
    'fatTarget',
  );
  @override
  late final GeneratedColumn<double> fatTarget = GeneratedColumn<double>(
    'fat_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetClampedMeta = const VerificationMeta(
    'targetClamped',
  );
  @override
  late final GeneratedColumn<bool> targetClamped = GeneratedColumn<bool>(
    'target_clamped',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("target_clamped" IN (0, 1))',
    ),
  );
  static const VerificationMeta _clampReasonMeta = const VerificationMeta(
    'clampReason',
  );
  @override
  late final GeneratedColumn<String> clampReason = GeneratedColumn<String>(
    'clamp_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    anonymousUserId,
    deviceCreatedAt,
    onboardingCompleted,
    onboardingStep,
    goal,
    dateOfBirth,
    calculationSex,
    heightCm,
    weightKg,
    activity,
    goalWeightKg,
    rateKgWeek,
    bmr,
    maintenanceCalories,
    goalAdjustment,
    calorieTarget,
    proteinTarget,
    carbohydrateTarget,
    fatTarget,
    targetClamped,
    clampReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('anonymous_user_id')) {
      context.handle(
        _anonymousUserIdMeta,
        anonymousUserId.isAcceptableOrUnknown(
          data['anonymous_user_id']!,
          _anonymousUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_anonymousUserIdMeta);
    }
    if (data.containsKey('device_created_at')) {
      context.handle(
        _deviceCreatedAtMeta,
        deviceCreatedAt.isAcceptableOrUnknown(
          data['device_created_at']!,
          _deviceCreatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deviceCreatedAtMeta);
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onboardingCompletedMeta);
    }
    if (data.containsKey('onboarding_step')) {
      context.handle(
        _onboardingStepMeta,
        onboardingStep.isAcceptableOrUnknown(
          data['onboarding_step']!,
          _onboardingStepMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onboardingStepMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('calculation_sex')) {
      context.handle(
        _calculationSexMeta,
        calculationSex.isAcceptableOrUnknown(
          data['calculation_sex']!,
          _calculationSexMeta,
        ),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('activity')) {
      context.handle(
        _activityMeta,
        activity.isAcceptableOrUnknown(data['activity']!, _activityMeta),
      );
    }
    if (data.containsKey('goal_weight_kg')) {
      context.handle(
        _goalWeightKgMeta,
        goalWeightKg.isAcceptableOrUnknown(
          data['goal_weight_kg']!,
          _goalWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('rate_kg_week')) {
      context.handle(
        _rateKgWeekMeta,
        rateKgWeek.isAcceptableOrUnknown(
          data['rate_kg_week']!,
          _rateKgWeekMeta,
        ),
      );
    }
    if (data.containsKey('bmr')) {
      context.handle(
        _bmrMeta,
        bmr.isAcceptableOrUnknown(data['bmr']!, _bmrMeta),
      );
    }
    if (data.containsKey('maintenance_calories')) {
      context.handle(
        _maintenanceCaloriesMeta,
        maintenanceCalories.isAcceptableOrUnknown(
          data['maintenance_calories']!,
          _maintenanceCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('goal_adjustment')) {
      context.handle(
        _goalAdjustmentMeta,
        goalAdjustment.isAcceptableOrUnknown(
          data['goal_adjustment']!,
          _goalAdjustmentMeta,
        ),
      );
    }
    if (data.containsKey('calorie_target')) {
      context.handle(
        _calorieTargetMeta,
        calorieTarget.isAcceptableOrUnknown(
          data['calorie_target']!,
          _calorieTargetMeta,
        ),
      );
    }
    if (data.containsKey('protein_target')) {
      context.handle(
        _proteinTargetMeta,
        proteinTarget.isAcceptableOrUnknown(
          data['protein_target']!,
          _proteinTargetMeta,
        ),
      );
    }
    if (data.containsKey('carbohydrate_target')) {
      context.handle(
        _carbohydrateTargetMeta,
        carbohydrateTarget.isAcceptableOrUnknown(
          data['carbohydrate_target']!,
          _carbohydrateTargetMeta,
        ),
      );
    }
    if (data.containsKey('fat_target')) {
      context.handle(
        _fatTargetMeta,
        fatTarget.isAcceptableOrUnknown(data['fat_target']!, _fatTargetMeta),
      );
    }
    if (data.containsKey('target_clamped')) {
      context.handle(
        _targetClampedMeta,
        targetClamped.isAcceptableOrUnknown(
          data['target_clamped']!,
          _targetClampedMeta,
        ),
      );
    }
    if (data.containsKey('clamp_reason')) {
      context.handle(
        _clampReasonMeta,
        clampReason.isAcceptableOrUnknown(
          data['clamp_reason']!,
          _clampReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {anonymousUserId};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      anonymousUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anonymous_user_id'],
      )!,
      deviceCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_created_at'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      onboardingStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onboarding_step'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_of_birth'],
      ),
      calculationSex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculation_sex'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      activity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity'],
      ),
      goalWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}goal_weight_kg'],
      ),
      rateKgWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_kg_week'],
      ),
      bmr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bmr'],
      ),
      maintenanceCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}maintenance_calories'],
      ),
      goalAdjustment: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}goal_adjustment'],
      ),
      calorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calorie_target'],
      ),
      proteinTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_target'],
      ),
      carbohydrateTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbohydrate_target'],
      ),
      fatTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_target'],
      ),
      targetClamped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}target_clamped'],
      ),
      clampReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clamp_reason'],
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String anonymousUserId;
  final String deviceCreatedAt;
  final bool onboardingCompleted;
  final int onboardingStep;
  final String? goal;
  final String? dateOfBirth;
  final String? calculationSex;
  final double? heightCm;
  final double? weightKg;
  final String? activity;
  final double? goalWeightKg;
  final double? rateKgWeek;
  final double? bmr;
  final double? maintenanceCalories;
  final double? goalAdjustment;
  final double? calorieTarget;
  final double? proteinTarget;
  final double? carbohydrateTarget;
  final double? fatTarget;
  final bool? targetClamped;
  final String? clampReason;
  const ProfileRow({
    required this.anonymousUserId,
    required this.deviceCreatedAt,
    required this.onboardingCompleted,
    required this.onboardingStep,
    this.goal,
    this.dateOfBirth,
    this.calculationSex,
    this.heightCm,
    this.weightKg,
    this.activity,
    this.goalWeightKg,
    this.rateKgWeek,
    this.bmr,
    this.maintenanceCalories,
    this.goalAdjustment,
    this.calorieTarget,
    this.proteinTarget,
    this.carbohydrateTarget,
    this.fatTarget,
    this.targetClamped,
    this.clampReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['anonymous_user_id'] = Variable<String>(anonymousUserId);
    map['device_created_at'] = Variable<String>(deviceCreatedAt);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['onboarding_step'] = Variable<int>(onboardingStep);
    if (!nullToAbsent || goal != null) {
      map['goal'] = Variable<String>(goal);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    if (!nullToAbsent || calculationSex != null) {
      map['calculation_sex'] = Variable<String>(calculationSex);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || activity != null) {
      map['activity'] = Variable<String>(activity);
    }
    if (!nullToAbsent || goalWeightKg != null) {
      map['goal_weight_kg'] = Variable<double>(goalWeightKg);
    }
    if (!nullToAbsent || rateKgWeek != null) {
      map['rate_kg_week'] = Variable<double>(rateKgWeek);
    }
    if (!nullToAbsent || bmr != null) {
      map['bmr'] = Variable<double>(bmr);
    }
    if (!nullToAbsent || maintenanceCalories != null) {
      map['maintenance_calories'] = Variable<double>(maintenanceCalories);
    }
    if (!nullToAbsent || goalAdjustment != null) {
      map['goal_adjustment'] = Variable<double>(goalAdjustment);
    }
    if (!nullToAbsent || calorieTarget != null) {
      map['calorie_target'] = Variable<double>(calorieTarget);
    }
    if (!nullToAbsent || proteinTarget != null) {
      map['protein_target'] = Variable<double>(proteinTarget);
    }
    if (!nullToAbsent || carbohydrateTarget != null) {
      map['carbohydrate_target'] = Variable<double>(carbohydrateTarget);
    }
    if (!nullToAbsent || fatTarget != null) {
      map['fat_target'] = Variable<double>(fatTarget);
    }
    if (!nullToAbsent || targetClamped != null) {
      map['target_clamped'] = Variable<bool>(targetClamped);
    }
    if (!nullToAbsent || clampReason != null) {
      map['clamp_reason'] = Variable<String>(clampReason);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      anonymousUserId: Value(anonymousUserId),
      deviceCreatedAt: Value(deviceCreatedAt),
      onboardingCompleted: Value(onboardingCompleted),
      onboardingStep: Value(onboardingStep),
      goal: goal == null && nullToAbsent ? const Value.absent() : Value(goal),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      calculationSex: calculationSex == null && nullToAbsent
          ? const Value.absent()
          : Value(calculationSex),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      activity: activity == null && nullToAbsent
          ? const Value.absent()
          : Value(activity),
      goalWeightKg: goalWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(goalWeightKg),
      rateKgWeek: rateKgWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(rateKgWeek),
      bmr: bmr == null && nullToAbsent ? const Value.absent() : Value(bmr),
      maintenanceCalories: maintenanceCalories == null && nullToAbsent
          ? const Value.absent()
          : Value(maintenanceCalories),
      goalAdjustment: goalAdjustment == null && nullToAbsent
          ? const Value.absent()
          : Value(goalAdjustment),
      calorieTarget: calorieTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieTarget),
      proteinTarget: proteinTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinTarget),
      carbohydrateTarget: carbohydrateTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(carbohydrateTarget),
      fatTarget: fatTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(fatTarget),
      targetClamped: targetClamped == null && nullToAbsent
          ? const Value.absent()
          : Value(targetClamped),
      clampReason: clampReason == null && nullToAbsent
          ? const Value.absent()
          : Value(clampReason),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      anonymousUserId: serializer.fromJson<String>(json['anonymousUserId']),
      deviceCreatedAt: serializer.fromJson<String>(json['deviceCreatedAt']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      onboardingStep: serializer.fromJson<int>(json['onboardingStep']),
      goal: serializer.fromJson<String?>(json['goal']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      calculationSex: serializer.fromJson<String?>(json['calculationSex']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      activity: serializer.fromJson<String?>(json['activity']),
      goalWeightKg: serializer.fromJson<double?>(json['goalWeightKg']),
      rateKgWeek: serializer.fromJson<double?>(json['rateKgWeek']),
      bmr: serializer.fromJson<double?>(json['bmr']),
      maintenanceCalories: serializer.fromJson<double?>(
        json['maintenanceCalories'],
      ),
      goalAdjustment: serializer.fromJson<double?>(json['goalAdjustment']),
      calorieTarget: serializer.fromJson<double?>(json['calorieTarget']),
      proteinTarget: serializer.fromJson<double?>(json['proteinTarget']),
      carbohydrateTarget: serializer.fromJson<double?>(
        json['carbohydrateTarget'],
      ),
      fatTarget: serializer.fromJson<double?>(json['fatTarget']),
      targetClamped: serializer.fromJson<bool?>(json['targetClamped']),
      clampReason: serializer.fromJson<String?>(json['clampReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'anonymousUserId': serializer.toJson<String>(anonymousUserId),
      'deviceCreatedAt': serializer.toJson<String>(deviceCreatedAt),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'onboardingStep': serializer.toJson<int>(onboardingStep),
      'goal': serializer.toJson<String?>(goal),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'calculationSex': serializer.toJson<String?>(calculationSex),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'activity': serializer.toJson<String?>(activity),
      'goalWeightKg': serializer.toJson<double?>(goalWeightKg),
      'rateKgWeek': serializer.toJson<double?>(rateKgWeek),
      'bmr': serializer.toJson<double?>(bmr),
      'maintenanceCalories': serializer.toJson<double?>(maintenanceCalories),
      'goalAdjustment': serializer.toJson<double?>(goalAdjustment),
      'calorieTarget': serializer.toJson<double?>(calorieTarget),
      'proteinTarget': serializer.toJson<double?>(proteinTarget),
      'carbohydrateTarget': serializer.toJson<double?>(carbohydrateTarget),
      'fatTarget': serializer.toJson<double?>(fatTarget),
      'targetClamped': serializer.toJson<bool?>(targetClamped),
      'clampReason': serializer.toJson<String?>(clampReason),
    };
  }

  ProfileRow copyWith({
    String? anonymousUserId,
    String? deviceCreatedAt,
    bool? onboardingCompleted,
    int? onboardingStep,
    Value<String?> goal = const Value.absent(),
    Value<String?> dateOfBirth = const Value.absent(),
    Value<String?> calculationSex = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<String?> activity = const Value.absent(),
    Value<double?> goalWeightKg = const Value.absent(),
    Value<double?> rateKgWeek = const Value.absent(),
    Value<double?> bmr = const Value.absent(),
    Value<double?> maintenanceCalories = const Value.absent(),
    Value<double?> goalAdjustment = const Value.absent(),
    Value<double?> calorieTarget = const Value.absent(),
    Value<double?> proteinTarget = const Value.absent(),
    Value<double?> carbohydrateTarget = const Value.absent(),
    Value<double?> fatTarget = const Value.absent(),
    Value<bool?> targetClamped = const Value.absent(),
    Value<String?> clampReason = const Value.absent(),
  }) => ProfileRow(
    anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    deviceCreatedAt: deviceCreatedAt ?? this.deviceCreatedAt,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    onboardingStep: onboardingStep ?? this.onboardingStep,
    goal: goal.present ? goal.value : this.goal,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    calculationSex: calculationSex.present
        ? calculationSex.value
        : this.calculationSex,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    activity: activity.present ? activity.value : this.activity,
    goalWeightKg: goalWeightKg.present ? goalWeightKg.value : this.goalWeightKg,
    rateKgWeek: rateKgWeek.present ? rateKgWeek.value : this.rateKgWeek,
    bmr: bmr.present ? bmr.value : this.bmr,
    maintenanceCalories: maintenanceCalories.present
        ? maintenanceCalories.value
        : this.maintenanceCalories,
    goalAdjustment: goalAdjustment.present
        ? goalAdjustment.value
        : this.goalAdjustment,
    calorieTarget: calorieTarget.present
        ? calorieTarget.value
        : this.calorieTarget,
    proteinTarget: proteinTarget.present
        ? proteinTarget.value
        : this.proteinTarget,
    carbohydrateTarget: carbohydrateTarget.present
        ? carbohydrateTarget.value
        : this.carbohydrateTarget,
    fatTarget: fatTarget.present ? fatTarget.value : this.fatTarget,
    targetClamped: targetClamped.present
        ? targetClamped.value
        : this.targetClamped,
    clampReason: clampReason.present ? clampReason.value : this.clampReason,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      anonymousUserId: data.anonymousUserId.present
          ? data.anonymousUserId.value
          : this.anonymousUserId,
      deviceCreatedAt: data.deviceCreatedAt.present
          ? data.deviceCreatedAt.value
          : this.deviceCreatedAt,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      onboardingStep: data.onboardingStep.present
          ? data.onboardingStep.value
          : this.onboardingStep,
      goal: data.goal.present ? data.goal.value : this.goal,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      calculationSex: data.calculationSex.present
          ? data.calculationSex.value
          : this.calculationSex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      activity: data.activity.present ? data.activity.value : this.activity,
      goalWeightKg: data.goalWeightKg.present
          ? data.goalWeightKg.value
          : this.goalWeightKg,
      rateKgWeek: data.rateKgWeek.present
          ? data.rateKgWeek.value
          : this.rateKgWeek,
      bmr: data.bmr.present ? data.bmr.value : this.bmr,
      maintenanceCalories: data.maintenanceCalories.present
          ? data.maintenanceCalories.value
          : this.maintenanceCalories,
      goalAdjustment: data.goalAdjustment.present
          ? data.goalAdjustment.value
          : this.goalAdjustment,
      calorieTarget: data.calorieTarget.present
          ? data.calorieTarget.value
          : this.calorieTarget,
      proteinTarget: data.proteinTarget.present
          ? data.proteinTarget.value
          : this.proteinTarget,
      carbohydrateTarget: data.carbohydrateTarget.present
          ? data.carbohydrateTarget.value
          : this.carbohydrateTarget,
      fatTarget: data.fatTarget.present ? data.fatTarget.value : this.fatTarget,
      targetClamped: data.targetClamped.present
          ? data.targetClamped.value
          : this.targetClamped,
      clampReason: data.clampReason.present
          ? data.clampReason.value
          : this.clampReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('anonymousUserId: $anonymousUserId, ')
          ..write('deviceCreatedAt: $deviceCreatedAt, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('onboardingStep: $onboardingStep, ')
          ..write('goal: $goal, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('calculationSex: $calculationSex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('activity: $activity, ')
          ..write('goalWeightKg: $goalWeightKg, ')
          ..write('rateKgWeek: $rateKgWeek, ')
          ..write('bmr: $bmr, ')
          ..write('maintenanceCalories: $maintenanceCalories, ')
          ..write('goalAdjustment: $goalAdjustment, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('carbohydrateTarget: $carbohydrateTarget, ')
          ..write('fatTarget: $fatTarget, ')
          ..write('targetClamped: $targetClamped, ')
          ..write('clampReason: $clampReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    anonymousUserId,
    deviceCreatedAt,
    onboardingCompleted,
    onboardingStep,
    goal,
    dateOfBirth,
    calculationSex,
    heightCm,
    weightKg,
    activity,
    goalWeightKg,
    rateKgWeek,
    bmr,
    maintenanceCalories,
    goalAdjustment,
    calorieTarget,
    proteinTarget,
    carbohydrateTarget,
    fatTarget,
    targetClamped,
    clampReason,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.anonymousUserId == this.anonymousUserId &&
          other.deviceCreatedAt == this.deviceCreatedAt &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.onboardingStep == this.onboardingStep &&
          other.goal == this.goal &&
          other.dateOfBirth == this.dateOfBirth &&
          other.calculationSex == this.calculationSex &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.activity == this.activity &&
          other.goalWeightKg == this.goalWeightKg &&
          other.rateKgWeek == this.rateKgWeek &&
          other.bmr == this.bmr &&
          other.maintenanceCalories == this.maintenanceCalories &&
          other.goalAdjustment == this.goalAdjustment &&
          other.calorieTarget == this.calorieTarget &&
          other.proteinTarget == this.proteinTarget &&
          other.carbohydrateTarget == this.carbohydrateTarget &&
          other.fatTarget == this.fatTarget &&
          other.targetClamped == this.targetClamped &&
          other.clampReason == this.clampReason);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> anonymousUserId;
  final Value<String> deviceCreatedAt;
  final Value<bool> onboardingCompleted;
  final Value<int> onboardingStep;
  final Value<String?> goal;
  final Value<String?> dateOfBirth;
  final Value<String?> calculationSex;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<String?> activity;
  final Value<double?> goalWeightKg;
  final Value<double?> rateKgWeek;
  final Value<double?> bmr;
  final Value<double?> maintenanceCalories;
  final Value<double?> goalAdjustment;
  final Value<double?> calorieTarget;
  final Value<double?> proteinTarget;
  final Value<double?> carbohydrateTarget;
  final Value<double?> fatTarget;
  final Value<bool?> targetClamped;
  final Value<String?> clampReason;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.anonymousUserId = const Value.absent(),
    this.deviceCreatedAt = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.onboardingStep = const Value.absent(),
    this.goal = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.calculationSex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activity = const Value.absent(),
    this.goalWeightKg = const Value.absent(),
    this.rateKgWeek = const Value.absent(),
    this.bmr = const Value.absent(),
    this.maintenanceCalories = const Value.absent(),
    this.goalAdjustment = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTarget = const Value.absent(),
    this.carbohydrateTarget = const Value.absent(),
    this.fatTarget = const Value.absent(),
    this.targetClamped = const Value.absent(),
    this.clampReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String anonymousUserId,
    required String deviceCreatedAt,
    required bool onboardingCompleted,
    required int onboardingStep,
    this.goal = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.calculationSex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activity = const Value.absent(),
    this.goalWeightKg = const Value.absent(),
    this.rateKgWeek = const Value.absent(),
    this.bmr = const Value.absent(),
    this.maintenanceCalories = const Value.absent(),
    this.goalAdjustment = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTarget = const Value.absent(),
    this.carbohydrateTarget = const Value.absent(),
    this.fatTarget = const Value.absent(),
    this.targetClamped = const Value.absent(),
    this.clampReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : anonymousUserId = Value(anonymousUserId),
       deviceCreatedAt = Value(deviceCreatedAt),
       onboardingCompleted = Value(onboardingCompleted),
       onboardingStep = Value(onboardingStep);
  static Insertable<ProfileRow> custom({
    Expression<String>? anonymousUserId,
    Expression<String>? deviceCreatedAt,
    Expression<bool>? onboardingCompleted,
    Expression<int>? onboardingStep,
    Expression<String>? goal,
    Expression<String>? dateOfBirth,
    Expression<String>? calculationSex,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? activity,
    Expression<double>? goalWeightKg,
    Expression<double>? rateKgWeek,
    Expression<double>? bmr,
    Expression<double>? maintenanceCalories,
    Expression<double>? goalAdjustment,
    Expression<double>? calorieTarget,
    Expression<double>? proteinTarget,
    Expression<double>? carbohydrateTarget,
    Expression<double>? fatTarget,
    Expression<bool>? targetClamped,
    Expression<String>? clampReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (anonymousUserId != null) 'anonymous_user_id': anonymousUserId,
      if (deviceCreatedAt != null) 'device_created_at': deviceCreatedAt,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (onboardingStep != null) 'onboarding_step': onboardingStep,
      if (goal != null) 'goal': goal,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (calculationSex != null) 'calculation_sex': calculationSex,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (activity != null) 'activity': activity,
      if (goalWeightKg != null) 'goal_weight_kg': goalWeightKg,
      if (rateKgWeek != null) 'rate_kg_week': rateKgWeek,
      if (bmr != null) 'bmr': bmr,
      if (maintenanceCalories != null)
        'maintenance_calories': maintenanceCalories,
      if (goalAdjustment != null) 'goal_adjustment': goalAdjustment,
      if (calorieTarget != null) 'calorie_target': calorieTarget,
      if (proteinTarget != null) 'protein_target': proteinTarget,
      if (carbohydrateTarget != null) 'carbohydrate_target': carbohydrateTarget,
      if (fatTarget != null) 'fat_target': fatTarget,
      if (targetClamped != null) 'target_clamped': targetClamped,
      if (clampReason != null) 'clamp_reason': clampReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? anonymousUserId,
    Value<String>? deviceCreatedAt,
    Value<bool>? onboardingCompleted,
    Value<int>? onboardingStep,
    Value<String?>? goal,
    Value<String?>? dateOfBirth,
    Value<String?>? calculationSex,
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<String?>? activity,
    Value<double?>? goalWeightKg,
    Value<double?>? rateKgWeek,
    Value<double?>? bmr,
    Value<double?>? maintenanceCalories,
    Value<double?>? goalAdjustment,
    Value<double?>? calorieTarget,
    Value<double?>? proteinTarget,
    Value<double?>? carbohydrateTarget,
    Value<double?>? fatTarget,
    Value<bool?>? targetClamped,
    Value<String?>? clampReason,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      deviceCreatedAt: deviceCreatedAt ?? this.deviceCreatedAt,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      goal: goal ?? this.goal,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      calculationSex: calculationSex ?? this.calculationSex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activity: activity ?? this.activity,
      goalWeightKg: goalWeightKg ?? this.goalWeightKg,
      rateKgWeek: rateKgWeek ?? this.rateKgWeek,
      bmr: bmr ?? this.bmr,
      maintenanceCalories: maintenanceCalories ?? this.maintenanceCalories,
      goalAdjustment: goalAdjustment ?? this.goalAdjustment,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbohydrateTarget: carbohydrateTarget ?? this.carbohydrateTarget,
      fatTarget: fatTarget ?? this.fatTarget,
      targetClamped: targetClamped ?? this.targetClamped,
      clampReason: clampReason ?? this.clampReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (anonymousUserId.present) {
      map['anonymous_user_id'] = Variable<String>(anonymousUserId.value);
    }
    if (deviceCreatedAt.present) {
      map['device_created_at'] = Variable<String>(deviceCreatedAt.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (onboardingStep.present) {
      map['onboarding_step'] = Variable<int>(onboardingStep.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (calculationSex.present) {
      map['calculation_sex'] = Variable<String>(calculationSex.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(activity.value);
    }
    if (goalWeightKg.present) {
      map['goal_weight_kg'] = Variable<double>(goalWeightKg.value);
    }
    if (rateKgWeek.present) {
      map['rate_kg_week'] = Variable<double>(rateKgWeek.value);
    }
    if (bmr.present) {
      map['bmr'] = Variable<double>(bmr.value);
    }
    if (maintenanceCalories.present) {
      map['maintenance_calories'] = Variable<double>(maintenanceCalories.value);
    }
    if (goalAdjustment.present) {
      map['goal_adjustment'] = Variable<double>(goalAdjustment.value);
    }
    if (calorieTarget.present) {
      map['calorie_target'] = Variable<double>(calorieTarget.value);
    }
    if (proteinTarget.present) {
      map['protein_target'] = Variable<double>(proteinTarget.value);
    }
    if (carbohydrateTarget.present) {
      map['carbohydrate_target'] = Variable<double>(carbohydrateTarget.value);
    }
    if (fatTarget.present) {
      map['fat_target'] = Variable<double>(fatTarget.value);
    }
    if (targetClamped.present) {
      map['target_clamped'] = Variable<bool>(targetClamped.value);
    }
    if (clampReason.present) {
      map['clamp_reason'] = Variable<String>(clampReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('anonymousUserId: $anonymousUserId, ')
          ..write('deviceCreatedAt: $deviceCreatedAt, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('onboardingStep: $onboardingStep, ')
          ..write('goal: $goal, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('calculationSex: $calculationSex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('activity: $activity, ')
          ..write('goalWeightKg: $goalWeightKg, ')
          ..write('rateKgWeek: $rateKgWeek, ')
          ..write('bmr: $bmr, ')
          ..write('maintenanceCalories: $maintenanceCalories, ')
          ..write('goalAdjustment: $goalAdjustment, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('carbohydrateTarget: $carbohydrateTarget, ')
          ..write('fatTarget: $fatTarget, ')
          ..write('targetClamped: $targetClamped, ')
          ..write('clampReason: $clampReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodsTable extends Foods with TableInfo<$FoodsTable, FoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<double> energy = GeneratedColumn<double>(
    'energy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbohydrateMeta = const VerificationMeta(
    'carbohydrate',
  );
  @override
  late final GeneratedColumn<double> carbohydrate = GeneratedColumn<double>(
    'carbohydrate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fibreMeta = const VerificationMeta('fibre');
  @override
  late final GeneratedColumn<double> fibre = GeneratedColumn<double>(
    'fibre',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
    'sugar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<double> salt = GeneratedColumn<double>(
    'salt',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commonServingMeta = const VerificationMeta(
    'commonServing',
  );
  @override
  late final GeneratedColumn<String> commonServing = GeneratedColumn<String>(
    'common_serving',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commonServingGramsMeta =
      const VerificationMeta('commonServingGrams');
  @override
  late final GeneratedColumn<double> commonServingGrams =
      GeneratedColumn<double>(
        'common_serving_grams',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isCommonMeta = const VerificationMeta(
    'isCommon',
  );
  @override
  late final GeneratedColumn<bool> isCommon = GeneratedColumn<bool>(
    'is_common',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_common" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basisUnitMeta = const VerificationMeta(
    'basisUnit',
  );
  @override
  late final GeneratedColumn<String> basisUnit = GeneratedColumn<String>(
    'basis_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('g'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    source,
    verificationStatus,
    barcode,
    energy,
    protein,
    carbohydrate,
    fat,
    fibre,
    sugar,
    salt,
    commonServing,
    commonServingGrams,
    isCommon,
    createdAt,
    updatedAt,
    basisUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('verification_status')) {
      context.handle(
        _verificationStatusMeta,
        verificationStatus.isAcceptableOrUnknown(
          data['verification_status']!,
          _verificationStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verificationStatusMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('energy')) {
      context.handle(
        _energyMeta,
        energy.isAcceptableOrUnknown(data['energy']!, _energyMeta),
      );
    } else if (isInserting) {
      context.missing(_energyMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbohydrate')) {
      context.handle(
        _carbohydrateMeta,
        carbohydrate.isAcceptableOrUnknown(
          data['carbohydrate']!,
          _carbohydrateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbohydrateMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('fibre')) {
      context.handle(
        _fibreMeta,
        fibre.isAcceptableOrUnknown(data['fibre']!, _fibreMeta),
      );
    } else if (isInserting) {
      context.missing(_fibreMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(
        _sugarMeta,
        sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta),
      );
    } else if (isInserting) {
      context.missing(_sugarMeta);
    }
    if (data.containsKey('salt')) {
      context.handle(
        _saltMeta,
        salt.isAcceptableOrUnknown(data['salt']!, _saltMeta),
      );
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('common_serving')) {
      context.handle(
        _commonServingMeta,
        commonServing.isAcceptableOrUnknown(
          data['common_serving']!,
          _commonServingMeta,
        ),
      );
    }
    if (data.containsKey('common_serving_grams')) {
      context.handle(
        _commonServingGramsMeta,
        commonServingGrams.isAcceptableOrUnknown(
          data['common_serving_grams']!,
          _commonServingGramsMeta,
        ),
      );
    }
    if (data.containsKey('is_common')) {
      context.handle(
        _isCommonMeta,
        isCommon.isAcceptableOrUnknown(data['is_common']!, _isCommonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('basis_unit')) {
      context.handle(
        _basisUnitMeta,
        basisUnit.isAcceptableOrUnknown(data['basis_unit']!, _basisUnitMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      verificationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_status'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      energy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energy'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbohydrate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbohydrate'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      fibre: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibre'],
      )!,
      sugar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar'],
      )!,
      salt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salt'],
      )!,
      commonServing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}common_serving'],
      ),
      commonServingGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}common_serving_grams'],
      ),
      isCommon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_common'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      basisUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}basis_unit'],
      )!,
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class FoodRow extends DataClass implements Insertable<FoodRow> {
  final String id;
  final String name;
  final String? brand;
  final String source;
  final String verificationStatus;
  final String? barcode;
  final double energy;
  final double protein;
  final double carbohydrate;
  final double fat;
  final double fibre;
  final double sugar;
  final double salt;
  final String? commonServing;
  final double? commonServingGrams;
  final bool isCommon;
  final String createdAt;
  final String updatedAt;
  final String basisUnit;
  const FoodRow({
    required this.id,
    required this.name,
    this.brand,
    required this.source,
    required this.verificationStatus,
    this.barcode,
    required this.energy,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.fibre,
    required this.sugar,
    required this.salt,
    this.commonServing,
    this.commonServingGrams,
    required this.isCommon,
    required this.createdAt,
    required this.updatedAt,
    required this.basisUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['source'] = Variable<String>(source);
    map['verification_status'] = Variable<String>(verificationStatus);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['energy'] = Variable<double>(energy);
    map['protein'] = Variable<double>(protein);
    map['carbohydrate'] = Variable<double>(carbohydrate);
    map['fat'] = Variable<double>(fat);
    map['fibre'] = Variable<double>(fibre);
    map['sugar'] = Variable<double>(sugar);
    map['salt'] = Variable<double>(salt);
    if (!nullToAbsent || commonServing != null) {
      map['common_serving'] = Variable<String>(commonServing);
    }
    if (!nullToAbsent || commonServingGrams != null) {
      map['common_serving_grams'] = Variable<double>(commonServingGrams);
    }
    map['is_common'] = Variable<bool>(isCommon);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['basis_unit'] = Variable<String>(basisUnit);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      source: Value(source),
      verificationStatus: Value(verificationStatus),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      energy: Value(energy),
      protein: Value(protein),
      carbohydrate: Value(carbohydrate),
      fat: Value(fat),
      fibre: Value(fibre),
      sugar: Value(sugar),
      salt: Value(salt),
      commonServing: commonServing == null && nullToAbsent
          ? const Value.absent()
          : Value(commonServing),
      commonServingGrams: commonServingGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(commonServingGrams),
      isCommon: Value(isCommon),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      basisUnit: Value(basisUnit),
    );
  }

  factory FoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      source: serializer.fromJson<String>(json['source']),
      verificationStatus: serializer.fromJson<String>(
        json['verificationStatus'],
      ),
      barcode: serializer.fromJson<String?>(json['barcode']),
      energy: serializer.fromJson<double>(json['energy']),
      protein: serializer.fromJson<double>(json['protein']),
      carbohydrate: serializer.fromJson<double>(json['carbohydrate']),
      fat: serializer.fromJson<double>(json['fat']),
      fibre: serializer.fromJson<double>(json['fibre']),
      sugar: serializer.fromJson<double>(json['sugar']),
      salt: serializer.fromJson<double>(json['salt']),
      commonServing: serializer.fromJson<String?>(json['commonServing']),
      commonServingGrams: serializer.fromJson<double?>(
        json['commonServingGrams'],
      ),
      isCommon: serializer.fromJson<bool>(json['isCommon']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      basisUnit: serializer.fromJson<String>(json['basisUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'source': serializer.toJson<String>(source),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
      'barcode': serializer.toJson<String?>(barcode),
      'energy': serializer.toJson<double>(energy),
      'protein': serializer.toJson<double>(protein),
      'carbohydrate': serializer.toJson<double>(carbohydrate),
      'fat': serializer.toJson<double>(fat),
      'fibre': serializer.toJson<double>(fibre),
      'sugar': serializer.toJson<double>(sugar),
      'salt': serializer.toJson<double>(salt),
      'commonServing': serializer.toJson<String?>(commonServing),
      'commonServingGrams': serializer.toJson<double?>(commonServingGrams),
      'isCommon': serializer.toJson<bool>(isCommon),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'basisUnit': serializer.toJson<String>(basisUnit),
    };
  }

  FoodRow copyWith({
    String? id,
    String? name,
    Value<String?> brand = const Value.absent(),
    String? source,
    String? verificationStatus,
    Value<String?> barcode = const Value.absent(),
    double? energy,
    double? protein,
    double? carbohydrate,
    double? fat,
    double? fibre,
    double? sugar,
    double? salt,
    Value<String?> commonServing = const Value.absent(),
    Value<double?> commonServingGrams = const Value.absent(),
    bool? isCommon,
    String? createdAt,
    String? updatedAt,
    String? basisUnit,
  }) => FoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    source: source ?? this.source,
    verificationStatus: verificationStatus ?? this.verificationStatus,
    barcode: barcode.present ? barcode.value : this.barcode,
    energy: energy ?? this.energy,
    protein: protein ?? this.protein,
    carbohydrate: carbohydrate ?? this.carbohydrate,
    fat: fat ?? this.fat,
    fibre: fibre ?? this.fibre,
    sugar: sugar ?? this.sugar,
    salt: salt ?? this.salt,
    commonServing: commonServing.present
        ? commonServing.value
        : this.commonServing,
    commonServingGrams: commonServingGrams.present
        ? commonServingGrams.value
        : this.commonServingGrams,
    isCommon: isCommon ?? this.isCommon,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    basisUnit: basisUnit ?? this.basisUnit,
  );
  FoodRow copyWithCompanion(FoodsCompanion data) {
    return FoodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      source: data.source.present ? data.source.value : this.source,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      energy: data.energy.present ? data.energy.value : this.energy,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbohydrate: data.carbohydrate.present
          ? data.carbohydrate.value
          : this.carbohydrate,
      fat: data.fat.present ? data.fat.value : this.fat,
      fibre: data.fibre.present ? data.fibre.value : this.fibre,
      sugar: data.sugar.present ? data.sugar.value : this.sugar,
      salt: data.salt.present ? data.salt.value : this.salt,
      commonServing: data.commonServing.present
          ? data.commonServing.value
          : this.commonServing,
      commonServingGrams: data.commonServingGrams.present
          ? data.commonServingGrams.value
          : this.commonServingGrams,
      isCommon: data.isCommon.present ? data.isCommon.value : this.isCommon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      basisUnit: data.basisUnit.present ? data.basisUnit.value : this.basisUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('source: $source, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('barcode: $barcode, ')
          ..write('energy: $energy, ')
          ..write('protein: $protein, ')
          ..write('carbohydrate: $carbohydrate, ')
          ..write('fat: $fat, ')
          ..write('fibre: $fibre, ')
          ..write('sugar: $sugar, ')
          ..write('salt: $salt, ')
          ..write('commonServing: $commonServing, ')
          ..write('commonServingGrams: $commonServingGrams, ')
          ..write('isCommon: $isCommon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('basisUnit: $basisUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    source,
    verificationStatus,
    barcode,
    energy,
    protein,
    carbohydrate,
    fat,
    fibre,
    sugar,
    salt,
    commonServing,
    commonServingGrams,
    isCommon,
    createdAt,
    updatedAt,
    basisUnit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.source == this.source &&
          other.verificationStatus == this.verificationStatus &&
          other.barcode == this.barcode &&
          other.energy == this.energy &&
          other.protein == this.protein &&
          other.carbohydrate == this.carbohydrate &&
          other.fat == this.fat &&
          other.fibre == this.fibre &&
          other.sugar == this.sugar &&
          other.salt == this.salt &&
          other.commonServing == this.commonServing &&
          other.commonServingGrams == this.commonServingGrams &&
          other.isCommon == this.isCommon &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.basisUnit == this.basisUnit);
}

class FoodsCompanion extends UpdateCompanion<FoodRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String> source;
  final Value<String> verificationStatus;
  final Value<String?> barcode;
  final Value<double> energy;
  final Value<double> protein;
  final Value<double> carbohydrate;
  final Value<double> fat;
  final Value<double> fibre;
  final Value<double> sugar;
  final Value<double> salt;
  final Value<String?> commonServing;
  final Value<double?> commonServingGrams;
  final Value<bool> isCommon;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> basisUnit;
  final Value<int> rowid;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.source = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.barcode = const Value.absent(),
    this.energy = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbohydrate = const Value.absent(),
    this.fat = const Value.absent(),
    this.fibre = const Value.absent(),
    this.sugar = const Value.absent(),
    this.salt = const Value.absent(),
    this.commonServing = const Value.absent(),
    this.commonServingGrams = const Value.absent(),
    this.isCommon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.basisUnit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodsCompanion.insert({
    required String id,
    required String name,
    this.brand = const Value.absent(),
    required String source,
    required String verificationStatus,
    this.barcode = const Value.absent(),
    required double energy,
    required double protein,
    required double carbohydrate,
    required double fat,
    required double fibre,
    required double sugar,
    required double salt,
    this.commonServing = const Value.absent(),
    this.commonServingGrams = const Value.absent(),
    this.isCommon = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.basisUnit = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       source = Value(source),
       verificationStatus = Value(verificationStatus),
       energy = Value(energy),
       protein = Value(protein),
       carbohydrate = Value(carbohydrate),
       fat = Value(fat),
       fibre = Value(fibre),
       sugar = Value(sugar),
       salt = Value(salt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FoodRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? source,
    Expression<String>? verificationStatus,
    Expression<String>? barcode,
    Expression<double>? energy,
    Expression<double>? protein,
    Expression<double>? carbohydrate,
    Expression<double>? fat,
    Expression<double>? fibre,
    Expression<double>? sugar,
    Expression<double>? salt,
    Expression<String>? commonServing,
    Expression<double>? commonServingGrams,
    Expression<bool>? isCommon,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? basisUnit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (source != null) 'source': source,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (barcode != null) 'barcode': barcode,
      if (energy != null) 'energy': energy,
      if (protein != null) 'protein': protein,
      if (carbohydrate != null) 'carbohydrate': carbohydrate,
      if (fat != null) 'fat': fat,
      if (fibre != null) 'fibre': fibre,
      if (sugar != null) 'sugar': sugar,
      if (salt != null) 'salt': salt,
      if (commonServing != null) 'common_serving': commonServing,
      if (commonServingGrams != null)
        'common_serving_grams': commonServingGrams,
      if (isCommon != null) 'is_common': isCommon,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (basisUnit != null) 'basis_unit': basisUnit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? brand,
    Value<String>? source,
    Value<String>? verificationStatus,
    Value<String?>? barcode,
    Value<double>? energy,
    Value<double>? protein,
    Value<double>? carbohydrate,
    Value<double>? fat,
    Value<double>? fibre,
    Value<double>? sugar,
    Value<double>? salt,
    Value<String?>? commonServing,
    Value<double?>? commonServingGrams,
    Value<bool>? isCommon,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String>? basisUnit,
    Value<int>? rowid,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      source: source ?? this.source,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      barcode: barcode ?? this.barcode,
      energy: energy ?? this.energy,
      protein: protein ?? this.protein,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      fat: fat ?? this.fat,
      fibre: fibre ?? this.fibre,
      sugar: sugar ?? this.sugar,
      salt: salt ?? this.salt,
      commonServing: commonServing ?? this.commonServing,
      commonServingGrams: commonServingGrams ?? this.commonServingGrams,
      isCommon: isCommon ?? this.isCommon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      basisUnit: basisUnit ?? this.basisUnit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (energy.present) {
      map['energy'] = Variable<double>(energy.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbohydrate.present) {
      map['carbohydrate'] = Variable<double>(carbohydrate.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (fibre.present) {
      map['fibre'] = Variable<double>(fibre.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<double>(sugar.value);
    }
    if (salt.present) {
      map['salt'] = Variable<double>(salt.value);
    }
    if (commonServing.present) {
      map['common_serving'] = Variable<String>(commonServing.value);
    }
    if (commonServingGrams.present) {
      map['common_serving_grams'] = Variable<double>(commonServingGrams.value);
    }
    if (isCommon.present) {
      map['is_common'] = Variable<bool>(isCommon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (basisUnit.present) {
      map['basis_unit'] = Variable<String>(basisUnit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('source: $source, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('barcode: $barcode, ')
          ..write('energy: $energy, ')
          ..write('protein: $protein, ')
          ..write('carbohydrate: $carbohydrate, ')
          ..write('fat: $fat, ')
          ..write('fibre: $fibre, ')
          ..write('sugar: $sugar, ')
          ..write('salt: $salt, ')
          ..write('commonServing: $commonServing, ')
          ..write('commonServingGrams: $commonServingGrams, ')
          ..write('isCommon: $isCommon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('basisUnit: $basisUnit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodServingsTable extends FoodServings
    with TableInfo<$FoodServingsTable, FoodServingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodServingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalQuantityMeta = const VerificationMeta(
    'canonicalQuantity',
  );
  @override
  late final GeneratedColumn<double> canonicalQuantity =
      GeneratedColumn<double>(
        'canonical_quantity',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foodId,
    label,
    quantity,
    unit,
    canonicalQuantity,
    isDefault,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_servings';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodServingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('canonical_quantity')) {
      context.handle(
        _canonicalQuantityMeta,
        canonicalQuantity.isAcceptableOrUnknown(
          data['canonical_quantity']!,
          _canonicalQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalQuantityMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodServingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodServingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      canonicalQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}canonical_quantity'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $FoodServingsTable createAlias(String alias) {
    return $FoodServingsTable(attachedDatabase, alias);
  }
}

class FoodServingRow extends DataClass implements Insertable<FoodServingRow> {
  final String id;
  final String foodId;
  final String label;
  final double quantity;
  final String unit;
  final double canonicalQuantity;
  final bool isDefault;
  final int displayOrder;
  const FoodServingRow({
    required this.id,
    required this.foodId,
    required this.label,
    required this.quantity,
    required this.unit,
    required this.canonicalQuantity,
    required this.isDefault,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['food_id'] = Variable<String>(foodId);
    map['label'] = Variable<String>(label);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['canonical_quantity'] = Variable<double>(canonicalQuantity);
    map['is_default'] = Variable<bool>(isDefault);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  FoodServingsCompanion toCompanion(bool nullToAbsent) {
    return FoodServingsCompanion(
      id: Value(id),
      foodId: Value(foodId),
      label: Value(label),
      quantity: Value(quantity),
      unit: Value(unit),
      canonicalQuantity: Value(canonicalQuantity),
      isDefault: Value(isDefault),
      displayOrder: Value(displayOrder),
    );
  }

  factory FoodServingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodServingRow(
      id: serializer.fromJson<String>(json['id']),
      foodId: serializer.fromJson<String>(json['foodId']),
      label: serializer.fromJson<String>(json['label']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      canonicalQuantity: serializer.fromJson<double>(json['canonicalQuantity']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'foodId': serializer.toJson<String>(foodId),
      'label': serializer.toJson<String>(label),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'canonicalQuantity': serializer.toJson<double>(canonicalQuantity),
      'isDefault': serializer.toJson<bool>(isDefault),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  FoodServingRow copyWith({
    String? id,
    String? foodId,
    String? label,
    double? quantity,
    String? unit,
    double? canonicalQuantity,
    bool? isDefault,
    int? displayOrder,
  }) => FoodServingRow(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    label: label ?? this.label,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    canonicalQuantity: canonicalQuantity ?? this.canonicalQuantity,
    isDefault: isDefault ?? this.isDefault,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  FoodServingRow copyWithCompanion(FoodServingsCompanion data) {
    return FoodServingRow(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      label: data.label.present ? data.label.value : this.label,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      canonicalQuantity: data.canonicalQuantity.present
          ? data.canonicalQuantity.value
          : this.canonicalQuantity,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodServingRow(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('label: $label, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('canonicalQuantity: $canonicalQuantity, ')
          ..write('isDefault: $isDefault, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    foodId,
    label,
    quantity,
    unit,
    canonicalQuantity,
    isDefault,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodServingRow &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.label == this.label &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.canonicalQuantity == this.canonicalQuantity &&
          other.isDefault == this.isDefault &&
          other.displayOrder == this.displayOrder);
}

class FoodServingsCompanion extends UpdateCompanion<FoodServingRow> {
  final Value<String> id;
  final Value<String> foodId;
  final Value<String> label;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double> canonicalQuantity;
  final Value<bool> isDefault;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const FoodServingsCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.label = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.canonicalQuantity = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodServingsCompanion.insert({
    required String id,
    required String foodId,
    required String label,
    required double quantity,
    required String unit,
    required double canonicalQuantity,
    this.isDefault = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       foodId = Value(foodId),
       label = Value(label),
       quantity = Value(quantity),
       unit = Value(unit),
       canonicalQuantity = Value(canonicalQuantity);
  static Insertable<FoodServingRow> custom({
    Expression<String>? id,
    Expression<String>? foodId,
    Expression<String>? label,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? canonicalQuantity,
    Expression<bool>? isDefault,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (label != null) 'label': label,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (canonicalQuantity != null) 'canonical_quantity': canonicalQuantity,
      if (isDefault != null) 'is_default': isDefault,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodServingsCompanion copyWith({
    Value<String>? id,
    Value<String>? foodId,
    Value<String>? label,
    Value<double>? quantity,
    Value<String>? unit,
    Value<double>? canonicalQuantity,
    Value<bool>? isDefault,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return FoodServingsCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      label: label ?? this.label,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      canonicalQuantity: canonicalQuantity ?? this.canonicalQuantity,
      isDefault: isDefault ?? this.isDefault,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (canonicalQuantity.present) {
      map['canonical_quantity'] = Variable<double>(canonicalQuantity.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodServingsCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('label: $label, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('canonicalQuantity: $canonicalQuantity, ')
          ..write('isDefault: $isDefault, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anonymousUserIdMeta = const VerificationMeta(
    'anonymousUserId',
  );
  @override
  late final GeneratedColumn<String> anonymousUserId = GeneratedColumn<String>(
    'anonymous_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _foodNameSnapshotMeta = const VerificationMeta(
    'foodNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> foodNameSnapshot = GeneratedColumn<String>(
    'food_name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandSnapshotMeta = const VerificationMeta(
    'brandSnapshot',
  );
  @override
  late final GeneratedColumn<String> brandSnapshot = GeneratedColumn<String>(
    'brand_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityGramsMeta = const VerificationMeta(
    'quantityGrams',
  );
  @override
  late final GeneratedColumn<double> quantityGrams = GeneratedColumn<double>(
    'quantity_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingDescriptionMeta =
      const VerificationMeta('servingDescription');
  @override
  late final GeneratedColumn<String> servingDescription =
      GeneratedColumn<String>(
        'serving_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _energySnapshotMeta = const VerificationMeta(
    'energySnapshot',
  );
  @override
  late final GeneratedColumn<double> energySnapshot = GeneratedColumn<double>(
    'energy_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinSnapshotMeta = const VerificationMeta(
    'proteinSnapshot',
  );
  @override
  late final GeneratedColumn<double> proteinSnapshot = GeneratedColumn<double>(
    'protein_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbohydrateSnapshotMeta =
      const VerificationMeta('carbohydrateSnapshot');
  @override
  late final GeneratedColumn<double> carbohydrateSnapshot =
      GeneratedColumn<double>(
        'carbohydrate_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fatSnapshotMeta = const VerificationMeta(
    'fatSnapshot',
  );
  @override
  late final GeneratedColumn<double> fatSnapshot = GeneratedColumn<double>(
    'fat_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fibreSnapshotMeta = const VerificationMeta(
    'fibreSnapshot',
  );
  @override
  late final GeneratedColumn<double> fibreSnapshot = GeneratedColumn<double>(
    'fibre_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugarSnapshotMeta = const VerificationMeta(
    'sugarSnapshot',
  );
  @override
  late final GeneratedColumn<double> sugarSnapshot = GeneratedColumn<double>(
    'sugar_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saltSnapshotMeta = const VerificationMeta(
    'saltSnapshot',
  );
  @override
  late final GeneratedColumn<double> saltSnapshot = GeneratedColumn<double>(
    'salt_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    anonymousUserId,
    foodId,
    foodNameSnapshot,
    brandSnapshot,
    mealType,
    quantityGrams,
    servingDescription,
    energySnapshot,
    proteinSnapshot,
    carbohydrateSnapshot,
    fatSnapshot,
    fibreSnapshot,
    sugarSnapshot,
    saltSnapshot,
    loggedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('anonymous_user_id')) {
      context.handle(
        _anonymousUserIdMeta,
        anonymousUserId.isAcceptableOrUnknown(
          data['anonymous_user_id']!,
          _anonymousUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_anonymousUserIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('food_name_snapshot')) {
      context.handle(
        _foodNameSnapshotMeta,
        foodNameSnapshot.isAcceptableOrUnknown(
          data['food_name_snapshot']!,
          _foodNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodNameSnapshotMeta);
    }
    if (data.containsKey('brand_snapshot')) {
      context.handle(
        _brandSnapshotMeta,
        brandSnapshot.isAcceptableOrUnknown(
          data['brand_snapshot']!,
          _brandSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('quantity_grams')) {
      context.handle(
        _quantityGramsMeta,
        quantityGrams.isAcceptableOrUnknown(
          data['quantity_grams']!,
          _quantityGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityGramsMeta);
    }
    if (data.containsKey('serving_description')) {
      context.handle(
        _servingDescriptionMeta,
        servingDescription.isAcceptableOrUnknown(
          data['serving_description']!,
          _servingDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_servingDescriptionMeta);
    }
    if (data.containsKey('energy_snapshot')) {
      context.handle(
        _energySnapshotMeta,
        energySnapshot.isAcceptableOrUnknown(
          data['energy_snapshot']!,
          _energySnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_energySnapshotMeta);
    }
    if (data.containsKey('protein_snapshot')) {
      context.handle(
        _proteinSnapshotMeta,
        proteinSnapshot.isAcceptableOrUnknown(
          data['protein_snapshot']!,
          _proteinSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinSnapshotMeta);
    }
    if (data.containsKey('carbohydrate_snapshot')) {
      context.handle(
        _carbohydrateSnapshotMeta,
        carbohydrateSnapshot.isAcceptableOrUnknown(
          data['carbohydrate_snapshot']!,
          _carbohydrateSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbohydrateSnapshotMeta);
    }
    if (data.containsKey('fat_snapshot')) {
      context.handle(
        _fatSnapshotMeta,
        fatSnapshot.isAcceptableOrUnknown(
          data['fat_snapshot']!,
          _fatSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatSnapshotMeta);
    }
    if (data.containsKey('fibre_snapshot')) {
      context.handle(
        _fibreSnapshotMeta,
        fibreSnapshot.isAcceptableOrUnknown(
          data['fibre_snapshot']!,
          _fibreSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fibreSnapshotMeta);
    }
    if (data.containsKey('sugar_snapshot')) {
      context.handle(
        _sugarSnapshotMeta,
        sugarSnapshot.isAcceptableOrUnknown(
          data['sugar_snapshot']!,
          _sugarSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sugarSnapshotMeta);
    }
    if (data.containsKey('salt_snapshot')) {
      context.handle(
        _saltSnapshotMeta,
        saltSnapshot.isAcceptableOrUnknown(
          data['salt_snapshot']!,
          _saltSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saltSnapshotMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      anonymousUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anonymous_user_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      foodNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name_snapshot'],
      )!,
      brandSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_snapshot'],
      ),
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      quantityGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_grams'],
      )!,
      servingDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_description'],
      )!,
      energySnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energy_snapshot'],
      )!,
      proteinSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_snapshot'],
      )!,
      carbohydrateSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbohydrate_snapshot'],
      )!,
      fatSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_snapshot'],
      )!,
      fibreSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibre_snapshot'],
      )!,
      sugarSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar_snapshot'],
      )!,
      saltSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salt_snapshot'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }
}

class DiaryEntryRow extends DataClass implements Insertable<DiaryEntryRow> {
  final String id;
  final String anonymousUserId;
  final String? foodId;
  final String foodNameSnapshot;
  final String? brandSnapshot;
  final String mealType;
  final double quantityGrams;
  final String servingDescription;
  final double energySnapshot;
  final double proteinSnapshot;
  final double carbohydrateSnapshot;
  final double fatSnapshot;
  final double fibreSnapshot;
  final double sugarSnapshot;
  final double saltSnapshot;
  final String loggedAt;
  final String createdAt;
  final String updatedAt;
  const DiaryEntryRow({
    required this.id,
    required this.anonymousUserId,
    this.foodId,
    required this.foodNameSnapshot,
    this.brandSnapshot,
    required this.mealType,
    required this.quantityGrams,
    required this.servingDescription,
    required this.energySnapshot,
    required this.proteinSnapshot,
    required this.carbohydrateSnapshot,
    required this.fatSnapshot,
    required this.fibreSnapshot,
    required this.sugarSnapshot,
    required this.saltSnapshot,
    required this.loggedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['anonymous_user_id'] = Variable<String>(anonymousUserId);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<String>(foodId);
    }
    map['food_name_snapshot'] = Variable<String>(foodNameSnapshot);
    if (!nullToAbsent || brandSnapshot != null) {
      map['brand_snapshot'] = Variable<String>(brandSnapshot);
    }
    map['meal_type'] = Variable<String>(mealType);
    map['quantity_grams'] = Variable<double>(quantityGrams);
    map['serving_description'] = Variable<String>(servingDescription);
    map['energy_snapshot'] = Variable<double>(energySnapshot);
    map['protein_snapshot'] = Variable<double>(proteinSnapshot);
    map['carbohydrate_snapshot'] = Variable<double>(carbohydrateSnapshot);
    map['fat_snapshot'] = Variable<double>(fatSnapshot);
    map['fibre_snapshot'] = Variable<double>(fibreSnapshot);
    map['sugar_snapshot'] = Variable<double>(sugarSnapshot);
    map['salt_snapshot'] = Variable<double>(saltSnapshot);
    map['logged_at'] = Variable<String>(loggedAt);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      anonymousUserId: Value(anonymousUserId),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      foodNameSnapshot: Value(foodNameSnapshot),
      brandSnapshot: brandSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(brandSnapshot),
      mealType: Value(mealType),
      quantityGrams: Value(quantityGrams),
      servingDescription: Value(servingDescription),
      energySnapshot: Value(energySnapshot),
      proteinSnapshot: Value(proteinSnapshot),
      carbohydrateSnapshot: Value(carbohydrateSnapshot),
      fatSnapshot: Value(fatSnapshot),
      fibreSnapshot: Value(fibreSnapshot),
      sugarSnapshot: Value(sugarSnapshot),
      saltSnapshot: Value(saltSnapshot),
      loggedAt: Value(loggedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DiaryEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntryRow(
      id: serializer.fromJson<String>(json['id']),
      anonymousUserId: serializer.fromJson<String>(json['anonymousUserId']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      foodNameSnapshot: serializer.fromJson<String>(json['foodNameSnapshot']),
      brandSnapshot: serializer.fromJson<String?>(json['brandSnapshot']),
      mealType: serializer.fromJson<String>(json['mealType']),
      quantityGrams: serializer.fromJson<double>(json['quantityGrams']),
      servingDescription: serializer.fromJson<String>(
        json['servingDescription'],
      ),
      energySnapshot: serializer.fromJson<double>(json['energySnapshot']),
      proteinSnapshot: serializer.fromJson<double>(json['proteinSnapshot']),
      carbohydrateSnapshot: serializer.fromJson<double>(
        json['carbohydrateSnapshot'],
      ),
      fatSnapshot: serializer.fromJson<double>(json['fatSnapshot']),
      fibreSnapshot: serializer.fromJson<double>(json['fibreSnapshot']),
      sugarSnapshot: serializer.fromJson<double>(json['sugarSnapshot']),
      saltSnapshot: serializer.fromJson<double>(json['saltSnapshot']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'anonymousUserId': serializer.toJson<String>(anonymousUserId),
      'foodId': serializer.toJson<String?>(foodId),
      'foodNameSnapshot': serializer.toJson<String>(foodNameSnapshot),
      'brandSnapshot': serializer.toJson<String?>(brandSnapshot),
      'mealType': serializer.toJson<String>(mealType),
      'quantityGrams': serializer.toJson<double>(quantityGrams),
      'servingDescription': serializer.toJson<String>(servingDescription),
      'energySnapshot': serializer.toJson<double>(energySnapshot),
      'proteinSnapshot': serializer.toJson<double>(proteinSnapshot),
      'carbohydrateSnapshot': serializer.toJson<double>(carbohydrateSnapshot),
      'fatSnapshot': serializer.toJson<double>(fatSnapshot),
      'fibreSnapshot': serializer.toJson<double>(fibreSnapshot),
      'sugarSnapshot': serializer.toJson<double>(sugarSnapshot),
      'saltSnapshot': serializer.toJson<double>(saltSnapshot),
      'loggedAt': serializer.toJson<String>(loggedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  DiaryEntryRow copyWith({
    String? id,
    String? anonymousUserId,
    Value<String?> foodId = const Value.absent(),
    String? foodNameSnapshot,
    Value<String?> brandSnapshot = const Value.absent(),
    String? mealType,
    double? quantityGrams,
    String? servingDescription,
    double? energySnapshot,
    double? proteinSnapshot,
    double? carbohydrateSnapshot,
    double? fatSnapshot,
    double? fibreSnapshot,
    double? sugarSnapshot,
    double? saltSnapshot,
    String? loggedAt,
    String? createdAt,
    String? updatedAt,
  }) => DiaryEntryRow(
    id: id ?? this.id,
    anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    foodId: foodId.present ? foodId.value : this.foodId,
    foodNameSnapshot: foodNameSnapshot ?? this.foodNameSnapshot,
    brandSnapshot: brandSnapshot.present
        ? brandSnapshot.value
        : this.brandSnapshot,
    mealType: mealType ?? this.mealType,
    quantityGrams: quantityGrams ?? this.quantityGrams,
    servingDescription: servingDescription ?? this.servingDescription,
    energySnapshot: energySnapshot ?? this.energySnapshot,
    proteinSnapshot: proteinSnapshot ?? this.proteinSnapshot,
    carbohydrateSnapshot: carbohydrateSnapshot ?? this.carbohydrateSnapshot,
    fatSnapshot: fatSnapshot ?? this.fatSnapshot,
    fibreSnapshot: fibreSnapshot ?? this.fibreSnapshot,
    sugarSnapshot: sugarSnapshot ?? this.sugarSnapshot,
    saltSnapshot: saltSnapshot ?? this.saltSnapshot,
    loggedAt: loggedAt ?? this.loggedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DiaryEntryRow copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntryRow(
      id: data.id.present ? data.id.value : this.id,
      anonymousUserId: data.anonymousUserId.present
          ? data.anonymousUserId.value
          : this.anonymousUserId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      foodNameSnapshot: data.foodNameSnapshot.present
          ? data.foodNameSnapshot.value
          : this.foodNameSnapshot,
      brandSnapshot: data.brandSnapshot.present
          ? data.brandSnapshot.value
          : this.brandSnapshot,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      quantityGrams: data.quantityGrams.present
          ? data.quantityGrams.value
          : this.quantityGrams,
      servingDescription: data.servingDescription.present
          ? data.servingDescription.value
          : this.servingDescription,
      energySnapshot: data.energySnapshot.present
          ? data.energySnapshot.value
          : this.energySnapshot,
      proteinSnapshot: data.proteinSnapshot.present
          ? data.proteinSnapshot.value
          : this.proteinSnapshot,
      carbohydrateSnapshot: data.carbohydrateSnapshot.present
          ? data.carbohydrateSnapshot.value
          : this.carbohydrateSnapshot,
      fatSnapshot: data.fatSnapshot.present
          ? data.fatSnapshot.value
          : this.fatSnapshot,
      fibreSnapshot: data.fibreSnapshot.present
          ? data.fibreSnapshot.value
          : this.fibreSnapshot,
      sugarSnapshot: data.sugarSnapshot.present
          ? data.sugarSnapshot.value
          : this.sugarSnapshot,
      saltSnapshot: data.saltSnapshot.present
          ? data.saltSnapshot.value
          : this.saltSnapshot,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntryRow(')
          ..write('id: $id, ')
          ..write('anonymousUserId: $anonymousUserId, ')
          ..write('foodId: $foodId, ')
          ..write('foodNameSnapshot: $foodNameSnapshot, ')
          ..write('brandSnapshot: $brandSnapshot, ')
          ..write('mealType: $mealType, ')
          ..write('quantityGrams: $quantityGrams, ')
          ..write('servingDescription: $servingDescription, ')
          ..write('energySnapshot: $energySnapshot, ')
          ..write('proteinSnapshot: $proteinSnapshot, ')
          ..write('carbohydrateSnapshot: $carbohydrateSnapshot, ')
          ..write('fatSnapshot: $fatSnapshot, ')
          ..write('fibreSnapshot: $fibreSnapshot, ')
          ..write('sugarSnapshot: $sugarSnapshot, ')
          ..write('saltSnapshot: $saltSnapshot, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    anonymousUserId,
    foodId,
    foodNameSnapshot,
    brandSnapshot,
    mealType,
    quantityGrams,
    servingDescription,
    energySnapshot,
    proteinSnapshot,
    carbohydrateSnapshot,
    fatSnapshot,
    fibreSnapshot,
    sugarSnapshot,
    saltSnapshot,
    loggedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntryRow &&
          other.id == this.id &&
          other.anonymousUserId == this.anonymousUserId &&
          other.foodId == this.foodId &&
          other.foodNameSnapshot == this.foodNameSnapshot &&
          other.brandSnapshot == this.brandSnapshot &&
          other.mealType == this.mealType &&
          other.quantityGrams == this.quantityGrams &&
          other.servingDescription == this.servingDescription &&
          other.energySnapshot == this.energySnapshot &&
          other.proteinSnapshot == this.proteinSnapshot &&
          other.carbohydrateSnapshot == this.carbohydrateSnapshot &&
          other.fatSnapshot == this.fatSnapshot &&
          other.fibreSnapshot == this.fibreSnapshot &&
          other.sugarSnapshot == this.sugarSnapshot &&
          other.saltSnapshot == this.saltSnapshot &&
          other.loggedAt == this.loggedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntryRow> {
  final Value<String> id;
  final Value<String> anonymousUserId;
  final Value<String?> foodId;
  final Value<String> foodNameSnapshot;
  final Value<String?> brandSnapshot;
  final Value<String> mealType;
  final Value<double> quantityGrams;
  final Value<String> servingDescription;
  final Value<double> energySnapshot;
  final Value<double> proteinSnapshot;
  final Value<double> carbohydrateSnapshot;
  final Value<double> fatSnapshot;
  final Value<double> fibreSnapshot;
  final Value<double> sugarSnapshot;
  final Value<double> saltSnapshot;
  final Value<String> loggedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.anonymousUserId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.foodNameSnapshot = const Value.absent(),
    this.brandSnapshot = const Value.absent(),
    this.mealType = const Value.absent(),
    this.quantityGrams = const Value.absent(),
    this.servingDescription = const Value.absent(),
    this.energySnapshot = const Value.absent(),
    this.proteinSnapshot = const Value.absent(),
    this.carbohydrateSnapshot = const Value.absent(),
    this.fatSnapshot = const Value.absent(),
    this.fibreSnapshot = const Value.absent(),
    this.sugarSnapshot = const Value.absent(),
    this.saltSnapshot = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    required String id,
    required String anonymousUserId,
    this.foodId = const Value.absent(),
    required String foodNameSnapshot,
    this.brandSnapshot = const Value.absent(),
    required String mealType,
    required double quantityGrams,
    required String servingDescription,
    required double energySnapshot,
    required double proteinSnapshot,
    required double carbohydrateSnapshot,
    required double fatSnapshot,
    required double fibreSnapshot,
    required double sugarSnapshot,
    required double saltSnapshot,
    required String loggedAt,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       anonymousUserId = Value(anonymousUserId),
       foodNameSnapshot = Value(foodNameSnapshot),
       mealType = Value(mealType),
       quantityGrams = Value(quantityGrams),
       servingDescription = Value(servingDescription),
       energySnapshot = Value(energySnapshot),
       proteinSnapshot = Value(proteinSnapshot),
       carbohydrateSnapshot = Value(carbohydrateSnapshot),
       fatSnapshot = Value(fatSnapshot),
       fibreSnapshot = Value(fibreSnapshot),
       sugarSnapshot = Value(sugarSnapshot),
       saltSnapshot = Value(saltSnapshot),
       loggedAt = Value(loggedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DiaryEntryRow> custom({
    Expression<String>? id,
    Expression<String>? anonymousUserId,
    Expression<String>? foodId,
    Expression<String>? foodNameSnapshot,
    Expression<String>? brandSnapshot,
    Expression<String>? mealType,
    Expression<double>? quantityGrams,
    Expression<String>? servingDescription,
    Expression<double>? energySnapshot,
    Expression<double>? proteinSnapshot,
    Expression<double>? carbohydrateSnapshot,
    Expression<double>? fatSnapshot,
    Expression<double>? fibreSnapshot,
    Expression<double>? sugarSnapshot,
    Expression<double>? saltSnapshot,
    Expression<String>? loggedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anonymousUserId != null) 'anonymous_user_id': anonymousUserId,
      if (foodId != null) 'food_id': foodId,
      if (foodNameSnapshot != null) 'food_name_snapshot': foodNameSnapshot,
      if (brandSnapshot != null) 'brand_snapshot': brandSnapshot,
      if (mealType != null) 'meal_type': mealType,
      if (quantityGrams != null) 'quantity_grams': quantityGrams,
      if (servingDescription != null) 'serving_description': servingDescription,
      if (energySnapshot != null) 'energy_snapshot': energySnapshot,
      if (proteinSnapshot != null) 'protein_snapshot': proteinSnapshot,
      if (carbohydrateSnapshot != null)
        'carbohydrate_snapshot': carbohydrateSnapshot,
      if (fatSnapshot != null) 'fat_snapshot': fatSnapshot,
      if (fibreSnapshot != null) 'fibre_snapshot': fibreSnapshot,
      if (sugarSnapshot != null) 'sugar_snapshot': sugarSnapshot,
      if (saltSnapshot != null) 'salt_snapshot': saltSnapshot,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? anonymousUserId,
    Value<String?>? foodId,
    Value<String>? foodNameSnapshot,
    Value<String?>? brandSnapshot,
    Value<String>? mealType,
    Value<double>? quantityGrams,
    Value<String>? servingDescription,
    Value<double>? energySnapshot,
    Value<double>? proteinSnapshot,
    Value<double>? carbohydrateSnapshot,
    Value<double>? fatSnapshot,
    Value<double>? fibreSnapshot,
    Value<double>? sugarSnapshot,
    Value<double>? saltSnapshot,
    Value<String>? loggedAt,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      foodId: foodId ?? this.foodId,
      foodNameSnapshot: foodNameSnapshot ?? this.foodNameSnapshot,
      brandSnapshot: brandSnapshot ?? this.brandSnapshot,
      mealType: mealType ?? this.mealType,
      quantityGrams: quantityGrams ?? this.quantityGrams,
      servingDescription: servingDescription ?? this.servingDescription,
      energySnapshot: energySnapshot ?? this.energySnapshot,
      proteinSnapshot: proteinSnapshot ?? this.proteinSnapshot,
      carbohydrateSnapshot: carbohydrateSnapshot ?? this.carbohydrateSnapshot,
      fatSnapshot: fatSnapshot ?? this.fatSnapshot,
      fibreSnapshot: fibreSnapshot ?? this.fibreSnapshot,
      sugarSnapshot: sugarSnapshot ?? this.sugarSnapshot,
      saltSnapshot: saltSnapshot ?? this.saltSnapshot,
      loggedAt: loggedAt ?? this.loggedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (anonymousUserId.present) {
      map['anonymous_user_id'] = Variable<String>(anonymousUserId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (foodNameSnapshot.present) {
      map['food_name_snapshot'] = Variable<String>(foodNameSnapshot.value);
    }
    if (brandSnapshot.present) {
      map['brand_snapshot'] = Variable<String>(brandSnapshot.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (quantityGrams.present) {
      map['quantity_grams'] = Variable<double>(quantityGrams.value);
    }
    if (servingDescription.present) {
      map['serving_description'] = Variable<String>(servingDescription.value);
    }
    if (energySnapshot.present) {
      map['energy_snapshot'] = Variable<double>(energySnapshot.value);
    }
    if (proteinSnapshot.present) {
      map['protein_snapshot'] = Variable<double>(proteinSnapshot.value);
    }
    if (carbohydrateSnapshot.present) {
      map['carbohydrate_snapshot'] = Variable<double>(
        carbohydrateSnapshot.value,
      );
    }
    if (fatSnapshot.present) {
      map['fat_snapshot'] = Variable<double>(fatSnapshot.value);
    }
    if (fibreSnapshot.present) {
      map['fibre_snapshot'] = Variable<double>(fibreSnapshot.value);
    }
    if (sugarSnapshot.present) {
      map['sugar_snapshot'] = Variable<double>(sugarSnapshot.value);
    }
    if (saltSnapshot.present) {
      map['salt_snapshot'] = Variable<double>(saltSnapshot.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('anonymousUserId: $anonymousUserId, ')
          ..write('foodId: $foodId, ')
          ..write('foodNameSnapshot: $foodNameSnapshot, ')
          ..write('brandSnapshot: $brandSnapshot, ')
          ..write('mealType: $mealType, ')
          ..write('quantityGrams: $quantityGrams, ')
          ..write('servingDescription: $servingDescription, ')
          ..write('energySnapshot: $energySnapshot, ')
          ..write('proteinSnapshot: $proteinSnapshot, ')
          ..write('carbohydrateSnapshot: $carbohydrateSnapshot, ')
          ..write('fatSnapshot: $fatSnapshot, ')
          ..write('fibreSnapshot: $fibreSnapshot, ')
          ..write('sugarSnapshot: $sugarSnapshot, ')
          ..write('saltSnapshot: $saltSnapshot, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $FoodServingsTable foodServings = $FoodServingsTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    foods,
    foodServings,
    diaryEntries,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String anonymousUserId,
      required String deviceCreatedAt,
      required bool onboardingCompleted,
      required int onboardingStep,
      Value<String?> goal,
      Value<String?> dateOfBirth,
      Value<String?> calculationSex,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<String?> activity,
      Value<double?> goalWeightKg,
      Value<double?> rateKgWeek,
      Value<double?> bmr,
      Value<double?> maintenanceCalories,
      Value<double?> goalAdjustment,
      Value<double?> calorieTarget,
      Value<double?> proteinTarget,
      Value<double?> carbohydrateTarget,
      Value<double?> fatTarget,
      Value<bool?> targetClamped,
      Value<String?> clampReason,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> anonymousUserId,
      Value<String> deviceCreatedAt,
      Value<bool> onboardingCompleted,
      Value<int> onboardingStep,
      Value<String?> goal,
      Value<String?> dateOfBirth,
      Value<String?> calculationSex,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<String?> activity,
      Value<double?> goalWeightKg,
      Value<double?> rateKgWeek,
      Value<double?> bmr,
      Value<double?> maintenanceCalories,
      Value<double?> goalAdjustment,
      Value<double?> calorieTarget,
      Value<double?> proteinTarget,
      Value<double?> carbohydrateTarget,
      Value<double?> fatTarget,
      Value<bool?> targetClamped,
      Value<String?> clampReason,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get anonymousUserId => $composableBuilder(
    column: $table.anonymousUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceCreatedAt => $composableBuilder(
    column: $table.deviceCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calculationSex => $composableBuilder(
    column: $table.calculationSex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goalWeightKg => $composableBuilder(
    column: $table.goalWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rateKgWeek => $composableBuilder(
    column: $table.rateKgWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bmr => $composableBuilder(
    column: $table.bmr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maintenanceCalories => $composableBuilder(
    column: $table.maintenanceCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goalAdjustment => $composableBuilder(
    column: $table.goalAdjustment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbohydrateTarget => $composableBuilder(
    column: $table.carbohydrateTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatTarget => $composableBuilder(
    column: $table.fatTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get targetClamped => $composableBuilder(
    column: $table.targetClamped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clampReason => $composableBuilder(
    column: $table.clampReason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get anonymousUserId => $composableBuilder(
    column: $table.anonymousUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceCreatedAt => $composableBuilder(
    column: $table.deviceCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calculationSex => $composableBuilder(
    column: $table.calculationSex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goalWeightKg => $composableBuilder(
    column: $table.goalWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rateKgWeek => $composableBuilder(
    column: $table.rateKgWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bmr => $composableBuilder(
    column: $table.bmr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maintenanceCalories => $composableBuilder(
    column: $table.maintenanceCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goalAdjustment => $composableBuilder(
    column: $table.goalAdjustment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbohydrateTarget => $composableBuilder(
    column: $table.carbohydrateTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatTarget => $composableBuilder(
    column: $table.fatTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get targetClamped => $composableBuilder(
    column: $table.targetClamped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clampReason => $composableBuilder(
    column: $table.clampReason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get anonymousUserId => $composableBuilder(
    column: $table.anonymousUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceCreatedAt => $composableBuilder(
    column: $table.deviceCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calculationSex => $composableBuilder(
    column: $table.calculationSex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<double> get goalWeightKg => $composableBuilder(
    column: $table.goalWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rateKgWeek => $composableBuilder(
    column: $table.rateKgWeek,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bmr =>
      $composableBuilder(column: $table.bmr, builder: (column) => column);

  GeneratedColumn<double> get maintenanceCalories => $composableBuilder(
    column: $table.maintenanceCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get goalAdjustment => $composableBuilder(
    column: $table.goalAdjustment,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbohydrateTarget => $composableBuilder(
    column: $table.carbohydrateTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatTarget =>
      $composableBuilder(column: $table.fatTarget, builder: (column) => column);

  GeneratedColumn<bool> get targetClamped => $composableBuilder(
    column: $table.targetClamped,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clampReason => $composableBuilder(
    column: $table.clampReason,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> anonymousUserId = const Value.absent(),
                Value<String> deviceCreatedAt = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> onboardingStep = const Value.absent(),
                Value<String?> goal = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<String?> calculationSex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> activity = const Value.absent(),
                Value<double?> goalWeightKg = const Value.absent(),
                Value<double?> rateKgWeek = const Value.absent(),
                Value<double?> bmr = const Value.absent(),
                Value<double?> maintenanceCalories = const Value.absent(),
                Value<double?> goalAdjustment = const Value.absent(),
                Value<double?> calorieTarget = const Value.absent(),
                Value<double?> proteinTarget = const Value.absent(),
                Value<double?> carbohydrateTarget = const Value.absent(),
                Value<double?> fatTarget = const Value.absent(),
                Value<bool?> targetClamped = const Value.absent(),
                Value<String?> clampReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                anonymousUserId: anonymousUserId,
                deviceCreatedAt: deviceCreatedAt,
                onboardingCompleted: onboardingCompleted,
                onboardingStep: onboardingStep,
                goal: goal,
                dateOfBirth: dateOfBirth,
                calculationSex: calculationSex,
                heightCm: heightCm,
                weightKg: weightKg,
                activity: activity,
                goalWeightKg: goalWeightKg,
                rateKgWeek: rateKgWeek,
                bmr: bmr,
                maintenanceCalories: maintenanceCalories,
                goalAdjustment: goalAdjustment,
                calorieTarget: calorieTarget,
                proteinTarget: proteinTarget,
                carbohydrateTarget: carbohydrateTarget,
                fatTarget: fatTarget,
                targetClamped: targetClamped,
                clampReason: clampReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String anonymousUserId,
                required String deviceCreatedAt,
                required bool onboardingCompleted,
                required int onboardingStep,
                Value<String?> goal = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<String?> calculationSex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> activity = const Value.absent(),
                Value<double?> goalWeightKg = const Value.absent(),
                Value<double?> rateKgWeek = const Value.absent(),
                Value<double?> bmr = const Value.absent(),
                Value<double?> maintenanceCalories = const Value.absent(),
                Value<double?> goalAdjustment = const Value.absent(),
                Value<double?> calorieTarget = const Value.absent(),
                Value<double?> proteinTarget = const Value.absent(),
                Value<double?> carbohydrateTarget = const Value.absent(),
                Value<double?> fatTarget = const Value.absent(),
                Value<bool?> targetClamped = const Value.absent(),
                Value<String?> clampReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                anonymousUserId: anonymousUserId,
                deviceCreatedAt: deviceCreatedAt,
                onboardingCompleted: onboardingCompleted,
                onboardingStep: onboardingStep,
                goal: goal,
                dateOfBirth: dateOfBirth,
                calculationSex: calculationSex,
                heightCm: heightCm,
                weightKg: weightKg,
                activity: activity,
                goalWeightKg: goalWeightKg,
                rateKgWeek: rateKgWeek,
                bmr: bmr,
                maintenanceCalories: maintenanceCalories,
                goalAdjustment: goalAdjustment,
                calorieTarget: calorieTarget,
                proteinTarget: proteinTarget,
                carbohydrateTarget: carbohydrateTarget,
                fatTarget: fatTarget,
                targetClamped: targetClamped,
                clampReason: clampReason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$FoodsTableCreateCompanionBuilder =
    FoodsCompanion Function({
      required String id,
      required String name,
      Value<String?> brand,
      required String source,
      required String verificationStatus,
      Value<String?> barcode,
      required double energy,
      required double protein,
      required double carbohydrate,
      required double fat,
      required double fibre,
      required double sugar,
      required double salt,
      Value<String?> commonServing,
      Value<double?> commonServingGrams,
      Value<bool> isCommon,
      required String createdAt,
      required String updatedAt,
      Value<String> basisUnit,
      Value<int> rowid,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> brand,
      Value<String> source,
      Value<String> verificationStatus,
      Value<String?> barcode,
      Value<double> energy,
      Value<double> protein,
      Value<double> carbohydrate,
      Value<double> fat,
      Value<double> fibre,
      Value<double> sugar,
      Value<double> salt,
      Value<String?> commonServing,
      Value<double?> commonServingGrams,
      Value<bool> isCommon,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String> basisUnit,
      Value<int> rowid,
    });

final class $$FoodsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodsTable, FoodRow> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FoodServingsTable, List<FoodServingRow>>
  _foodServingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.foodServings,
    aliasName: 'foods__id__food_servings__food_id',
  );

  $$FoodServingsTableProcessedTableManager get foodServingsRefs {
    final manager = $$FoodServingsTableTableManager(
      $_db,
      $_db.foodServings,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodServingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DiaryEntriesTable, List<DiaryEntryRow>>
  _diaryEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diaryEntries,
    aliasName: 'foods__id__diary_entries__food_id',
  );

  $$DiaryEntriesTableProcessedTableManager get diaryEntriesRefs {
    final manager = $$DiaryEntriesTableTableManager(
      $_db,
      $_db.diaryEntries,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_diaryEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbohydrate => $composableBuilder(
    column: $table.carbohydrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibre => $composableBuilder(
    column: $table.fibre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commonServing => $composableBuilder(
    column: $table.commonServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get commonServingGrams => $composableBuilder(
    column: $table.commonServingGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCommon => $composableBuilder(
    column: $table.isCommon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get basisUnit => $composableBuilder(
    column: $table.basisUnit,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> foodServingsRefs(
    Expression<bool> Function($$FoodServingsTableFilterComposer f) f,
  ) {
    final $$FoodServingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodServings,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodServingsTableFilterComposer(
            $db: $db,
            $table: $db.foodServings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> diaryEntriesRefs(
    Expression<bool> Function($$DiaryEntriesTableFilterComposer f) f,
  ) {
    final $$DiaryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbohydrate => $composableBuilder(
    column: $table.carbohydrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibre => $composableBuilder(
    column: $table.fibre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commonServing => $composableBuilder(
    column: $table.commonServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get commonServingGrams => $composableBuilder(
    column: $table.commonServingGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCommon => $composableBuilder(
    column: $table.isCommon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get basisUnit => $composableBuilder(
    column: $table.basisUnit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbohydrate => $composableBuilder(
    column: $table.carbohydrate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get fibre =>
      $composableBuilder(column: $table.fibre, builder: (column) => column);

  GeneratedColumn<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<double> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<String> get commonServing => $composableBuilder(
    column: $table.commonServing,
    builder: (column) => column,
  );

  GeneratedColumn<double> get commonServingGrams => $composableBuilder(
    column: $table.commonServingGrams,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCommon =>
      $composableBuilder(column: $table.isCommon, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get basisUnit =>
      $composableBuilder(column: $table.basisUnit, builder: (column) => column);

  Expression<T> foodServingsRefs<T extends Object>(
    Expression<T> Function($$FoodServingsTableAnnotationComposer a) f,
  ) {
    final $$FoodServingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodServings,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodServingsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodServings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> diaryEntriesRefs<T extends Object>(
    Expression<T> Function($$DiaryEntriesTableAnnotationComposer a) f,
  ) {
    final $$DiaryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          FoodRow,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (FoodRow, $$FoodsTableReferences),
          FoodRow,
          PrefetchHooks Function({bool foodServingsRefs, bool diaryEntriesRefs})
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> energy = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbohydrate = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<double> fibre = const Value.absent(),
                Value<double> sugar = const Value.absent(),
                Value<double> salt = const Value.absent(),
                Value<String?> commonServing = const Value.absent(),
                Value<double?> commonServingGrams = const Value.absent(),
                Value<bool> isCommon = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String> basisUnit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                brand: brand,
                source: source,
                verificationStatus: verificationStatus,
                barcode: barcode,
                energy: energy,
                protein: protein,
                carbohydrate: carbohydrate,
                fat: fat,
                fibre: fibre,
                sugar: sugar,
                salt: salt,
                commonServing: commonServing,
                commonServingGrams: commonServingGrams,
                isCommon: isCommon,
                createdAt: createdAt,
                updatedAt: updatedAt,
                basisUnit: basisUnit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> brand = const Value.absent(),
                required String source,
                required String verificationStatus,
                Value<String?> barcode = const Value.absent(),
                required double energy,
                required double protein,
                required double carbohydrate,
                required double fat,
                required double fibre,
                required double sugar,
                required double salt,
                Value<String?> commonServing = const Value.absent(),
                Value<double?> commonServingGrams = const Value.absent(),
                Value<bool> isCommon = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String> basisUnit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                source: source,
                verificationStatus: verificationStatus,
                barcode: barcode,
                energy: energy,
                protein: protein,
                carbohydrate: carbohydrate,
                fat: fat,
                fibre: fibre,
                sugar: sugar,
                salt: salt,
                commonServing: commonServing,
                commonServingGrams: commonServingGrams,
                isCommon: isCommon,
                createdAt: createdAt,
                updatedAt: updatedAt,
                basisUnit: basisUnit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({foodServingsRefs = false, diaryEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (foodServingsRefs) db.foodServings,
                    if (diaryEntriesRefs) db.diaryEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (foodServingsRefs)
                        await $_getPrefetchedData<
                          FoodRow,
                          $FoodsTable,
                          FoodServingRow
                        >(
                          currentTable: table,
                          referencedTable: $$FoodsTableReferences
                              ._foodServingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).foodServingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.foodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (diaryEntriesRefs)
                        await $_getPrefetchedData<
                          FoodRow,
                          $FoodsTable,
                          DiaryEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$FoodsTableReferences
                              ._diaryEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).diaryEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.foodId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      FoodRow,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (FoodRow, $$FoodsTableReferences),
      FoodRow,
      PrefetchHooks Function({bool foodServingsRefs, bool diaryEntriesRefs})
    >;
typedef $$FoodServingsTableCreateCompanionBuilder =
    FoodServingsCompanion Function({
      required String id,
      required String foodId,
      required String label,
      required double quantity,
      required String unit,
      required double canonicalQuantity,
      Value<bool> isDefault,
      Value<int> displayOrder,
      Value<int> rowid,
    });
typedef $$FoodServingsTableUpdateCompanionBuilder =
    FoodServingsCompanion Function({
      Value<String> id,
      Value<String> foodId,
      Value<String> label,
      Value<double> quantity,
      Value<String> unit,
      Value<double> canonicalQuantity,
      Value<bool> isDefault,
      Value<int> displayOrder,
      Value<int> rowid,
    });

final class $$FoodServingsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodServingsTable, FoodServingRow> {
  $$FoodServingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$AppDatabase db) =>
      db.foods.createAlias('food_servings__food_id__foods__id');

  $$FoodsTableProcessedTableManager get foodId {
    final $_column = $_itemColumn<String>('food_id')!;

    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoodServingsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodServingsTable> {
  $$FoodServingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get canonicalQuantity => $composableBuilder(
    column: $table.canonicalQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodServingsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodServingsTable> {
  $$FoodServingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get canonicalQuantity => $composableBuilder(
    column: $table.canonicalQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodServingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodServingsTable> {
  $$FoodServingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get canonicalQuantity => $composableBuilder(
    column: $table.canonicalQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodServingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodServingsTable,
          FoodServingRow,
          $$FoodServingsTableFilterComposer,
          $$FoodServingsTableOrderingComposer,
          $$FoodServingsTableAnnotationComposer,
          $$FoodServingsTableCreateCompanionBuilder,
          $$FoodServingsTableUpdateCompanionBuilder,
          (FoodServingRow, $$FoodServingsTableReferences),
          FoodServingRow,
          PrefetchHooks Function({bool foodId})
        > {
  $$FoodServingsTableTableManager(_$AppDatabase db, $FoodServingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodServingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodServingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodServingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> foodId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> canonicalQuantity = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodServingsCompanion(
                id: id,
                foodId: foodId,
                label: label,
                quantity: quantity,
                unit: unit,
                canonicalQuantity: canonicalQuantity,
                isDefault: isDefault,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String foodId,
                required String label,
                required double quantity,
                required String unit,
                required double canonicalQuantity,
                Value<bool> isDefault = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodServingsCompanion.insert(
                id: id,
                foodId: foodId,
                label: label,
                quantity: quantity,
                unit: unit,
                canonicalQuantity: canonicalQuantity,
                isDefault: isDefault,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoodServingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({foodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (foodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.foodId,
                                referencedTable: $$FoodServingsTableReferences
                                    ._foodIdTable(db),
                                referencedColumn: $$FoodServingsTableReferences
                                    ._foodIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FoodServingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodServingsTable,
      FoodServingRow,
      $$FoodServingsTableFilterComposer,
      $$FoodServingsTableOrderingComposer,
      $$FoodServingsTableAnnotationComposer,
      $$FoodServingsTableCreateCompanionBuilder,
      $$FoodServingsTableUpdateCompanionBuilder,
      (FoodServingRow, $$FoodServingsTableReferences),
      FoodServingRow,
      PrefetchHooks Function({bool foodId})
    >;
typedef $$DiaryEntriesTableCreateCompanionBuilder =
    DiaryEntriesCompanion Function({
      required String id,
      required String anonymousUserId,
      Value<String?> foodId,
      required String foodNameSnapshot,
      Value<String?> brandSnapshot,
      required String mealType,
      required double quantityGrams,
      required String servingDescription,
      required double energySnapshot,
      required double proteinSnapshot,
      required double carbohydrateSnapshot,
      required double fatSnapshot,
      required double fibreSnapshot,
      required double sugarSnapshot,
      required double saltSnapshot,
      required String loggedAt,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$DiaryEntriesTableUpdateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<String> id,
      Value<String> anonymousUserId,
      Value<String?> foodId,
      Value<String> foodNameSnapshot,
      Value<String?> brandSnapshot,
      Value<String> mealType,
      Value<double> quantityGrams,
      Value<String> servingDescription,
      Value<double> energySnapshot,
      Value<double> proteinSnapshot,
      Value<double> carbohydrateSnapshot,
      Value<double> fatSnapshot,
      Value<double> fibreSnapshot,
      Value<double> sugarSnapshot,
      Value<double> saltSnapshot,
      Value<String> loggedAt,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$DiaryEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntryRow> {
  $$DiaryEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$AppDatabase db) =>
      db.foods.createAlias('diary_entries__food_id__foods__id');

  $$FoodsTableProcessedTableManager? get foodId {
    final $_column = $_itemColumn<String>('food_id');
    if ($_column == null) return null;
    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anonymousUserId => $composableBuilder(
    column: $table.anonymousUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodNameSnapshot => $composableBuilder(
    column: $table.foodNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandSnapshot => $composableBuilder(
    column: $table.brandSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityGrams => $composableBuilder(
    column: $table.quantityGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get energySnapshot => $composableBuilder(
    column: $table.energySnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinSnapshot => $composableBuilder(
    column: $table.proteinSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbohydrateSnapshot => $composableBuilder(
    column: $table.carbohydrateSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatSnapshot => $composableBuilder(
    column: $table.fatSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibreSnapshot => $composableBuilder(
    column: $table.fibreSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugarSnapshot => $composableBuilder(
    column: $table.sugarSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saltSnapshot => $composableBuilder(
    column: $table.saltSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anonymousUserId => $composableBuilder(
    column: $table.anonymousUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodNameSnapshot => $composableBuilder(
    column: $table.foodNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandSnapshot => $composableBuilder(
    column: $table.brandSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityGrams => $composableBuilder(
    column: $table.quantityGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get energySnapshot => $composableBuilder(
    column: $table.energySnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinSnapshot => $composableBuilder(
    column: $table.proteinSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbohydrateSnapshot => $composableBuilder(
    column: $table.carbohydrateSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatSnapshot => $composableBuilder(
    column: $table.fatSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibreSnapshot => $composableBuilder(
    column: $table.fibreSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugarSnapshot => $composableBuilder(
    column: $table.sugarSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saltSnapshot => $composableBuilder(
    column: $table.saltSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get anonymousUserId => $composableBuilder(
    column: $table.anonymousUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foodNameSnapshot => $composableBuilder(
    column: $table.foodNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandSnapshot => $composableBuilder(
    column: $table.brandSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get quantityGrams => $composableBuilder(
    column: $table.quantityGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => column,
  );

  GeneratedColumn<double> get energySnapshot => $composableBuilder(
    column: $table.energySnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinSnapshot => $composableBuilder(
    column: $table.proteinSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbohydrateSnapshot => $composableBuilder(
    column: $table.carbohydrateSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatSnapshot => $composableBuilder(
    column: $table.fatSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fibreSnapshot => $composableBuilder(
    column: $table.fibreSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sugarSnapshot => $composableBuilder(
    column: $table.sugarSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saltSnapshot => $composableBuilder(
    column: $table.saltSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryEntriesTable,
          DiaryEntryRow,
          $$DiaryEntriesTableFilterComposer,
          $$DiaryEntriesTableOrderingComposer,
          $$DiaryEntriesTableAnnotationComposer,
          $$DiaryEntriesTableCreateCompanionBuilder,
          $$DiaryEntriesTableUpdateCompanionBuilder,
          (DiaryEntryRow, $$DiaryEntriesTableReferences),
          DiaryEntryRow,
          PrefetchHooks Function({bool foodId})
        > {
  $$DiaryEntriesTableTableManager(_$AppDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> anonymousUserId = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String> foodNameSnapshot = const Value.absent(),
                Value<String?> brandSnapshot = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<double> quantityGrams = const Value.absent(),
                Value<String> servingDescription = const Value.absent(),
                Value<double> energySnapshot = const Value.absent(),
                Value<double> proteinSnapshot = const Value.absent(),
                Value<double> carbohydrateSnapshot = const Value.absent(),
                Value<double> fatSnapshot = const Value.absent(),
                Value<double> fibreSnapshot = const Value.absent(),
                Value<double> sugarSnapshot = const Value.absent(),
                Value<double> saltSnapshot = const Value.absent(),
                Value<String> loggedAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryEntriesCompanion(
                id: id,
                anonymousUserId: anonymousUserId,
                foodId: foodId,
                foodNameSnapshot: foodNameSnapshot,
                brandSnapshot: brandSnapshot,
                mealType: mealType,
                quantityGrams: quantityGrams,
                servingDescription: servingDescription,
                energySnapshot: energySnapshot,
                proteinSnapshot: proteinSnapshot,
                carbohydrateSnapshot: carbohydrateSnapshot,
                fatSnapshot: fatSnapshot,
                fibreSnapshot: fibreSnapshot,
                sugarSnapshot: sugarSnapshot,
                saltSnapshot: saltSnapshot,
                loggedAt: loggedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String anonymousUserId,
                Value<String?> foodId = const Value.absent(),
                required String foodNameSnapshot,
                Value<String?> brandSnapshot = const Value.absent(),
                required String mealType,
                required double quantityGrams,
                required String servingDescription,
                required double energySnapshot,
                required double proteinSnapshot,
                required double carbohydrateSnapshot,
                required double fatSnapshot,
                required double fibreSnapshot,
                required double sugarSnapshot,
                required double saltSnapshot,
                required String loggedAt,
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DiaryEntriesCompanion.insert(
                id: id,
                anonymousUserId: anonymousUserId,
                foodId: foodId,
                foodNameSnapshot: foodNameSnapshot,
                brandSnapshot: brandSnapshot,
                mealType: mealType,
                quantityGrams: quantityGrams,
                servingDescription: servingDescription,
                energySnapshot: energySnapshot,
                proteinSnapshot: proteinSnapshot,
                carbohydrateSnapshot: carbohydrateSnapshot,
                fatSnapshot: fatSnapshot,
                fibreSnapshot: fibreSnapshot,
                sugarSnapshot: sugarSnapshot,
                saltSnapshot: saltSnapshot,
                loggedAt: loggedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({foodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (foodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.foodId,
                                referencedTable: $$DiaryEntriesTableReferences
                                    ._foodIdTable(db),
                                referencedColumn: $$DiaryEntriesTableReferences
                                    ._foodIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryEntriesTable,
      DiaryEntryRow,
      $$DiaryEntriesTableFilterComposer,
      $$DiaryEntriesTableOrderingComposer,
      $$DiaryEntriesTableAnnotationComposer,
      $$DiaryEntriesTableCreateCompanionBuilder,
      $$DiaryEntriesTableUpdateCompanionBuilder,
      (DiaryEntryRow, $$DiaryEntriesTableReferences),
      DiaryEntryRow,
      PrefetchHooks Function({bool foodId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$FoodServingsTableTableManager get foodServings =>
      $$FoodServingsTableTableManager(_db, _db.foodServings);
  $$DiaryEntriesTableTableManager get diaryEntries =>
      $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
}
