import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/view/firebase/firebase_service2.dart';
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
        backgroundColor: AppColors.primaryColor1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Tutorial Videos",
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
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
              // Limit the height of the image to avoid overflow
                FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Image.network(thumbnailUrl!),
                ),
              ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    videoIdController.text.isEmpty) {
                  showSnackBar(context, 'Please fill in all fields');
                  return;
                }
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
                }},
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

