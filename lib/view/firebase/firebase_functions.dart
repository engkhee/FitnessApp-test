import 'package:firebase_core/firebase_core.dart';

class FirebaseFunctions {
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }
}
