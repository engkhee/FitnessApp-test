import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fooditem.dart';

class DatabaseHelper {
  final CollectionReference foodCollection =
  FirebaseFirestore.instance.collection('food_items');
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  // New collections for user-specific data
  final CollectionReference userLikesCollection =
  FirebaseFirestore.instance.collection('user_likes');
  final CollectionReference userFavoritesCollection =
  FirebaseFirestore.instance.collection('user_favorites');

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
          category: doc['category'],
          calories: doc['calories'],
          fat: doc['fat'],
          protein: doc['protein'],
          carbohydrate: doc['carbohydrate'],
          BMIgroup: doc['BMIgroup'],
          ingredient: doc['ingredient'],
          preparvideo: doc['preparvideo'],
          //isFavorite: doc['isFavorite'] ?? false,
          likes: doc['likes'],
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

  Future<void> updateLikes(String id, bool isFavorite, int currentLikes) async {
    try {
      // Update the likes count in the main food_items collection
      int newLikes = isFavorite ? currentLikes + 1 : currentLikes - 1;
      newLikes = newLikes.clamp(0, newLikes); // Ensure likes are not negative
      await foodCollection.doc(id).update({
        'isFavorite': isFavorite,
        'likes': newLikes,
      });

      // Update the user-specific likes collection
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await userLikesCollection.doc(userId).collection('likes').doc(id).set({
          'isFavorite': isFavorite,
          'likes': newLikes,
        });

        // Update the user's document with the liked items
        await usersCollection.doc(userId).update({
          'favorites': FieldValue.arrayUnion([id]),
        });
      }
    } catch (e) {
      print('Error updating likes and favorites: $e');
      rethrow;
    }
  }



  Future<int> getTotalLikesForItem(String itemId) async {
    try {
      QuerySnapshot<Object?> snapshot =
      await foodCollection.where('id', isEqualTo: itemId).get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0]['likes'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting total likes for item: $e');
      rethrow;
    }
  }

  // Helper method to get user-specific likes
  Future<bool> getUserLikeStatus(String itemId) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot<Map<String, dynamic>> userLikeSnapshot =
        await userLikesCollection
            .doc(userId)
            .collection('likes')
            .doc(itemId)
            .get();
        return userLikeSnapshot.exists
            ? userLikeSnapshot['isFavorite'] ?? false
            : false;
      }
      return false;
    } catch (e) {
      print('Error getting user-specific like status: $e');
      rethrow;
    }
  }

  Future<int> getLikesCount(String itemId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await foodCollection.doc(itemId).get() as DocumentSnapshot<Map<String, dynamic>>;

      if (snapshot.exists) {
        return snapshot.data()?['likes'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting likes count: $e');
      rethrow;
    }
  }



  Future<List<String>> getUserLikes(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userLikesDoc =
      await userLikesCollection.doc(userId).get()as DocumentSnapshot<Map<String, dynamic>>;

      if (userLikesDoc.exists) {
        // Assuming your structure is likes -> foodItemId -> isFavorite, likes
        Map<String, dynamic>? likesData = userLikesDoc.data()?['likes'];
        if (likesData != null) {
          // Filter food items where isFavorite is true
          List<String> favoriteItems =
          likesData.keys.where((itemId) => likesData[itemId]['isFavorite']).toList();
          return favoriteItems;
        }
      }

      return [];
    } catch (e) {
      print('Error getting user likes: $e');
      rethrow;
    }
  }

}