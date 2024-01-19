import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String? id;
  final String mealType;
  final String mealName;
  final String description;
  final double protein;
  final double carbohydrate;
  final double fat;
  final double totalCalories;
  final DateTime date;

  Meal({
    this.id,
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
      //id: map['id'],
      mealType: map['mealType'] ?? '',
      mealName: map['mealName'] ?? '',
      description: map['description'] ?? '',
      protein: map['protein'] ?? 0.0,
      carbohydrate: map['carbohydrate'] ?? 0.0,
      fat: map['fat'] ?? 0.0,
      totalCalories: map['totalCalories'] ?? 0.0,
      date: (map['date'] as Timestamp).toDate(),
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
      'date': date,
    };
  }
}