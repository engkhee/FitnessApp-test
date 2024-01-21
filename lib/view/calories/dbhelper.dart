//// dbhelper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'meal.dart';

class DatabaseHelper {
  final CollectionReference mealsCollection =
  FirebaseFirestore.instance.collection('meals');

  Future<void> insertMeal(Meal meal) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        meal.id = mealsCollection.doc().id;

        DocumentReference<Object?> docRef =
        await mealsCollection.doc(user.uid).collection('user_meals').add(meal.toMap());
        print('Meal added with ID: ${docRef.id}');
      } else {
        // Handle the case where the user is not authenticated
        print('Error: User not authenticated');
      }
    } catch (e) {
      print('Error inserting meal record: $e');
      rethrow;
    }
  }

  Future<List<Meal>> getMeals() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> snapshot =
        await mealsCollection.doc(user.uid).collection('user_meals').get();

        return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Meal(
            id: doc.id,
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
      } else {
        // Handle the case where the user is not authenticated
        print('Error: User not authenticated');
        return []; // Return an empty list or handle it according to your logic
      }
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
          id: doc.id,
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

  Future<void> updateMeal(String mealId, Meal meal) async {
    try {
      print('Updating meal...');
      print('Meal data: ${meal.toMap()}');

      if (mealId.isNotEmpty) {
        await mealsCollection.doc(mealId).update(meal.toMap());
        print('Meal updated successfully!');
      } else {
        print('Error updating food item: Meal ID is empty or null.');
      }
    } catch (e) {
      print('Error updating food item: $e');
      rethrow;
    }
  }

  Future<void> deleteMeal(String? id) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (id != null && id.isNotEmpty) {
          print('Deleting meal with ID: $id');
          await mealsCollection.doc(user.uid).collection('user_meals').doc(id).delete();
          print('Deletion successful.');
        } else {
          print('Error deleting meal: Meal ID is null or empty.');
        }
      } else {
        // Handle the case where the user is not authenticated
        print('Error: User not authenticated');
      }
    } catch (e) {
      print('Error deleting meal: $e');
      rethrow;
    }
  }
}

