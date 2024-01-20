import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {

  Future<bool> addTutorialVideo(
      String title,
      String description,
      String videoId,
      String category,
      ) async {
    try {
      String collectionPath = getCategoryCollectionPath(category);

      await FirebaseFirestore.instance.collection(collectionPath).add({
        'title': title,
        'description': description,
        'videoId': videoId,
        'category': category,
      });

      return true;
    } catch (e) {
      print('Error adding tutorial video: $e');
      return false;
    }
  }

  String getCategoryCollectionPath(String category) {
    switch (category) {
      case 'English':
        return 'eng_videos';
      case 'K-POP':
        return 'kpop_videos';
      case 'Others':
        return 'other_videos';
      default:
        return 'tutorial_videos';
    }
  }
}