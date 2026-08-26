import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../diary/domain/diary_entry.dart';
import '../domain/food.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchState();
}

class _FoodSearchState extends ConsumerState<FoodSearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Search food')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SearchBar(
            hintText: 'Search local foods',
            leading: const Icon(Icons.search),
            onChanged: (value) => setState(() => query = value),
          ),
        ),
        Expanded(child: query.trim().isEmpty ? _sections() : _results()),
      ],
    ),
  );

  Widget _sections() => FutureBuilder<FoodSearchSections>(
    future: ref.read(databaseProvider).foodSearchSections(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final sections = snapshot.data!;
      return ListView(
        children: [
          if (sections.recent.isNotEmpty) ...[
            const _SectionHeader('RECENT'),
            ...sections.recent.map(_foodTile),
          ],
          const _SectionHeader('COMMON'),
          ...sections.common
              .where(
                (food) =>
                    !sections.recent.any((recent) => recent.id == food.id),
              )
              .map(_foodTile),
        ],
      );
    },
  );

  Widget _results() => FutureBuilder<List<Food>>(
    future: ref.read(databaseProvider).searchFoods(query),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(children: snapshot.data!.map(_foodTile).toList());
    },
  );

  Widget _foodTile(Food food) => ListTile(
    title: Text(food.name),
    subtitle: Text(
      '${food.brand ?? 'Noryva demo data'} • ${food.verificationStatus}',
    ),
    trailing: Text(
      '${food.energy.round()} kcal\n${food.protein.toStringAsFixed(1)}g protein',
      textAlign: TextAlign.end,
    ),
    onTap: () async {
      final logged = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => FoodDetailScreen(food: food)),
      );
      if (!mounted) {
        return;
      }
      if (logged == true) {
        Navigator.of(context).pop(true);
      }
    },
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    ),
  );
}

class FoodDetailScreen extends ConsumerStatefulWidget {
  const FoodDetailScreen({required this.food, super.key});
  final Food food;

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailState();
}

class _FoodDetailState extends ConsumerState<FoodDetailScreen> {
  final quantity = TextEditingController(text: '1');
  List<FoodServing>? servings;
  String selectedServingId = 'custom';
  MealType meal = _defaultMeal();

  @override
  void initState() {
    super.initState();
    _loadServings();
  }

  Future<void> _loadServings() async {
    final loaded = await ref
        .read(databaseProvider)
        .servingsForFood(widget.food.id);
    if (!mounted) {
      return;
    }
    final selected = loaded.where((serving) => serving.isDefault).firstOrNull;
    setState(() {
      servings = loaded;
      selectedServingId = selected?.id ?? 'custom';
      quantity.text = selected == null ? '100' : '1';
    });
  }

  static MealType _defaultMeal() {
    final hour = DateTime.now().hour;
    return hour < 11
        ? MealType.breakfast
        : hour < 15
        ? MealType.lunch
        : hour < 21
        ? MealType.dinner
        : MealType.snack;
  }

  FoodServing? get _selectedServing =>
      servings?.where((serving) => serving.id == selectedServingId).firstOrNull;

  double get _canonicalQuantity {
    final entered = double.tryParse(quantity.text) ?? 0;
    return _selectedServing?.canonicalFor(entered) ?? entered;
  }

  String get _servingDescription {
    final entered = double.tryParse(quantity.text) ?? 0;
    final serving = _selectedServing;
    if (serving == null) {
      return '${entered.toStringAsFixed(0)} ${widget.food.basisUnit}';
    }
    return entered == 1
        ? serving.label
        : '${entered.toStringAsFixed(1)} × ${serving.label}';
  }

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final canonical = _canonicalQuantity;
    return Scaffold(
      appBar: AppBar(title: Text(food.name)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            food.brand ?? 'Noryva development seed',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text('Verification: ${food.verificationStatus}'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            key: ValueKey(servings?.length ?? 0),
            initialValue: selectedServingId,
            decoration: const InputDecoration(labelText: 'Serving'),
            items: [
              ...?servings?.map(
                (serving) => DropdownMenuItem(
                  value: serving.id,
                  child: Text(serving.label),
                ),
              ),
              DropdownMenuItem(
                value: 'custom',
                child: Text('Custom ${food.basisUnit}'),
              ),
            ],
            onChanged: (value) => setState(() {
              selectedServingId = value!;
              quantity.text = value == 'custom' ? '100' : '1';
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: quantity,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: _selectedServing == null
                  ? 'Quantity (${food.basisUnit})'
                  : 'Number of servings',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<MealType>(
            initialValue: meal,
            decoration: const InputDecoration(labelText: 'Meal'),
            items: MealType.values
                .map(
                  (value) =>
                      DropdownMenuItem(value: value, child: Text(value.name)),
                )
                .toList(),
            onChanged: (value) => setState(() => meal = value!),
          ),
          const SizedBox(height: 20),
          _nutrientRow('Calories', food.scale(canonical, food.energy), 'kcal'),
          _nutrientRow('Protein', food.scale(canonical, food.protein), 'g'),
          _nutrientRow(
            'Carbohydrate',
            food.scale(canonical, food.carbohydrate),
            'g',
          ),
          _nutrientRow('Fat', food.scale(canonical, food.fat), 'g'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: canonical > 0 && canonical <= 5000 ? _logFood : null,
            child: const Text('Log food'),
          ),
        ],
      ),
    );
  }

  Future<void> _logFood() async {
    try {
      await ref
          .read(databaseProvider)
          .logFood(
            food: widget.food,
            canonicalQuantity: _canonicalQuantity,
            servingDescription: _servingDescription,
            meal: meal,
            loggedAt: DateTime.now(),
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Food logged locally.')));
      Navigator.of(context).pop(true);
    } catch (error, stackTrace) {
      debugPrint('Local diary write failed: $error\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("We couldn't save this entry.")),
        );
      }
    }
  }

  Widget _nutrientRow(String name, double value, String unit) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(name),
    trailing: Text('${value.toStringAsFixed(1)} $unit'),
  );
}
