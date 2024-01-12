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

  Future<List<Meal>> getMealsForDate(DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);

      Timestamp startTimestamp = Timestamp.fromDate(startDate);
      Timestamp endTimestamp = Timestamp.fromDate(endDate);

      QuerySnapshot<Map<String, dynamic>> snapshot = await mealsCollection
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThan: endTimestamp)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return Meal(
          mealType: doc['mealType'],
          mealName: doc['mealName'],
          description: doc['description'],
          protein: doc['protein'],
          carbohydrate: doc['carbohydrate'],
          fat: doc['fat'],
          totalCalories: doc['totalCalories'],
          date: (doc['date'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Error getting meals for date: $e');
      rethrow;
    }
  }

  Future<void> updateMeal(Meal meal) async {
    try {
      await mealsCollection.doc(meal.id).update(meal.toMap());
    } catch (e) {
      print('Error updating food item: $e');
      rethrow;
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      print('Deleting meal with ID: $id');
      await mealsCollection.doc(id).delete();
      print('Deletion successful.');
    } catch (e) {
      print('Error deleting meal: $e');
      rethrow;
    }
  }

}
