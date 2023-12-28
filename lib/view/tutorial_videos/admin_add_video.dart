import 'package:flutter/material.dart';
import 'package:fitnessapp/view/firebase/firebase_service.dart';

class AddVideo extends StatelessWidget {
  static String routeName = "/AddVideo";
  AddVideo({Key? key}) : super(key: key);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();

  FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tutorial Videos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: videoIdController,
              decoration: InputDecoration(labelText: 'YouTube Video ID'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool success = await _firebaseService.addTutorialVideo(
                  titleController.text,
                  descriptionController.text,
                  videoIdController.text,
                );
                if (success) {
                  showSnackBar(context, 'Video uploaded successfully');
                } else {
                  showSnackBar(context, 'Error uploading video');
                }

              },
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}
