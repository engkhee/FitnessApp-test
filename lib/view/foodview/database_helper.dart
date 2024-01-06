import 'package:cloud_firestore/cloud_firestore.dart';
import 'fooditem.dart';

class DatabaseHelper {
  final CollectionReference foodCollection =
  FirebaseFirestore.instance.collection('food_items');

  Future<void> insertFoodItem(FoodItem foodItem) async {
    try {
      await foodCollection.add(foodItem.toMap());
    } catch (e) {
      print('Error inserting food item: $e');
      rethrow; // Rethrow the error to handle it in the calling code
    }
  }

  Future<List<FoodItem>> getFoodItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await foodCollection.get() as QuerySnapshot<Map<String, dynamic>>;
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return FoodItem(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          description: doc['description'],
          calories: doc['calories'],
          category: doc['category'],
        );
      }).toList();
    } catch (e) {
      print('Error getting food items: $e');
      rethrow;
    }
  }

}