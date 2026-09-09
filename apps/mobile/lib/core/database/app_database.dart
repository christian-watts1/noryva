import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../features/diary/domain/diary_entry.dart' as domain_diary;
import '../../features/foods/domain/food.dart' as domain_food;

part 'app_database.g.dart';

final databaseProvider = Provider<AppDatabase>(
  (_) => throw StateError('Database not initialised'),
);
const _uuid = Uuid();

@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get anonymousUserId => text()();
  TextColumn get deviceCreatedAt => text()();
  BoolColumn get onboardingCompleted => boolean()();
  IntColumn get onboardingStep => integer()();
  TextColumn get bodyDraft => text().nullable()();
  TextColumn get goal => text().nullable()();
  TextColumn get dateOfBirth => text().nullable()();
  TextColumn get calculationSex => text().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get activity => text().nullable()();
  RealColumn get goalWeightKg => real().nullable()();
  RealColumn get rateKgWeek => real().nullable()();
  RealColumn get bmr => real().nullable()();
  RealColumn get maintenanceCalories => real().nullable()();
  RealColumn get goalAdjustment => real().nullable()();
  RealColumn get calorieTarget => real().nullable()();
  RealColumn get proteinTarget => real().nullable()();
  RealColumn get carbohydrateTarget => real().nullable()();
  RealColumn get fatTarget => real().nullable()();
  BoolColumn get targetClamped => boolean().nullable()();
  TextColumn get clampReason => text().nullable()();

  @override
  String get tableName => 'profile';

  @override
  Set<Column<Object>> get primaryKey => {anonymousUserId};
}

@DataClassName('FoodRow')
class Foods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get source => text()();
  TextColumn get verificationStatus => text()();
  TextColumn get barcode => text().nullable()();
  RealColumn get energy => real()();
  RealColumn get protein => real()();
  RealColumn get carbohydrate => real()();
  RealColumn get fat => real()();
  RealColumn get fibre => real()();
  RealColumn get sugar => real()();
  RealColumn get salt => real()();
  TextColumn get commonServing => text().nullable()();
  RealColumn get commonServingGrams => real().nullable()();
  BoolColumn get isCommon => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get basisUnit => text().withDefault(const Constant('g'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FoodServingRow')
class FoodServings extends Table {
  TextColumn get id => text()();
  TextColumn get foodId => text().references(Foods, #id)();
  TextColumn get label => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  RealColumn get canonicalQuantity => real()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DiaryEntryRow')
class DiaryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get anonymousUserId => text()();
  TextColumn get foodId => text().nullable().references(Foods, #id)();
  TextColumn get foodNameSnapshot => text()();
  TextColumn get brandSnapshot => text().nullable()();
  TextColumn get mealType => text()();
  RealColumn get quantityGrams => real()();
  TextColumn get servingDescription => text()();
  RealColumn get energySnapshot => real()();
  RealColumn get proteinSnapshot => real()();
  RealColumn get carbohydrateSnapshot => real()();
  RealColumn get fatSnapshot => real()();
  RealColumn get fibreSnapshot => real()();
  RealColumn get sugarSnapshot => real()();
  RealColumn get saltSnapshot => real()();
  TextColumn get loggedAt => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Profiles, Foods, FoodServings, DiaryEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.executor);

  @override
  int get schemaVersion => 3;

  static Future<AppDatabase> open({File? file}) async {
    final resolved =
        file ??
        File(
          p.join(
            (await getApplicationDocumentsDirectory()).path,
            'noryva.sqlite',
          ),
        );
    final database = AppDatabase._(NativeDatabase(resolved));
    await database.ensureIdentity();
    return database;
  }

  static Future<AppDatabase> memory() async {
    final database = AppDatabase._(NativeDatabase.memory());
    await database.ensureIdentity();
    return database;
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        await migrator.addColumn(foods, foods.basisUnit);
        await migrator.createTable(foodServings);
      }
      if (from < 3) {
        await migrator.addColumn(profiles, profiles.bodyDraft);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await _seedFoods();
      await _seedServings();
    },
  );

  Future<String> ensureIdentity() async {
    final row = await (select(profiles)..limit(1)).getSingleOrNull();
    if (row != null) {
      return row.anonymousUserId;
    }
    final id = _uuid.v4();
    await into(profiles).insert(
      ProfilesCompanion.insert(
        anonymousUserId: id,
        deviceCreatedAt: DateTime.now().toUtc().toIso8601String(),
        onboardingCompleted: false,
        onboardingStep: 0,
      ),
    );
    return id;
  }

  Future<Map<String, Object?>?> profile() async {
    final rows = await customSelect('SELECT * FROM profile LIMIT 1').get();
    return rows.isEmpty ? null : rows.first.data;
  }

  Future<void> saveBodyDraft(
    String draft, {
    double? heightCm,
    double? weightKg,
    String? dateOfBirth,
    String? sex,
  }) async {
    await customStatement(
      'UPDATE profile SET body_draft=?, height_cm=?, weight_kg=?, date_of_birth=?, calculation_sex=?',
      [draft, heightCm, weightKg, dateOfBirth, sex],
    );
  }

  Future<void> saveOnboarding({
    required int step,
    String? goal,
    String? dateOfBirth,
    String? sex,
    double? heightCm,
    double? weightKg,
    String? activity,
    double? goalWeightKg,
    double? rateKgWeek,
  }) async {
    await customStatement(
      'UPDATE profile SET onboarding_step=?, goal=COALESCE(?,goal), '
      'date_of_birth=COALESCE(?,date_of_birth), '
      'calculation_sex=COALESCE(?,calculation_sex), '
      'height_cm=COALESCE(?,height_cm), weight_kg=COALESCE(?,weight_kg), '
      'activity=COALESCE(?,activity), '
      'goal_weight_kg=COALESCE(?,goal_weight_kg), '
      'rate_kg_week=COALESCE(?,rate_kg_week)',
      [
        step,
        goal,
        dateOfBirth,
        sex,
        heightCm,
        weightKg,
        activity,
        goalWeightKg,
        rateKgWeek,
      ],
    );
  }

  Future<void> savePlan({
    required double bmr,
    required double maintenance,
    required double adjustment,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required bool clamped,
    String? reason,
  }) async {
    await customStatement(
      'UPDATE profile SET bmr=?, maintenance_calories=?, goal_adjustment=?, '
      'calorie_target=?, protein_target=?, carbohydrate_target=?, '
      'fat_target=?, target_clamped=?, clamp_reason=?, onboarding_step=5',
      [
        bmr,
        maintenance,
        adjustment,
        calories,
        protein,
        carbs,
        fat,
        clamped ? 1 : 0,
        reason,
      ],
    );
  }

  Future<void> completeOnboarding() async {
    await customStatement(
      'UPDATE profile SET onboarding_completed=1, onboarding_step=6',
    );
  }

  Future<List<domain_food.Food>> searchFoods(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      final sections = await foodSearchSections();
      final seen = <String>{};
      return [
        ...sections.recent,
        ...sections.common,
      ].where((food) => seen.add(food.id)).toList();
    }
    final rows = await customSelect(
      'SELECT * FROM foods WHERE lower(name) LIKE ? '
      "OR lower(COALESCE(brand,'')) LIKE ? "
      'ORDER BY CASE WHEN lower(name)=? THEN 0 '
      'WHEN lower(name) LIKE ? THEN 1 ELSE 2 END, name LIMIT 50',
      variables: [
        Variable.withString('%$normalized%'),
        Variable.withString('%$normalized%'),
        Variable.withString(normalized),
        Variable.withString('$normalized%'),
      ],
    ).get();
    return rows.map((row) => _foodFromRow(row.data)).toList();
  }

  Future<domain_food.FoodSearchSections> foodSearchSections() async {
    final recentRows = await customSelect(
      'SELECT f.*, MAX(d.logged_at) AS last_logged FROM foods f '
      'JOIN diary_entries d ON d.food_id=f.id GROUP BY f.id '
      'ORDER BY last_logged DESC LIMIT 10',
    ).get();
    final commonRows = await customSelect(
      'SELECT * FROM foods WHERE is_common=1 ORDER BY name LIMIT 20',
    ).get();
    return domain_food.FoodSearchSections(
      recent: recentRows.map((row) => _foodFromRow(row.data)).toList(),
      common: commonRows.map((row) => _foodFromRow(row.data)).toList(),
    );
  }

  Future<domain_food.Food?> food(String id) async {
    final row = await (select(
      foods,
    )..where((food) => food.id.equals(id))).getSingleOrNull();
    return row == null ? null : _foodFromGenerated(row);
  }

  Future<List<domain_food.FoodServing>> servingsForFood(String foodId) async {
    final rows =
        await (select(foodServings)
              ..where((serving) => serving.foodId.equals(foodId))
              ..orderBy([(serving) => OrderingTerm.asc(serving.displayOrder)]))
            .get();
    return rows
        .map(
          (row) => domain_food.FoodServing(
            id: row.id,
            foodId: row.foodId,
            label: row.label,
            quantity: row.quantity,
            unit: row.unit,
            canonicalQuantity: row.canonicalQuantity,
            isDefault: row.isDefault,
          ),
        )
        .toList();
  }

  Future<void> logFood({
    required domain_food.Food food,
    required double canonicalQuantity,
    required String servingDescription,
    required domain_diary.MealType meal,
    required DateTime loggedAt,
  }) async {
    if (canonicalQuantity <= 0 || canonicalQuantity > 5000) {
      throw ArgumentError.value(canonicalQuantity, 'canonicalQuantity');
    }
    final userId = await ensureIdentity();
    final now = DateTime.now().toUtc().toIso8601String();
    await into(diaryEntries).insert(
      DiaryEntriesCompanion.insert(
        id: _uuid.v4(),
        anonymousUserId: userId,
        foodId: Value(food.id),
        foodNameSnapshot: food.name,
        brandSnapshot: Value(food.brand),
        mealType: meal.name,
        quantityGrams: canonicalQuantity,
        servingDescription: servingDescription,
        energySnapshot: food.scale(canonicalQuantity, food.energy),
        proteinSnapshot: food.scale(canonicalQuantity, food.protein),
        carbohydrateSnapshot: food.scale(canonicalQuantity, food.carbohydrate),
        fatSnapshot: food.scale(canonicalQuantity, food.fat),
        fibreSnapshot: food.scale(canonicalQuantity, food.fibre),
        sugarSnapshot: food.scale(canonicalQuantity, food.sugar),
        saltSnapshot: food.scale(canonicalQuantity, food.salt),
        loggedAt: loggedAt.toUtc().toIso8601String(),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<List<domain_diary.DiaryEntry>> diaryFor(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day).toUtc();
    final end = start.add(const Duration(days: 1));
    final rows = await customSelect(
      'SELECT * FROM diary_entries WHERE logged_at>=? AND logged_at<? '
      'ORDER BY logged_at',
      variables: [
        Variable.withString(start.toIso8601String()),
        Variable.withString(end.toIso8601String()),
      ],
    ).get();
    return rows.map((row) => _entryFromRow(row.data)).toList();
  }

  Future<void> editEntry(
    String id, {
    required double canonicalQuantity,
    required domain_diary.MealType meal,
  }) async {
    final row = await (select(
      diaryEntries,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    if (row == null || canonicalQuantity <= 0) {
      throw ArgumentError('Invalid diary entry update.');
    }
    final ratio = canonicalQuantity / row.quantityGrams;
    await customStatement(
      'UPDATE diary_entries SET quantity_grams=?, serving_description=?, '
      'meal_type=?, energy_snapshot=energy_snapshot*?, '
      'protein_snapshot=protein_snapshot*?, '
      'carbohydrate_snapshot=carbohydrate_snapshot*?, '
      'fat_snapshot=fat_snapshot*?, fibre_snapshot=fibre_snapshot*?, '
      'sugar_snapshot=sugar_snapshot*?, salt_snapshot=salt_snapshot*?, '
      'updated_at=? WHERE id=?',
      [
        canonicalQuantity,
        '${canonicalQuantity.toStringAsFixed(0)}g',
        meal.name,
        ratio,
        ratio,
        ratio,
        ratio,
        ratio,
        ratio,
        ratio,
        DateTime.now().toUtc().toIso8601String(),
        id,
      ],
    );
  }

  Future<void> deleteEntry(String id) async {
    await (delete(diaryEntries)..where((entry) => entry.id.equals(id))).go();
  }

  @visibleForTesting
  Future<void> updateFoodEnergyForTest(String id, double energy) async {
    await (update(foods)..where((food) => food.id.equals(id))).write(
      FoodsCompanion(energy: Value(energy)),
    );
  }

  Future<void> resetLocalData() async {
    await transaction(() async {
      await delete(diaryEntries).go();
      await delete(profiles).go();
    });
    await ensureIdentity();
  }

  Future<void> _seedFoods() async {
    final count = await foods.count().getSingle();
    if (count > 0) {
      return;
    }
    final now = DateTime.now().toUtc().toIso8601String();
    for (final row in _seedFoodRows) {
      await into(foods).insert(
        FoodsCompanion.insert(
          id: row.id,
          name: row.name,
          source: 'noryva_demo_seed_v1',
          verificationStatus: 'verified',
          energy: row.energy,
          protein: row.protein,
          carbohydrate: row.carbohydrate,
          fat: row.fat,
          fibre: row.fibre,
          sugar: row.sugar,
          salt: row.salt,
          isCommon: const Value(true),
          createdAt: now,
          updatedAt: now,
          basisUnit: Value(row.basisUnit),
        ),
      );
    }
  }

  Future<void> _seedServings() async {
    final count = await foodServings.count().getSingle();
    if (count > 0) {
      return;
    }
    for (final row in _seedServingRows) {
      await into(foodServings).insert(
        FoodServingsCompanion.insert(
          id: row.id,
          foodId: row.foodId,
          label: row.label,
          quantity: row.quantity,
          unit: row.unit,
          canonicalQuantity: row.canonicalQuantity,
          isDefault: Value(row.isDefault),
          displayOrder: Value(row.order),
        ),
      );
    }
  }
}

domain_food.Food _foodFromGenerated(FoodRow row) => domain_food.Food(
  id: row.id,
  name: row.name,
  brand: row.brand,
  source: row.source,
  verificationStatus: row.verificationStatus,
  energy: row.energy,
  protein: row.protein,
  carbohydrate: row.carbohydrate,
  fat: row.fat,
  fibre: row.fibre,
  sugar: row.sugar,
  salt: row.salt,
  basisUnit: row.basisUnit,
);

domain_food.Food _foodFromRow(Map<String, Object?> row) => domain_food.Food(
  id: row['id']! as String,
  name: row['name']! as String,
  brand: row['brand'] as String?,
  source: row['source']! as String,
  verificationStatus: row['verification_status']! as String,
  energy: (row['energy']! as num).toDouble(),
  protein: (row['protein']! as num).toDouble(),
  carbohydrate: (row['carbohydrate']! as num).toDouble(),
  fat: (row['fat']! as num).toDouble(),
  fibre: (row['fibre']! as num).toDouble(),
  sugar: (row['sugar']! as num).toDouble(),
  salt: (row['salt']! as num).toDouble(),
  basisUnit: row['basis_unit']! as String,
);

domain_diary.DiaryEntry _entryFromRow(Map<String, Object?> row) =>
    domain_diary.DiaryEntry(
      id: row['id']! as String,
      anonymousUserId: row['anonymous_user_id']! as String,
      foodId: row['food_id'] as String?,
      foodName: row['food_name_snapshot']! as String,
      brand: row['brand_snapshot'] as String?,
      meal: domain_diary.MealType.values.byName(row['meal_type']! as String),
      quantityGrams: (row['quantity_grams']! as num).toDouble(),
      servingDescription: row['serving_description']! as String,
      energy: (row['energy_snapshot']! as num).toDouble(),
      protein: (row['protein_snapshot']! as num).toDouble(),
      carbohydrate: (row['carbohydrate_snapshot']! as num).toDouble(),
      fat: (row['fat_snapshot']! as num).toDouble(),
      fibre: (row['fibre_snapshot']! as num).toDouble(),
      sugar: (row['sugar_snapshot']! as num).toDouble(),
      salt: (row['salt_snapshot']! as num).toDouble(),
      loggedAt: DateTime.parse(row['logged_at']! as String),
    );

class _SeedFood {
  const _SeedFood(
    this.id,
    this.name,
    this.energy,
    this.protein,
    this.carbohydrate,
    this.fat,
    this.fibre,
    this.sugar,
    this.salt, {
    this.basisUnit = 'g',
  });
  final String id;
  final String name;
  final double energy;
  final double protein;
  final double carbohydrate;
  final double fat;
  final double fibre;
  final double sugar;
  final double salt;
  final String basisUnit;
}

class _SeedServing {
  const _SeedServing(
    this.id,
    this.foodId,
    this.label,
    this.quantity,
    this.unit,
    this.canonicalQuantity,
    this.order, {
    this.isDefault = false,
  });
  final String id;
  final String foodId;
  final String label;
  final double quantity;
  final String unit;
  final double canonicalQuantity;
  final int order;
  final bool isDefault;
}

const _seedFoodRows = <_SeedFood>[
  _SeedFood('chicken-breast', 'Chicken breast', 165, 31, 0, 3.6, 0, 0, .18),
  _SeedFood('egg', 'Egg', 143, 12.6, .7, 9.5, 0, .4, .36),
  _SeedFood('banana', 'Banana', 89, 1.1, 22.8, .3, 2.6, 12.2, 0),
  _SeedFood('apple', 'Apple', 52, .3, 13.8, .2, 2.4, 10.4, 0),
  _SeedFood('wholemeal-bread', 'Wholemeal bread', 247, 13, 41, 3.4, 7, 6, 1),
  _SeedFood('white-rice', 'White rice, cooked', 130, 2.7, 28, .3, .4, .1, 0),
  _SeedFood(
    'basmati-rice',
    'Basmati rice, cooked',
    121,
    3.5,
    25.2,
    .4,
    .4,
    0,
    0,
  ),
  _SeedFood('broccoli', 'Broccoli', 34, 2.8, 6.6, .4, 2.6, 1.7, .08),
  _SeedFood(
    'milk',
    'Semi-skimmed milk',
    46,
    3.6,
    4.8,
    1.7,
    0,
    4.8,
    .1,
    basisUnit: 'ml',
  ),
  _SeedFood('oats', 'Oats', 379, 13.2, 67.7, 6.5, 10.1, 1, .01),
  _SeedFood('greek-yoghurt', 'Greek yoghurt', 97, 9, 3.9, 5, 0, 3.9, .09),
  _SeedFood('cheddar', 'Cheddar cheese', 403, 24.9, 1.3, 33.1, 0, .5, 1.55),
  _SeedFood('potato', 'Potato, boiled', 87, 1.9, 20.1, .1, 1.8, .9, .01),
  _SeedFood('salmon', 'Salmon', 208, 20.4, 0, 13.4, 0, 0, .15),
  _SeedFood('tuna', 'Tuna in spring water', 116, 25.5, 0, .8, 0, 0, .3),
  _SeedFood('pasta', 'Pasta, cooked', 157, 5.8, 30.9, .9, 1.8, .6, .01),
  _SeedFood('peanut-butter', 'Peanut butter', 588, 25, 20, 50, 6, 9, 1.1),
  _SeedFood('olive-oil', 'Olive oil', 884, 0, 0, 100, 0, 0, 0),
  _SeedFood('beef-mince', 'Lean beef mince', 215, 26, 0, 12, 0, 0, .18),
  _SeedFood('tofu', 'Firm tofu', 144, 17, 2.8, 8.7, 2.3, .6, .02),
  _SeedFood('lentils', 'Lentils, cooked', 116, 9, 20, .4, 7.9, 1.8, 0),
  _SeedFood(
    'chickpeas',
    'Chickpeas, cooked',
    164,
    8.9,
    27.4,
    2.6,
    7.6,
    4.8,
    .02,
  ),
  _SeedFood('avocado', 'Avocado', 160, 2, 8.5, 14.7, 6.7, .7, .02),
  _SeedFood('orange', 'Orange', 47, .9, 11.8, .1, 2.4, 9.4, 0),
  _SeedFood('strawberries', 'Strawberries', 32, .7, 7.7, .3, 2, 4.9, 0),
  _SeedFood('blueberries', 'Blueberries', 57, .7, 14.5, .3, 2.4, 10, 0),
  _SeedFood('spinach', 'Spinach', 23, 2.9, 3.6, .4, 2.2, .4, .2),
  _SeedFood('sweet-potato', 'Sweet potato', 86, 1.6, 20.1, .1, 3, 4.2, .06),
  _SeedFood(
    'cottage-cheese',
    'Cottage cheese',
    98,
    11.1,
    3.4,
    4.3,
    0,
    2.7,
    .36,
  ),
  _SeedFood('quinoa', 'Quinoa, cooked', 120, 4.4, 21.3, 1.9, 2.8, .9, .01),
];

const _seedServingRows = <_SeedServing>[
  _SeedServing(
    'chicken-100g',
    'chicken-breast',
    '100 g',
    100,
    'g',
    100,
    0,
    isDefault: true,
  ),
  _SeedServing('egg-100g', 'egg', '100 g', 100, 'g', 100, 0),
  _SeedServing(
    'egg-large',
    'egg',
    '1 large egg',
    1,
    'egg',
    60,
    1,
    isDefault: true,
  ),
  _SeedServing('banana-100g', 'banana', '100 g', 100, 'g', 100, 0),
  _SeedServing(
    'banana-medium',
    'banana',
    '1 medium banana',
    1,
    'banana',
    118,
    1,
    isDefault: true,
  ),
  _SeedServing('bread-100g', 'wholemeal-bread', '100 g', 100, 'g', 100, 0),
  _SeedServing(
    'bread-slice',
    'wholemeal-bread',
    '1 slice',
    1,
    'slice',
    38,
    1,
    isDefault: true,
  ),
  _SeedServing('milk-100ml', 'milk', '100 ml', 100, 'ml', 100, 0),
  _SeedServing(
    'milk-glass',
    'milk',
    '250 ml glass',
    1,
    'glass',
    250,
    1,
    isDefault: true,
  ),
];
