import 'package:flutter/material.dart';
import 'package:fitnessapp/view/firebase/firebase_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddVideo extends StatefulWidget {
  static String routeName = "/AddVideo";

  AddVideo({Key? key}) : super(key: key);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();
  FirebaseService _firebaseService = FirebaseService();

  String? thumbnailUrl;

  void updateThumbnail() {
    String? videoId = YoutubePlayer.convertUrlToId(videoIdController.text);
    if (videoId != null) {
      setState(() {
        thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
      });
    }
  }

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
              decoration: InputDecoration(labelText: 'YouTube Video URL'),
              onChanged: (value) => updateThumbnail(),
            ),
            if (thumbnailUrl != null) ...[
              SizedBox(height: 16),
              Image.network(thumbnailUrl!),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool success = await _firebaseService.addTutorialVideo(
                  titleController.text,
                  descriptionController.text,
                  YoutubePlayer.convertUrlToId(videoIdController.text) ?? '',
                );
                if (success) {
                  showSnackBar(context, 'Video uploaded successfully');
                  titleController.clear();
                  descriptionController.clear();
                  videoIdController.clear();
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
