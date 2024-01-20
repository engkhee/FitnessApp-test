import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {


  FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<bool> addTutorialVideo(String title, String description,
    String videoId) async {
  try {
    await _firestore.collection('tutorial_videos').add({
      'title': title,
      'description': description,
      'videoId': videoId,
    });
    // If the video is added successfully, return true
    return true;
  } catch (e) {
    // If an error occurs, print the error and return false
    print('Error adding tutorial video: $e');
    return false;
  }
}
}