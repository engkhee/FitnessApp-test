import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fitnessapp/view/firebase/firebase_service3.dart';

class AddVideo3 extends StatefulWidget {
  static String routeName = "/AddVideo3";

  AddVideo3({Key? key}) : super(key: key);

  @override
  _AddVideo3State createState() => _AddVideo3State();
}

class _AddVideo3State extends State<AddVideo3> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();
  FirebaseService _firebaseService = FirebaseService();
  YoutubePlayerController? _youtubeController;
  String? thumbnailUrl;

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
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.adminpageColor4,
        title: Text(
          "Add Exercise Tutorials",
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
              Navigator.pushNamed(context, '/ExerciseTutos');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: TextStyle(
                color: AppColors.adminpageColor4,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Enter video title',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.adminpageColor4),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'YouTube Video URL',
              style: TextStyle(
                color: AppColors.adminpageColor4,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: videoIdController,
              decoration: InputDecoration(
                labelText: 'Enter YouTube Video URL',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.adminpageColor4),
                ),
              ),
              onChanged: (value) => updateThumbnail(),
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
                    progressIndicatorColor: AppColors.adminpageColor4,
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
                      videoIdController.text.isEmpty) {
                    showSnackBar(context, 'Please fill in all fields');
                    return;
                  }
                  bool success = await _firebaseService.addTutorialVideo(
                    titleController.text,
                    YoutubePlayer.convertUrlToId(videoIdController.text) ?? '',
                  );
                  if (success) {
                    showSnackBar(context, 'Video uploaded successfully');
                    titleController.clear();
                    videoIdController.clear();

                    setState(() {
                      thumbnailUrl = null;
                    });

                  } else {
                    showSnackBar(context, 'Error uploading video');
                  }             },
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
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 16),
      ),
      duration: Duration(seconds: 2),
    ),
  );
}
