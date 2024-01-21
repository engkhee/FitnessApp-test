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
  YoutubePlayerController? _youtubeController;
  String? thumbnailUrl;
  String selectedCategory = 'K-POP'; // Default category

  void updateThumbnail() {
    String? videoId = YoutubePlayer.convertUrlToId(videoIdController.text);
    if (videoId != null) {
      setState(() {
        thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
        _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(autoPlay: false),
      );
    });
  }}

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor1,
        title: Text(
          "Add Dance Workout Videos",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.ondemand_video_rounded, 
              color: Colors.black,
            ),
            onPressed: () {
              // Navigate to the other page here
              Navigator.pushNamed(context, '/DanceWorkout');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(
                  color: AppColors.secondaryColor1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Enter video title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor1),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  color: AppColors.secondaryColor1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Enter video description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor1),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'YouTube Video URL',
                style: TextStyle(
                  color: AppColors.secondaryColor1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: videoIdController,
                decoration: InputDecoration(
                  labelText: 'Enter YouTube Video URL',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor1),
                  ),
                ),
                onChanged: (value) => updateThumbnail(),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.secondaryColor1),
                ),
                child: DropdownButton<String>(
                  value: selectedCategory,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(
                    height: 0,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    }
                  },
                  items: ['English', 'K-POP', 'Others'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ),
              if (thumbnailUrl != null) ...[
                SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubePlayer(
                      controller: _youtubeController!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: AppColors.secondaryColor1,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
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

                      setState(() {
                        thumbnailUrl = null;
                      });

                    } else {
                      showSnackBar(context, 'Error uploading video');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.adminpageColor2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.video_library_rounded,
                          color: AppColors.whiteColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upload Video',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
