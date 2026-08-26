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
    this.commonServing,
    this.commonServingGrams,
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
  final String? commonServing;
  final double? commonServingGrams;

  double scale(double grams, double per100g) => per100g * grams / 100;
}
