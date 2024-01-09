import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';

class DatabaseHelper {
  final CollectionReference mealsCollection = FirebaseFirestore.instance.collection('meals');

  Future<void> insertFoodItem(Meal meal) async {
    try {
      await mealsCollection.add(meal.toMap());
    } catch (e) {
      print('Error inserting meal record: $e');
      // Handle the error as needed
    }
  }

  Future<void> addMeal(Meal meal) async {
    try {
      // Get a reference to the 'meals' collection
      CollectionReference mealsCollection = FirebaseFirestore.instance.collection('meals');

      // Check if the 'meals' collection exists
      bool collectionExists = await mealsCollection.get().then((querySnapshot) => querySnapshot.docs.isNotEmpty);

      if (!collectionExists) {
        // If the 'meals' collection doesn't exist, create it
        await mealsCollection.add({});
      }

      // Add the meal document
      await mealsCollection.add({
        ...meal.toMap(),
        'date': Timestamp.fromDate(meal.date), // Convert DateTime to Firestore Timestamp
      });

      print('Meal added successfully!');
    } catch (e) {
      print('Error adding meal: $e');
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
