import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../goals/domain/energy_calculator.dart';
import '../domain/body_details.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});
  @override
  ConsumerState<OnboardingFlow> createState() => _State();
}

class _State extends ConsumerState<OnboardingFlow> {
  int step = 0;
  bool loaded = false;
  HeightUnit heightUnit = HeightUnit.centimetres;
  WeightUnit weightUnit = WeightUnit.kilograms;
  final inchesController = TextEditingController();
  final poundsController = TextEditingController();
  final drafts = <String, String>{};
  Future<void> pendingSave = Future.value();

  GoalKind? goal;
  CalculationSex? sex;
  ActivityLevel? activity;
  DateTime? dob;
  double? height;
  double? weight;
  double? goalWeight;
  double rate = .5;
  EnergyPlan? plan;
  final heightController = TextEditingController(),
      weightController = TextEditingController(),
      goalWeightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final p = await ref.read(databaseProvider).profile();
    if (!mounted || p == null) return;
    setState(() {
      step = p['onboarding_step'] as int;
      goal = p['goal'] == null
          ? null
          : GoalKind.values.byName(p['goal']! as String);
      sex = p['calculation_sex'] == null
          ? null
          : CalculationSex.values.byName(p['calculation_sex']! as String);
      activity = p['activity'] == null
          ? null
          : ActivityLevel.values.byName(p['activity']! as String);
      dob = p['date_of_birth'] == null
          ? null
          : DateTime.parse(p['date_of_birth']! as String);
      height = p['height_cm'] as double?;
      weight = p['weight_kg'] as double?;
      goalWeight = p['goal_weight_kg'] as double?;
      rate = p['rate_kg_week'] as double? ?? .5;
      heightController.text = height?.toString() ?? '';
      weightController.text = weight?.toString() ?? '';
      goalWeightController.text = goalWeight?.toString() ?? '';
      if (p['body_draft'] != null) {
        final saved =
            jsonDecode(p['body_draft']! as String) as Map<String, dynamic>;
        heightUnit = HeightUnit.values.byName(saved['heightUnit'] as String);
        weightUnit = WeightUnit.values.byName(saved['weightUnit'] as String);
        drafts.addAll(Map<String, String>.from(saved['values'] as Map));
        _loadFields();
      }
      loaded = true;
      if (p['calorie_target'] != null) {
        plan = EnergyPlan(
          bmr: p['bmr']! as double,
          maintenanceCalories: p['maintenance_calories']! as double,
          goalAdjustment: p['goal_adjustment']! as double,
          dailyCalories: p['calorie_target']! as double,
          proteinG: p['protein_target']! as double,
          carbohydrateG: p['carbohydrate_target']! as double,
          fatG: p['fat_target']! as double,
          wasClamped: p['target_clamped'] == 1,
          clampReason: p['clamp_reason'] as String?,
        );
      }
    });
  }

  @override
  void dispose() {
    inchesController.dispose();
    poundsController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    super.dispose();
  }

  Future<void> next() async {
    final db = ref.read(databaseProvider);
    if (step == 0) {
      setState(() => step = 1);
      await db.saveOnboarding(step: 1);
    } else if (step == 1 && goal != null) {
      setState(() => step = 2);
      await db.saveOnboarding(step: 2, goal: goal!.name);
    } else if (step == 2) {
      if (!_validBody) return;
      await pendingSave;
      height = _height;
      weight = _weight;
      setState(() => step = 3);
      await db.saveOnboarding(
        step: 3,
        dateOfBirth: dob!.toIso8601String(),
        sex: sex!.name,
        heightCm: height,
        weightKg: weight,
      );
    } else if (step == 3 && activity != null) {
      setState(() => step = 4);
      await db.saveOnboarding(step: 4, activity: activity!.name);
    } else if (step == 4) {
      goalWeight = double.tryParse(goalWeightController.text);
      final needsWeight =
          goal == GoalKind.loseWeight || goal == GoalKind.gainWeight;
      if (needsWeight &&
          (goalWeight == null || goalWeight! < 35 || goalWeight! > 300)) {
        _error('Enter a sensible goal weight.');
        return;
      }
      final age =
          DateTime.now().year -
          dob!.year -
          ((DateTime.now().month < dob!.month ||
                  (DateTime.now().month == dob!.month &&
                      DateTime.now().day < dob!.day))
              ? 1
              : 0);
      try {
        plan = EnergyCalculator.calculate(
          EnergyInput(
            sex: sex!,
            age: age,
            heightCm: height!,
            weightKg: weight!,
            activity: activity!,
            goal: goal!,
            rateKgPerWeek: needsWeight ? rate : null,
          ),
        );
      } on ArgumentError catch (e) {
        _error(e.message.toString());
        return;
      }
      await db.saveOnboarding(
        step: 4,
        goalWeightKg: goalWeight,
        rateKgWeek: needsWeight ? rate : null,
      );
      await db.savePlan(
        bmr: plan!.bmr,
        maintenance: plan!.maintenanceCalories,
        adjustment: plan!.goalAdjustment,
        calories: plan!.dailyCalories,
        protein: plan!.proteinG,
        carbs: plan!.carbohydrateG,
        fat: plan!.fatG,
        clamped: plan!.wasClamped,
        reason: plan!.clampReason,
      );
      setState(() => step = 5);
    } else if (step == 5) {
      await db.completeOnboarding();
      if (mounted) context.go('/home');
    }
  }

  double? get _height => BodyDetails.height(
    heightUnit,
    heightController.text,
    inchesController.text,
  );
  double? get _weight => BodyDetails.weight(
    weightUnit,
    weightController.text,
    poundsController.text,
  );
  bool get _validBody =>
      sex != null &&
      BodyDetails.validDob(dob, DateTime.now()) &&
      BodyDetails.validHeight(_height) &&
      BodyDetails.validWeight(_weight);

  void _rememberFields() {
    drafts['height.${heightUnit.name}'] = heightController.text;
    drafts['inches'] = inchesController.text;
    drafts['weight.${weightUnit.name}'] = weightController.text;
    drafts['pounds'] = poundsController.text;
  }

  void _loadFields() {
    heightController.text = drafts['height.${heightUnit.name}'] ?? '';
    inchesController.text = drafts['inches'] ?? '';
    weightController.text = drafts['weight.${weightUnit.name}'] ?? '';
    poundsController.text = drafts['pounds'] ?? '';
  }

  void _saveBody() {
    _rememberFields();
    final draft = jsonEncode({
      'heightUnit': heightUnit.name,
      'weightUnit': weightUnit.name,
      'values': drafts,
    });
    final h = BodyDetails.validHeight(_height) ? _height : null;
    final w = BodyDetails.validWeight(_weight) ? _weight : null;
    final date = dob?.toIso8601String();
    final calculationSex = sex?.name;
    final db = ref.read(databaseProvider);
    pendingSave = pendingSave.then(
      (_) => db.saveBodyDraft(
        draft,
        heightCm: h,
        weightKg: w,
        dateOfBirth: date,
        sex: calculationSex,
      ),
    );
  }

  Widget _numeric(
    TextEditingController controller,
    String label, {
    bool integer = false,
  }) => TextField(
    controller: controller,
    keyboardType: integer
        ? TextInputType.number
        : const TextInputType.numberWithOptions(decimal: true),
    // Filter characters, not whole editing values. Range and decimal syntax
    // validation happens separately so partially entered values remain editable.
    inputFormatters: [
      integer
          ? FilteringTextInputFormatter.digitsOnly
          : FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ],
    decoration: InputDecoration(labelText: label),
    onChanged: (_) {
      setState(() {});
      _saveBody();
    },
  );

  void _error(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: step == 0
        ? null
        : AppBar(title: Text('Step ${step.clamp(1, 5)} of 5')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: step == 0 ? 0 : step / 5),
            const SizedBox(height: 24),
            Expanded(child: SingleChildScrollView(child: _content())),
            FilledButton(
              onPressed: _canContinue ? next : null,
              child: Text(
                step == 0
                    ? 'Get started'
                    : step == 5
                    ? 'Start tracking'
                    : 'Continue',
              ),
            ),
          ],
        ),
      ),
    ),
  );
  bool get _canContinue =>
      loaded &&
      (step == 0 ||
          (step == 1 && goal != null) ||
          (step == 2 && _validBody) ||
          (step == 3 && activity != null) ||
          (step == 4 &&
              (!(goal == GoalKind.loseWeight || goal == GoalKind.gainWeight) ||
                  BodyDetails.validWeight(
                    BodyDetails.number(goalWeightController.text),
                  ))) ||
          step == 5);
  Widget _content() => switch (step) {
    0 => const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Noryva',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 80),
        Text(
          'Track less. Know more.',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text(
          'Nutrition and fitness without the friction.',
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
    1 => _choices<GoalKind>(
      'What do you want to achieve?',
      GoalKind.values,
      goal,
      (v) => setState(() => goal = v),
      (v) => {
        'loseWeight': 'Lose weight',
        'maintainWeight': 'Maintain weight',
        'gainWeight': 'Gain weight',
        'buildMuscle': 'Build muscle',
        'improveFitness': 'Improve fitness',
        'trackNutrition': 'Track nutrition',
      }[v.name]!,
    ),
    2 => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us about your body',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const Text(
          'These details help us estimate your starting energy needs. You can adjust your targets later.',
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<CalculationSex>(
          initialValue: sex,
          decoration: const InputDecoration(
            labelText: 'Sex used for energy calculation',
          ),
          items: CalculationSex.values
              .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
              .toList(),
          onChanged: (v) {
            setState(() => sex = v);
            _saveBody();
          },
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(
                DateTime.now().year - 101,
                DateTime.now().month,
                DateTime.now().day + 1,
              ),
              lastDate: DateTime(
                DateTime.now().year - 18,
                DateTime.now().month,
                DateTime.now().day,
              ),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              helpText: 'Select date of birth (DD/MM/YYYY)',
              initialDate: BodyDetails.validDob(dob, DateTime.now())
                  ? dob
                  : DateTime(1990),
            );
            if (picked != null && mounted) {
              setState(() => dob = picked);
              _saveBody();
            }
          },
          child: Text(
            dob == null ? 'Select date of birth' : BodyDetails.formatDob(dob!),
          ),
        ),
        Text(
          dob != null && !BodyDetails.validDob(dob, DateTime.now())
              ? 'Select a date of birth for an age of 18–100.'
              : 'Date of birth: DD/MM/YYYY · Ages 18–100',
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<HeightUnit>(
          initialValue: heightUnit,
          decoration: const InputDecoration(labelText: 'Height unit'),
          items: HeightUnit.values
              .map(
                (v) => DropdownMenuItem(
                  value: v,
                  child: Text(
                    v == HeightUnit.centimetres
                        ? 'Centimetres'
                        : 'Feet + inches',
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            _rememberFields();
            setState(() {
              heightUnit = v!;
              _loadFields();
            });
            _saveBody();
          },
        ),
        _numeric(
          heightController,
          heightUnit == HeightUnit.centimetres ? 'Height (cm)' : 'Feet',
          integer: heightUnit == HeightUnit.feetInches,
        ),
        if (heightUnit == HeightUnit.feetInches)
          _numeric(inchesController, 'Inches', integer: true),
        if (!BodyDetails.validHeight(_height))
          Text(
            heightUnit == HeightUnit.centimetres
                ? 'Enter a height from 120–230 cm.'
                : 'Enter 120–230 cm equivalent; inches must be 0–11.',
          ),
        const SizedBox(height: 12),
        DropdownButtonFormField<WeightUnit>(
          initialValue: weightUnit,
          decoration: const InputDecoration(labelText: 'Weight unit'),
          items: WeightUnit.values
              .map(
                (v) => DropdownMenuItem(
                  value: v,
                  child: Text(switch (v) {
                    WeightUnit.kilograms => 'Kilograms',
                    WeightUnit.stonesPounds => 'Stones + pounds',
                    WeightUnit.pounds => 'Pounds',
                  }),
                ),
              )
              .toList(),
          onChanged: (v) {
            _rememberFields();
            setState(() {
              weightUnit = v!;
              _loadFields();
            });
            _saveBody();
          },
        ),
        _numeric(weightController, switch (weightUnit) {
          WeightUnit.kilograms => 'Current weight (kg)',
          WeightUnit.stonesPounds => 'Stones',
          WeightUnit.pounds => 'Current weight (lb)',
        }, integer: weightUnit == WeightUnit.stonesPounds),
        if (weightUnit == WeightUnit.stonesPounds)
          _numeric(poundsController, 'Pounds', integer: true),
        if (!BodyDetails.validWeight(_weight))
          Text(
            weightUnit == WeightUnit.stonesPounds
                ? 'Enter 35–300 kg equivalent; pounds must be 0–13.'
                : weightUnit == WeightUnit.pounds
                ? 'Enter 35–300 kg equivalent in pounds.'
                : 'Enter a weight from 35–300 kg.',
          ),
      ],
    ),
    3 => _choices<ActivityLevel>(
      'How active are you?',
      ActivityLevel.values,
      activity,
      (v) => setState(() => activity = v),
      (v) => {
        'low': 'Low activity — Mostly seated with limited regular exercise.',
        'light':
            'Light activity — Some walking or light exercise during the week.',
        'moderate':
            'Moderate activity — Regular movement or exercise several times a week.',
        'high':
            'High activity — A physically active lifestyle or frequent training.',
      }[v.name]!,
    ),
    4 => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configure your goal',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        if (goal == GoalKind.loseWeight || goal == GoalKind.gainWeight) ...[
          const SizedBox(height: 16),
          TextField(
            controller: goalWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Goal weight (kg)',
              errorText:
                  BodyDetails.validWeight(
                    BodyDetails.number(goalWeightController.text),
                  )
                  ? null
                  : 'Enter a weight from 35–300 kg.',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<double>(
            initialValue: rate,
            decoration: const InputDecoration(labelText: 'Desired rate'),
            items: const [.25, .5, .75]
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text('${v.toStringAsFixed(2)} kg/week'),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => rate = v!),
          ),
        ] else
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('No goal weight is needed for this goal.'),
          ),
      ],
    ),
    _ => _plan(),
  };
  Widget _plan() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'YOUR NORYVA PLAN',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        '${plan!.dailyCalories.round()} kcal/day',
        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
      ),
      _target('Protein', plan!.proteinG),
      _target('Carbohydrates', plan!.carbohydrateG),
      _target('Fat', plan!.fatG),
      ExpansionTile(
        title: const Text('How was this calculated?'),
        children: [
          ListTile(
            title: const Text('Estimated resting needs'),
            trailing: Text('${plan!.bmr.round()} kcal'),
          ),
          ListTile(
            title: const Text('Activity adjustment'),
            subtitle: const Text(
              'Your selected activity multiplier is applied to resting needs.',
            ),
          ),
          ListTile(
            title: const Text('Estimated maintenance'),
            trailing: Text('${plan!.maintenanceCalories.round()} kcal'),
          ),
          ListTile(
            title: const Text('Goal adjustment'),
            trailing: Text('${plan!.goalAdjustment.round()} kcal'),
          ),
          ListTile(
            title: const Text('Daily target'),
            trailing: Text('${plan!.dailyCalories.round()} kcal'),
          ),
          if (plan!.wasClamped)
            ListTile(
              title: const Text('Safety floor applied'),
              subtitle: Text(plan!.clampReason!),
            ),
        ],
      ),
    ],
  );
  Widget _target(String name, double value) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(name),
    trailing: Text('${value.round()}g'),
  );
  Widget _choices<T>(
    String title,
    List<T> values,
    T? selected,
    ValueChanged<T> changed,
    String Function(T) label,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      ...values.map((v) {
        final isSelected = v == selected;
        return Semantics(
          selected: isSelected,
          button: true,
          label: label(v),
          child: Card(
            child: ListTile(
              minTileHeight: 56,
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              title: Text(label(v)),
              onTap: () => changed(v),
            ),
          ),
        );
      }),
    ],
  );
}
