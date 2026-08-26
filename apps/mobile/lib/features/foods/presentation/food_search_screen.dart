import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../diary/domain/diary_entry.dart';
import '../domain/food.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});
  @override
  ConsumerState<FoodSearchScreen> createState() => _State();
}

class _State extends ConsumerState<FoodSearchScreen> {
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
            onChanged: (v) => setState(() => query = v),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Food>>(
            future: ref.read(databaseProvider).searchFoods(query),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, i) {
                  final food = snapshot.data![i];
                  return ListTile(
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
                        MaterialPageRoute(
                          builder: (_) => FoodDetailScreen(food: food),
                        ),
                      );
                      if (logged == true && context.mounted)
                        Navigator.of(context).pop();
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
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
  final quantity = TextEditingController(text: '100');
  MealType meal = _defaultMeal();
  static MealType _defaultMeal() {
    final h = DateTime.now().hour;
    return h < 11
        ? MealType.breakfast
        : h < 15
        ? MealType.lunch
        : h < 21
        ? MealType.dinner
        : MealType.snack;
  }

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grams = double.tryParse(quantity.text) ?? 0, f = widget.food;
    return Scaffold(
      appBar: AppBar(title: Text(f.name)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            f.brand ?? 'Noryva development seed',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text('Verification: ${f.verificationStatus}'),
          const SizedBox(height: 20),
          TextField(
            controller: quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity (grams)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<MealType>(
            value: meal,
            decoration: const InputDecoration(labelText: 'Meal'),
            items: MealType.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                .toList(),
            onChanged: (v) => setState(() => meal = v!),
          ),
          const SizedBox(height: 20),
          _row('Calories', f.scale(grams, f.energy), 'kcal'),
          _row('Protein', f.scale(grams, f.protein), 'g'),
          _row('Carbohydrate', f.scale(grams, f.carbohydrate), 'g'),
          _row('Fat', f.scale(grams, f.fat), 'g'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: grams > 0 && grams <= 5000
                ? () async {
                    try {
                      await ref
                          .read(databaseProvider)
                          .logFood(
                            food: f,
                            grams: grams,
                            meal: meal,
                            loggedAt: DateTime.now(),
                          );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Food logged locally.')),
                      );
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      if (context.mounted)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("We couldn't save this entry."),
                          ),
                        );
                    }
                  }
                : null,
            child: const Text('Log food'),
          ),
        ],
      ),
    );
  }

  Widget _row(String name, double value, String unit) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(name),
    trailing: Text('${value.toStringAsFixed(1)} $unit'),
  );
}
