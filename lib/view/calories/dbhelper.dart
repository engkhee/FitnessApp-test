import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'meal.dart';

class DatabaseHelper {
  final CollectionReference mealsCollection =
  FirebaseFirestore.instance.collection('meals');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> insertMeal(Meal meal) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        meal.id = mealsCollection.doc().id;

        DocumentReference<Object?> docRef = await mealsCollection.doc(user.uid).collection('user_meals').add(meal.toMap());
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

  Future<List<Meal>> getMeals(DateTime startDate, DateTime endDate) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        Timestamp startTimestamp = Timestamp.fromDate(startDate);
        Timestamp endTimestamp = Timestamp.fromDate(endDate);

        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('meals')
            .doc(user.uid)
            .collection('user_meals')
            .where('date', isGreaterThanOrEqualTo: startTimestamp)
            .where('date', isLessThan: endTimestamp)
            .get();

        List<Meal> meals = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data()!;
          return Meal(
            id: doc.id,
            mealType: data['mealType'],
            mealName: data['mealName'],
            description: data['description'],
            protein: data['protein'],
            carbohydrate: data['carbohydrate'],
            fat: data['fat'],
            totalCalories: data['totalCalories'],
            date: (data['date'] as Timestamp).toDate(),
          );
        }).toList();

        return meals;
      } else {
        print('Error: User not authenticated');
        return [];
      }
    } catch (e) {
      print('Error getting meals: $e');
      throw e;
    }
  }

  Future<List<Meal>> getMealsForDate(DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);

      Timestamp startTimestamp = Timestamp.fromDate(startDate);
      Timestamp endTimestamp = Timestamp.fromDate(endDate);

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('meals')
          .doc(FirebaseAuth.instance.currentUser!.uid)  // Using the UID of the currently authenticated user
          .collection('user_meals')
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThan: endTimestamp)
          .get();

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


  Future<void> updateMeal(String mealId, Meal updatedMeal) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('meals')
            .doc(user.uid)
            .collection('user_meals')
            .doc(mealId)
            .update({
          'mealType': updatedMeal.mealType,
          'mealName': updatedMeal.mealName,
          'description': updatedMeal.description,
          'protein': updatedMeal.protein,
          'carbohydrate': updatedMeal.carbohydrate,
          'fat': updatedMeal.fat,
          'totalCalories': updatedMeal.totalCalories,
          'date': Timestamp.fromDate(updatedMeal.date),
        });
        print('Meal updated successfully!');
      } else {
        print('Error: User not authenticated');
      }
    } catch (e) {
      print('Error updating meal: $e');
      throw e;
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

