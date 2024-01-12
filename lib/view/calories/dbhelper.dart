//dbhelper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';

class DatabaseHelper {
  final CollectionReference mealsCollection =
  FirebaseFirestore.instance.collection('meals');

  Future<List<Meal>> getMealsForDate(DateTime? date) async {
    try {
      if (date != null) {
        DateTime startDate = DateTime(date.year, date.month, date.day);
        DateTime endDate = DateTime(date.year, date.month, date.day + 1);

        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('meals')
            .where('date',
            isGreaterThanOrEqualTo: startDate, isLessThan: endDate)
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
            date: DateTime.parse(doc['date']),
          );
        }).toList();
      } else {
        // Return an empty list if date is null
        return [];
      }
    } catch (e) {
      print('Error getting meals for date: $e');
      return []; // Return an empty list in case of an error
    }
  }

// Rest of your DatabaseHelper class...
}
