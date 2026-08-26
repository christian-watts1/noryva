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
    );
    expect(food.scale(150, food.energy), 247.5);
  });
}
