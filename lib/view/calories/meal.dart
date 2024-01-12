class Meal {
  final String mealType;
  final String mealName;
  final String description;
  final double protein;
  final double carbohydrate;
  final double fat;
  final double totalCalories;
  final DateTime date;

  Meal({
    required this.mealType,
    required this.mealName,
    required this.description,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.totalCalories,
    required this.date,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      mealType: map['mealType'] ?? '',
      mealName: map['mealName'] ?? '',
      description: map['description']?? '',
      protein: map['protein'] ?? 0.0,
      carbohydrate: map['carbohydrate'] ?? 0.0,
      fat: map['fat'] ?? 0.0,
      totalCalories: map['totalCalories'] ?? 0.0,
      date: map['date'].toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealType': mealType,
      'mealName': mealName,
      'description': description,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
      'totalCalories': totalCalories,
      'date': date, // Save DateTime directly
    };
  }
}