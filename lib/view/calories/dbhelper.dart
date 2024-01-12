// dbhelper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';

class DatabaseHelper {
  final CollectionReference mealsCollection =
  FirebaseFirestore.instance.collection('meals');

  Future<void> insertMeal(Meal meal) async {
    try {
      await mealsCollection.add(meal.toMap());
    } catch (e) {
      print('Error inserting meal record: $e');
      rethrow;
    }
  }

  Future<List<Meal>> getMeals() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await mealsCollection.get() as QuerySnapshot<Map<String, dynamic>>;
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return Meal(
          mealType: doc['mealType'],
          mealName: doc['mealName'],
          description: doc['description'],
          protein: doc['protein'],
          carbohydrate: doc['carbohydrate'],
          fat: doc['fat'],
          totalCalories: doc['totalCalories'],
          date: DateTime.parse(doc['date']),
        );
      }).toList();
    } catch (e) {
      print('Error getting meal record: $e');
      rethrow;
    }
  }
}
