import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../features/diary/domain/diary_entry.dart';
import '../../features/foods/domain/food.dart';

final databaseProvider = Provider<AppDatabase>(
  (_) => throw StateError('Database not initialised'),
);
const _uuid = Uuid();

class AppDatabase {
  AppDatabase._(this._executor);
  static const schemaVersion = 1;
  final QueryExecutor _executor;

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
    await database._initialise();
    return database;
  }

  static Future<AppDatabase> memory() async {
    final database = AppDatabase._(NativeDatabase.memory());
    await database._initialise();
    return database;
  }

  Future<void> _initialise() async {
    await _executor.ensureOpen(const _NoSchema());
    final version =
        (await _executor.runSelect(
              'PRAGMA user_version',
              const [],
            )).first['user_version']
            as int;
    if (version == 0) {
      await _createSchema();
      await _executor.runCustom(
        'PRAGMA user_version = $schemaVersion',
        const [],
      );
    } else if (version != schemaVersion) {
      throw StateError('Unsupported database schema version $version');
    }
    await _seedFoods();
    await ensureIdentity();
  }

  Future<void> _createSchema() async {
    for (final statement in _schemaStatements) {
      await _executor.runCustom(statement, const []);
    }
  }

  Future<String> ensureIdentity() async {
    final rows = await _executor.runSelect(
      'SELECT anonymous_user_id FROM profile LIMIT 1',
      const [],
    );
    if (rows.isNotEmpty) return rows.first['anonymous_user_id'] as String;
    final id = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    await _executor.runInsert(
      'INSERT INTO profile (anonymous_user_id, device_created_at, onboarding_completed, onboarding_step) VALUES (?, ?, 0, 0)',
      [id, now],
    );
    return id;
  }

  Future<Map<String, Object?>?> profile() async {
    final rows = await _executor.runSelect(
      'SELECT * FROM profile LIMIT 1',
      const [],
    );
    return rows.isEmpty ? null : rows.first;
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
    await _executor.runUpdate(
      'UPDATE profile SET onboarding_step=?, goal=COALESCE(?,goal), date_of_birth=COALESCE(?,date_of_birth), calculation_sex=COALESCE(?,calculation_sex), height_cm=COALESCE(?,height_cm), weight_kg=COALESCE(?,weight_kg), activity=COALESCE(?,activity), goal_weight_kg=COALESCE(?,goal_weight_kg), rate_kg_week=COALESCE(?,rate_kg_week)',
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
    await _executor.runUpdate(
      'UPDATE profile SET bmr=?, maintenance_calories=?, goal_adjustment=?, calorie_target=?, protein_target=?, carbohydrate_target=?, fat_target=?, target_clamped=?, clamp_reason=?, onboarding_step=5',
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
    await _executor.runUpdate(
      'UPDATE profile SET onboarding_completed=1, onboarding_step=6',
      const [],
    );
  }

  Future<List<Food>> searchFoods(String query) async {
    final q = query.trim().toLowerCase();
    final rows = await _executor.runSelect(
      q.isEmpty ? 'SELECT * FROM foods ORDER BY is_common DESC, name LIMIT 20' : 'SELECT * FROM foods WHERE lower(name) LIKE ? OR lower(COALESCE(brand,\'\')) LIKE ? ORDER BY CASE WHEN lower(name)=? THEN 0 WHEN lower(name) LIKE ? THEN 1 ELSE 2 END, name LIMIT 50',
      q.isEmpty ? const [] : ['%$q%', '%$q%', q, '$q%'],
    );
    return rows.map(_foodFromRow).toList();
  }

  Future<Food?> food(String id) async {
    final rows = await _executor.runSelect('SELECT * FROM foods WHERE id=?', [
      id,
    ]);
    return rows.isEmpty ? null : _foodFromRow(rows.first);
  }

  Future<void> logFood({
    required Food food,
    required double grams,
    required MealType meal,
    required DateTime loggedAt,
  }) async {
    if (grams <= 0 || grams > 5000) throw ArgumentError.value(grams, 'grams');
    final userId = await ensureIdentity();
    final now = DateTime.now().toUtc().toIso8601String();
    await _executor.runInsert(
      'INSERT INTO diary_entries (id,anonymous_user_id,food_id,food_name_snapshot,brand_snapshot,meal_type,quantity_grams,serving_description,energy_snapshot,protein_snapshot,carbohydrate_snapshot,fat_snapshot,fibre_snapshot,sugar_snapshot,salt_snapshot,logged_at,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
      [
        _uuid.v4(),
        userId,
        food.id,
        food.name,
        food.brand,
        meal.name,
        grams,
        '${grams.toStringAsFixed(0)}g',
        food.scale(grams, food.energy),
        food.scale(grams, food.protein),
        food.scale(grams, food.carbohydrate),
        food.scale(grams, food.fat),
        food.scale(grams, food.fibre),
        food.scale(grams, food.sugar),
        food.scale(grams, food.salt),
        loggedAt.toUtc().toIso8601String(),
        now,
        now,
      ],
    );
  }

  Future<List<DiaryEntry>> diaryFor(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day).toUtc();
    final end = start.add(const Duration(days: 1));
    final rows = await _executor.runSelect(
      'SELECT * FROM diary_entries WHERE logged_at>=? AND logged_at<? ORDER BY logged_at',
      [start.toIso8601String(), end.toIso8601String()],
    );
    return rows.map(_entryFromRow).toList();
  }

  Future<void> editEntry(
    String id, {
    required double grams,
    required MealType meal,
  }) async {
    final rows = await _executor.runSelect(
      'SELECT * FROM diary_entries WHERE id=?',
      [id],
    );
    if (rows.isEmpty || grams <= 0)
      throw ArgumentError('Invalid diary entry update.');
    final row = rows.first;
    final old = row['quantity_grams'] as double;
    final ratio = grams / old;
    await _executor.runUpdate(
      'UPDATE diary_entries SET quantity_grams=?, serving_description=?, meal_type=?, energy_snapshot=energy_snapshot*?, protein_snapshot=protein_snapshot*?, carbohydrate_snapshot=carbohydrate_snapshot*?, fat_snapshot=fat_snapshot*?, fibre_snapshot=fibre_snapshot*?, sugar_snapshot=sugar_snapshot*?, salt_snapshot=salt_snapshot*?, updated_at=? WHERE id=?',
      [
        grams,
        '${grams.toStringAsFixed(0)}g',
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
    await _executor.runDelete('DELETE FROM diary_entries WHERE id=?', [id]);
  }

  @visibleForTesting
  Future<void> updateFoodEnergyForTest(String id, double energy) async {
    await _executor.runUpdate('UPDATE foods SET energy=? WHERE id=?', [
      energy,
      id,
    ]);
  }

  Future<void> resetLocalData() async {
    await _executor.runCustom('BEGIN IMMEDIATE', const []);
    try {
      await _executor.runDelete('DELETE FROM diary_entries', const []);
      await _executor.runDelete('DELETE FROM profile', const []);
      await _executor.runCustom('COMMIT', const []);
    } catch (_) {
      await _executor.runCustom('ROLLBACK', const []);
      rethrow;
    }
    await ensureIdentity();
  }

  Future<void> close() => _executor.close();
}

class _NoSchema extends QueryExecutorUser {
  const _NoSchema();
  @override
  int get schemaVersion => AppDatabase.schemaVersion;
  @override
  Future<void> beforeOpen(
    QueryExecutor executor,
    OpeningDetails details,
  ) async {}
}

Food _foodFromRow(Map<String, Object?> row) => Food(
  id: row['id']! as String,
  name: row['name']! as String,
  brand: row['brand'] as String?,
  source: row['source']! as String,
  verificationStatus: row['verification_status']! as String,
  energy: row['energy']! as double,
  protein: row['protein']! as double,
  carbohydrate: row['carbohydrate']! as double,
  fat: row['fat']! as double,
  fibre: row['fibre']! as double,
  sugar: row['sugar']! as double,
  salt: row['salt']! as double,
  commonServing: row['common_serving'] as String?,
  commonServingGrams: row['common_serving_grams'] as double?,
);

DiaryEntry _entryFromRow(Map<String, Object?> r) => DiaryEntry(
  id: r['id']! as String,
  anonymousUserId: r['anonymous_user_id']! as String,
  foodId: r['food_id'] as String?,
  foodName: r['food_name_snapshot']! as String,
  brand: r['brand_snapshot'] as String?,
  meal: MealType.values.byName(r['meal_type']! as String),
  quantityGrams: r['quantity_grams']! as double,
  servingDescription: r['serving_description']! as String,
  energy: r['energy_snapshot']! as double,
  protein: r['protein_snapshot']! as double,
  carbohydrate: r['carbohydrate_snapshot']! as double,
  fat: r['fat_snapshot']! as double,
  fibre: r['fibre_snapshot']! as double,
  sugar: r['sugar_snapshot']! as double,
  salt: r['salt_snapshot']! as double,
  loggedAt: DateTime.parse(r['logged_at']! as String),
);

const _schemaStatements = [
  '''CREATE TABLE profile (anonymous_user_id TEXT PRIMARY KEY, device_created_at TEXT NOT NULL, onboarding_completed INTEGER NOT NULL, onboarding_step INTEGER NOT NULL, goal TEXT, date_of_birth TEXT, calculation_sex TEXT, height_cm REAL, weight_kg REAL, activity TEXT, goal_weight_kg REAL, rate_kg_week REAL, bmr REAL, maintenance_calories REAL, goal_adjustment REAL, calorie_target REAL, protein_target REAL, carbohydrate_target REAL, fat_target REAL, target_clamped INTEGER, clamp_reason TEXT)''',
  '''CREATE TABLE foods (id TEXT PRIMARY KEY, name TEXT NOT NULL, brand TEXT, source TEXT NOT NULL, verification_status TEXT NOT NULL, barcode TEXT, energy REAL NOT NULL, protein REAL NOT NULL, carbohydrate REAL NOT NULL, fat REAL NOT NULL, fibre REAL NOT NULL, sugar REAL NOT NULL, salt REAL NOT NULL, common_serving TEXT, common_serving_grams REAL, is_common INTEGER NOT NULL DEFAULT 0, created_at TEXT NOT NULL, updated_at TEXT NOT NULL)''',
  '''CREATE TABLE diary_entries (id TEXT PRIMARY KEY, anonymous_user_id TEXT NOT NULL, food_id TEXT REFERENCES foods(id) ON DELETE SET NULL, food_name_snapshot TEXT NOT NULL, brand_snapshot TEXT, meal_type TEXT NOT NULL, quantity_grams REAL NOT NULL, serving_description TEXT NOT NULL, energy_snapshot REAL NOT NULL, protein_snapshot REAL NOT NULL, carbohydrate_snapshot REAL NOT NULL, fat_snapshot REAL NOT NULL, fibre_snapshot REAL NOT NULL, sugar_snapshot REAL NOT NULL, salt_snapshot REAL NOT NULL, logged_at TEXT NOT NULL, created_at TEXT NOT NULL, updated_at TEXT NOT NULL)''',
  'CREATE INDEX diary_logged_at ON diary_entries(logged_at)',
  'CREATE INDEX foods_name ON foods(name)',
];

extension on AppDatabase {
  Future<void> _seedFoods() async {
    final count =
        (await _executor.runSelect(
              'SELECT COUNT(*) AS count FROM foods',
              const [],
            )).first['count']
            as int;
    if (count > 0) return;
    const rows = <List<Object>>[
      ['chicken-breast', 'Chicken breast', 165, 31, 0, 3.6, 0, 0, 0.18],
      ['egg', 'Egg', 143, 12.6, 0.7, 9.5, 0, 0.4, 0.36],
      ['banana', 'Banana', 89, 1.1, 22.8, 0.3, 2.6, 12.2, 0],
      ['apple', 'Apple', 52, 0.3, 13.8, 0.2, 2.4, 10.4, 0],
      ['wholemeal-bread', 'Wholemeal bread', 247, 13, 41, 3.4, 7, 6, 1],
      ['white-rice', 'White rice, cooked', 130, 2.7, 28, 0.3, 0.4, 0.1, 0],
      ['basmati-rice', 'Basmati rice, cooked', 121, 3.5, 25.2, 0.4, 0.4, 0, 0],
      ['broccoli', 'Broccoli', 34, 2.8, 6.6, 0.4, 2.6, 1.7, 0.08],
      ['milk', 'Semi-skimmed milk', 46, 3.6, 4.8, 1.7, 0, 4.8, 0.1],
      ['oats', 'Oats', 379, 13.2, 67.7, 6.5, 10.1, 1, 0.01],
      ['greek-yoghurt', 'Greek yoghurt', 97, 9, 3.9, 5, 0, 3.9, 0.09],
      ['cheddar', 'Cheddar cheese', 403, 24.9, 1.3, 33.1, 0, 0.5, 1.55],
      ['potato', 'Potato, boiled', 87, 1.9, 20.1, 0.1, 1.8, 0.9, 0.01],
      ['salmon', 'Salmon', 208, 20.4, 0, 13.4, 0, 0, 0.15],
      ['tuna', 'Tuna in spring water', 116, 25.5, 0, 0.8, 0, 0, 0.3],
      ['pasta', 'Pasta, cooked', 157, 5.8, 30.9, 0.9, 1.8, 0.6, 0.01],
      ['peanut-butter', 'Peanut butter', 588, 25, 20, 50, 6, 9, 1.1],
      ['olive-oil', 'Olive oil', 884, 0, 0, 100, 0, 0, 0],
      ['beef-mince', 'Lean beef mince', 215, 26, 0, 12, 0, 0, 0.18],
      ['tofu', 'Firm tofu', 144, 17, 2.8, 8.7, 2.3, 0.6, 0.02],
      ['lentils', 'Lentils, cooked', 116, 9, 20, 0.4, 7.9, 1.8, 0],
      ['chickpeas', 'Chickpeas, cooked', 164, 8.9, 27.4, 2.6, 7.6, 4.8, 0.02],
      ['avocado', 'Avocado', 160, 2, 8.5, 14.7, 6.7, 0.7, 0.02],
      ['orange', 'Orange', 47, 0.9, 11.8, 0.1, 2.4, 9.4, 0],
      ['strawberries', 'Strawberries', 32, 0.7, 7.7, 0.3, 2, 4.9, 0],
      ['blueberries', 'Blueberries', 57, 0.7, 14.5, 0.3, 2.4, 10, 0],
      ['spinach', 'Spinach', 23, 2.9, 3.6, 0.4, 2.2, 0.4, 0.2],
      ['sweet-potato', 'Sweet potato', 86, 1.6, 20.1, 0.1, 3, 4.2, 0.06],
      ['cottage-cheese', 'Cottage cheese', 98, 11.1, 3.4, 4.3, 0, 2.7, 0.36],
      ['quinoa', 'Quinoa, cooked', 120, 4.4, 21.3, 1.9, 2.8, 0.9, 0.01],
    ];
    final now = DateTime.now().toUtc().toIso8601String();
    for (final r in rows) {
      await _executor.runInsert(
        'INSERT INTO foods (id,name,source,verification_status,energy,protein,carbohydrate,fat,fibre,sugar,salt,is_common,created_at,updated_at) VALUES (?,?,\'noryva_demo_seed_v1\',\'verified\',?,?,?,?,?,?,?,?,?,?)',
        [r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], 1, now, now],
      );
    }
  }
}
