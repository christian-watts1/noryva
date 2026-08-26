class Food {
  const Food({
    required this.id,
    required this.name,
    this.brand,
    required this.source,
    required this.verificationStatus,
    required this.energy,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.fibre,
    required this.sugar,
    required this.salt,
    required this.basisUnit,
  });
  final String id;
  final String name;
  final String? brand;
  final String source;
  final String verificationStatus;
  final double energy;
  final double protein;
  final double carbohydrate;
  final double fat;
  final double fibre;
  final double sugar;
  final double salt;
  final String basisUnit;

  double scale(double canonicalQuantity, double per100) =>
      per100 * canonicalQuantity / 100;
}

class FoodServing {
  const FoodServing({
    required this.id,
    required this.foodId,
    required this.label,
    required this.quantity,
    required this.unit,
    required this.canonicalQuantity,
    required this.isDefault,
  });

  final String id;
  final String foodId;
  final String label;
  final double quantity;
  final String unit;
  final double canonicalQuantity;
  final bool isDefault;

  double canonicalFor(double servingCount) => canonicalQuantity * servingCount;
}

class FoodSearchSections {
  const FoodSearchSections({required this.recent, required this.common});

  final List<Food> recent;
  final List<Food> common;
}
