enum MealType { breakfast, lunch, dinner, snack }

class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.anonymousUserId,
    this.foodId,
    required this.foodName,
    this.brand,
    required this.meal,
    required this.quantityGrams,
    required this.servingDescription,
    required this.energy,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.fibre,
    required this.sugar,
    required this.salt,
    required this.loggedAt,
  });
  final String id;
  final String anonymousUserId;
  final String? foodId;
  final String foodName;
  final String? brand;
  final MealType meal;
  final double quantityGrams;
  final String servingDescription;
  final double energy;
  final double protein;
  final double carbohydrate;
  final double fat;
  final double fibre;
  final double sugar;
  final double salt;
  final DateTime loggedAt;
}
