import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../goals/domain/energy_calculator.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});
  @override
  ConsumerState<OnboardingFlow> createState() => _State();
}

class _State extends ConsumerState<OnboardingFlow> {
  int step = 0;
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
      if (p['calorie_target'] != null)
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
    });
  }

  @override
  void dispose() {
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
      height = double.tryParse(heightController.text);
      weight = double.tryParse(weightController.text);
      if (dob == null ||
          sex == null ||
          height == null ||
          weight == null ||
          height! < 120 ||
          height! > 230 ||
          weight! < 35 ||
          weight! > 350) {
        _error('Enter a date of birth and sensible metric measurements.');
        return;
      }
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
          (goalWeight == null || goalWeight! < 35 || goalWeight! > 350)) {
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

  void _error(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
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
      step == 0 ||
      (step == 1 && goal != null) ||
      step == 2 ||
      (step == 3 && activity != null) ||
      step >= 4;
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
          value: sex,
          decoration: const InputDecoration(
            labelText: 'Sex used for energy calculation',
          ),
          items: CalculationSex.values
              .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
              .toList(),
          onChanged: (v) => setState(() => sex = v),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1925),
              lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              initialDate: DateTime(1990),
            );
            if (picked != null) setState(() => dob = picked);
          },
          child: Text(
            dob == null
                ? 'Select date of birth'
                : '${dob!.day}/${dob!.month}/${dob!.year}',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Height (cm)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Current weight (kg)'),
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
        'moderate': 'Moderate activity — Regular movement or exercise several times a week.',
        'high': 'High activity — A physically active lifestyle or frequent training.',
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
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Goal weight (kg)'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<double>(
            value: rate,
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
      ...values.map(
        (v) => Card(
          child: RadioListTile<T>(
            value: v,
            groupValue: selected,
            onChanged: (x) => changed(x as T),
            title: Text(label(v)),
          ),
        ),
      ),
    ],
  );
}
