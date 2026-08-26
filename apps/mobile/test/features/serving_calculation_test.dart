import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/features/foods/domain/food.dart';

void main() {
  test('serving precision is retained before display rounding', () {
    const food = Food(
      id: 'x',
      name: 'Chicken',
      source: 'demo',
      verificationStatus: 'verified',
      energy: 165,
      protein: 31,
      carbohydrate: 0,
      fat: 3.6,
      fibre: 0,
      sugar: 0,
      salt: .18,
      basisUnit: 'g',
    );
    expect(food.scale(150, food.energy), 247.5);
  });

  test('unit serving converts to canonical nutrition quantity', () {
    const largeEgg = FoodServing(
      id: 'egg-large',
      foodId: 'egg',
      label: '1 large egg',
      quantity: 1,
      unit: 'egg',
      canonicalQuantity: 60,
      isDefault: true,
    );
    expect(largeEgg.canonicalFor(1), 60);
    expect(largeEgg.canonicalFor(2), 120);
    expect(143 * largeEgg.canonicalFor(1) / 100, 85.8);
  });

  test('volume serving converts to canonical millilitres', () {
    const glass = FoodServing(
      id: 'milk-glass',
      foodId: 'milk',
      label: '250 ml glass',
      quantity: 1,
      unit: 'glass',
      canonicalQuantity: 250,
      isDefault: true,
    );
    expect(glass.canonicalFor(1), 250);
    expect(46 * glass.canonicalFor(1) / 100, 115);
  });
}
