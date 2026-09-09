import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test('schema 2 migration preserves in-progress metric onboarding', () async {
    final temp = Directory.systemTemp.createTempSync('noryva_v2_');
    final file = File('${temp.path}/legacy.sqlite');
    addTearDown(() => temp.deleteSync(recursive: true));
    var database = await AppDatabase.open(file: file);
    await database.saveOnboarding(
      step: 2,
      heightCm: 180,
      weightKg: 80,
      dateOfBirth: '1990-01-02',
    );
    final id = (await database.profile())!['anonymous_user_id'];
    await database.close();
    final legacy = sqlite.sqlite3.open(file.path);
    legacy.execute('ALTER TABLE profile DROP COLUMN body_draft');
    legacy.execute('DROP TABLE workspace_identity');
    legacy.execute('PRAGMA user_version = 2');
    legacy.close();
    database = await AppDatabase.open(file: file);
    final profile = (await database.profile())!;
    expect(profile['anonymous_user_id'], id);
    expect(profile['onboarding_step'], 2);
    expect(profile['height_cm'], 180);
    expect(profile['weight_kg'], 80);
    expect(profile['date_of_birth'], '1990-01-02');
    expect(profile['body_draft'], isNull);
    await database.close();
  });

  test('schema 1 migrates non-destructively to schema 4', () async {
    final temp = Directory.systemTemp.createTempSync('noryva_migration_');
    final file = File('${temp.path}/legacy.sqlite');
    addTearDown(() => temp.deleteSync(recursive: true));
    final legacy = sqlite.sqlite3.open(file.path);
    legacy
      ..execute(_legacyProfile)
      ..execute(_legacyFoods)
      ..execute(_legacyDiary)
      ..execute('PRAGMA user_version = 1')
      ..execute(
        "INSERT INTO profile (anonymous_user_id,device_created_at,onboarding_completed,onboarding_step,calorie_target,protein_target,carbohydrate_target,fat_target) VALUES ('legacy-user','2026-01-01T00:00:00Z',1,6,2100,150,220,70)",
      );
    for (final food in const [
      ('chicken-breast', 'Chicken breast', 165.0),
      ('egg', 'Egg', 143.0),
      ('banana', 'Banana', 89.0),
      ('wholemeal-bread', 'Wholemeal bread', 247.0),
      ('milk', 'Semi-skimmed milk', 46.0),
    ]) {
      legacy.execute(
        'INSERT INTO foods (id,name,source,verification_status,energy,protein,carbohydrate,fat,fibre,sugar,salt,is_common,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          food.$1,
          food.$2,
          'legacy-seed',
          'verified',
          food.$3,
          1.0,
          1.0,
          1.0,
          0.0,
          0.0,
          0.0,
          1,
          '2026-01-01T00:00:00Z',
          '2026-01-01T00:00:00Z',
        ],
      );
    }
    legacy
      ..execute(
        "INSERT INTO diary_entries VALUES ('legacy-entry','legacy-user','chicken-breast','Chicken breast',NULL,'lunch',100,'100 g',165,31,0,3.6,0,0,.18,'2026-01-01T12:00:00Z','2026-01-01T12:00:00Z','2026-01-01T12:00:00Z')",
      )
      ..close();

    final database = await AppDatabase.open(file: file);
    expect((await database.profile())!['anonymous_user_id'], 'legacy-user');
    expect(
      (await database.servingsForFood('egg')).map((item) => item.label),
      contains('1 large egg'),
    );
    final migratedDiary = await database.diaryFor(DateTime(2026, 1, 1));
    expect(migratedDiary.single.energy, 165);
    expect(
      (await database.customSelect('PRAGMA user_version').get())
          .single
          .data['user_version'],
      4,
    );
    await database.close();
  });
}

const _legacyProfile = '''
CREATE TABLE profile (
  anonymous_user_id TEXT PRIMARY KEY, device_created_at TEXT NOT NULL,
  onboarding_completed INTEGER NOT NULL, onboarding_step INTEGER NOT NULL,
  goal TEXT, date_of_birth TEXT, calculation_sex TEXT, height_cm REAL,
  weight_kg REAL, activity TEXT, goal_weight_kg REAL, rate_kg_week REAL,
  bmr REAL, maintenance_calories REAL, goal_adjustment REAL,
  calorie_target REAL, protein_target REAL, carbohydrate_target REAL,
  fat_target REAL, target_clamped INTEGER, clamp_reason TEXT
)''';

const _legacyFoods = '''
CREATE TABLE foods (
  id TEXT PRIMARY KEY, name TEXT NOT NULL, brand TEXT, source TEXT NOT NULL,
  verification_status TEXT NOT NULL, barcode TEXT, energy REAL NOT NULL,
  protein REAL NOT NULL, carbohydrate REAL NOT NULL, fat REAL NOT NULL,
  fibre REAL NOT NULL, sugar REAL NOT NULL, salt REAL NOT NULL,
  common_serving TEXT, common_serving_grams REAL,
  is_common INTEGER NOT NULL DEFAULT 0, created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)''';

const _legacyDiary = '''
CREATE TABLE diary_entries (
  id TEXT PRIMARY KEY, anonymous_user_id TEXT NOT NULL, food_id TEXT,
  food_name_snapshot TEXT NOT NULL, brand_snapshot TEXT, meal_type TEXT NOT NULL,
  quantity_grams REAL NOT NULL, serving_description TEXT NOT NULL,
  energy_snapshot REAL NOT NULL, protein_snapshot REAL NOT NULL,
  carbohydrate_snapshot REAL NOT NULL, fat_snapshot REAL NOT NULL,
  fibre_snapshot REAL NOT NULL, sugar_snapshot REAL NOT NULL,
  salt_snapshot REAL NOT NULL, logged_at TEXT NOT NULL,
  created_at TEXT NOT NULL, updated_at TEXT NOT NULL
)''';
