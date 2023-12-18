import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTutorialVideo(String title, String description, String videoId) async {
    await _firestore.collection('tutorial_videos').add({
      'title': title,
      'description': description,
      'videoId': videoId,
    });
  }
}
