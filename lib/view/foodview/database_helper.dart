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
          isFavorite: doc['isFavorite'] ?? false,
        );
      }).toList();
    } catch (e) {
      print('Error getting food items: $e');
      rethrow;
    }
  }

  Future<void> deleteFoodItem(String id) async {
    try {
      await foodCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting food item: $e');
      rethrow;
    }
  }

  Future<void> updateFoodItem(FoodItem foodItem) async {
    try {
      await foodCollection.doc(foodItem.id).update(foodItem.toMap());
    } catch (e) {
      print('Error updating food item: $e');
      rethrow;
    }
  }

  Future<void> updateFavoriteStatus(String id, bool isFavorite) async {
    try {
      await foodCollection.doc(id).update({'isFavorite': isFavorite});
    } catch (e) {
      print('Error updating favorite status: $e');
      rethrow;
    }
  }

}