import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/core/database/app_database.dart';
import 'package:noryva_mobile/features/onboarding/domain/body_details.dart';

import 'onboarding_body_widget_test.dart' as helpers;

Finder field(String label) => find.widgetWithText(TextField, label);

Future<void> type(WidgetTester tester, String label, String text) async {
  await tester.ensureVisible(field(label));
  await tester.showKeyboard(field(label));
  for (var end = 1; end <= text.length; end++) {
    tester.testTextInput.updateEditingValue(
      TextEditingValue(
        text: text.substring(0, end),
        selection: TextSelection.collapsed(offset: end),
      ),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(
    find.descendant(of: field(label), matching: find.text(text)),
    findsOneWidget,
  );
}

Future<void> chooseHeight(WidgetTester tester, String label) async {
  await helpers.tap(tester, find.byType(DropdownButtonFormField<HeightUnit>));
  await helpers.tap(tester, find.text(label).last);
}

Future<void> chooseWeight(WidgetTester tester, String label) async {
  await helpers.tap(tester, find.byType(DropdownButtonFormField<WeightUnit>));
  await helpers.tap(tester, find.text(label).last);
}

void main() {
  testWidgets(
    'incremental platform input remains visible across all units and rebuilds',
    (tester) async {
      final db = await AppDatabase.memory();
      addTearDown(db.close);
      await db.saveOnboarding(step: 2, sex: 'male', dateOfBirth: '1990-01-02');
      await helpers.pump(tester, db);
      expect(helpers.enabled(tester), isFalse);
      await chooseHeight(tester, 'Feet + inches');
      final controller = tester.widget<TextField>(field('Feet')).controller;
      await type(tester, 'Feet', '5');
      expect(
        tester.widget<TextField>(field('Feet')).controller,
        same(controller),
      );
      await type(tester, 'Inches', '10');
      await chooseWeight(tester, 'Stones + pounds');
      await type(tester, 'Stones', '13');
      expect(helpers.enabled(tester), isFalse);
      await type(tester, 'Pounds', '5');
      expect(helpers.enabled(tester), isTrue);
      expect(tester.widget<TextField>(field('Stones')).controller!.text, '13');

      await helpers.enter(tester, 'Inches', '12');
      expect(helpers.enabled(tester), isFalse);
      await helpers.enter(tester, 'Inches', '10');
      await helpers.enter(tester, 'Pounds', '14');
      expect(helpers.enabled(tester), isFalse);
      await helpers.enter(tester, 'Pounds', '5');
      expect(helpers.enabled(tester), isTrue);
      expect((await db.profile())!['height_cm'], closeTo(177.8, 1e-9));
      expect((await db.profile())!['weight_kg'], closeTo(84.82177319, 1e-9));

      await chooseHeight(tester, 'Centimetres');
      await type(tester, 'Height (cm)', '177.8');
      await chooseWeight(tester, 'Kilograms');
      await type(tester, 'Current weight (kg)', '84.5');
      expect(helpers.enabled(tester), isTrue);
      await helpers.enter(tester, 'Current weight (kg)', '301');
      expect(helpers.enabled(tester), isFalse);
      await helpers.enter(tester, 'Current weight (kg)', '84.5');
      await helpers.enter(tester, 'Height (cm)', '119');
      expect(helpers.enabled(tester), isFalse);
      await helpers.enter(tester, 'Height (cm)', '177.8');
      await chooseWeight(tester, 'Pounds');
      await type(tester, 'Current weight (lb)', '187');
      expect(helpers.enabled(tester), isTrue);
      await chooseWeight(tester, 'Stones + pounds');
      expect(tester.widget<TextField>(field('Stones')).controller!.text, '13');
      expect(tester.widget<TextField>(field('Pounds')).controller!.text, '5');
      await chooseHeight(tester, 'Feet + inches');
      expect(tester.widget<TextField>(field('Feet')).controller!.text, '5');
      expect(tester.widget<TextField>(field('Inches')).controller!.text, '10');
      expect(helpers.enabled(tester), isTrue);
      await chooseWeight(tester, 'Kilograms');
      expect(
        tester.widget<TextField>(field('Current weight (kg)')).controller!.text,
        '84.5',
      );
      await chooseWeight(tester, 'Pounds');
      expect(
        tester.widget<TextField>(field('Current weight (lb)')).controller!.text,
        '187',
      );
      await chooseHeight(tester, 'Centimetres');
      expect(
        tester.widget<TextField>(field('Height (cm)')).controller!.text,
        '177.8',
      );
    },
  );

  testWidgets(
    'filters unsupported characters without discarding valid digits in the same edit',
    (tester) async {
      final db = await AppDatabase.memory();
      addTearDown(db.close);
      await db.saveOnboarding(step: 2, sex: 'male', dateOfBirth: '1990-01-02');
      await helpers.pump(tester, db);
      await chooseHeight(tester, 'Feet + inches');
      await helpers.enter(tester, 'Feet', '5 ');
      expect(
        find.descendant(of: field('Feet'), matching: find.text('5')),
        findsOneWidget,
      );
      await helpers.enter(tester, 'Inches', '10 in');
      expect(tester.widget<TextField>(field('Inches')).controller!.text, '10');
      await chooseWeight(tester, 'Stones + pounds');
      await helpers.enter(tester, 'Stones', '13 st');
      await helpers.enter(tester, 'Pounds', '5 lb');
      expect(tester.widget<TextField>(field('Stones')).controller!.text, '13');
      expect(tester.widget<TextField>(field('Pounds')).controller!.text, '5');
      expect(helpers.enabled(tester), isTrue);
      await chooseHeight(tester, 'Centimetres');
      await helpers.enter(tester, 'Height (cm)', '177.8 cm');
      expect(
        tester.widget<TextField>(field('Height (cm)')).controller!.text,
        '177.8',
      );
      await chooseWeight(tester, 'Kilograms');
      await helpers.enter(tester, 'Current weight (kg)', '84.5 kg');
      expect(
        tester.widget<TextField>(field('Current weight (kg)')).controller!.text,
        '84.5',
      );
      expect(helpers.enabled(tester), isTrue);
      await helpers.enter(tester, 'Current weight (kg)', '84..5');
      expect(helpers.enabled(tester), isFalse);
      await chooseWeight(tester, 'Pounds');
      await helpers.enter(tester, 'Current weight (lb)', '187 lb');
      expect(
        tester.widget<TextField>(field('Current weight (lb)')).controller!.text,
        '187',
      );
      expect(helpers.enabled(tester), isTrue);
      await helpers.enter(tester, 'Current weight (lb)', 'letters');
      expect(
        tester.widget<TextField>(field('Current weight (lb)')).controller!.text,
        isEmpty,
      );
      expect(helpers.enabled(tester), isFalse);
    },
  );
}
