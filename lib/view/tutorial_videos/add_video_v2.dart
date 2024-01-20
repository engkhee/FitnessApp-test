import 'package:flutter/material.dart';
import 'package:fitnessapp/view/firebase/firebase_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/app_colors.dart';

class AddVideo2 extends StatefulWidget {
  static String routeName = "/AddVideo2";

  AddVideo2({Key? key}) : super(key: key);

  @override
  _AddVideo2State createState() => _AddVideo2State();
}

class _AddVideo2State extends State<AddVideo2> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();
  FirebaseService _firebaseService = FirebaseService();

  String? thumbnailUrl;
  String selectedCategory = 'English'; // Default category

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
        backgroundColor: AppColors.secondaryColor1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Dance Workout Videos",
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              DropdownButton<String>(
                value: selectedCategory,
                items: ['English', 'K-POP', 'Others'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
              ),
              if (thumbnailUrl != null) ...[
                SizedBox(height: 16),
                Image.network(thumbnailUrl!),
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
                    selectedCategory,
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
