import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fitnessapp/view/firebase/firebase_service.dart';

class UserPage extends StatelessWidget {
  static String routeName = "/UserPage";
  UserPage({Key? key}) : super(key: key);

  FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: TutorialVideoList(),
    );
  }
}

class TutorialVideoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tutorial_videos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var videos = snapshot.data!.docs; // Use null-aware operator
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              var video = videos[index];
              return ListTile(
                title: Text(video['title']),
                subtitle: Text(video['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(videoId: video['videoId']),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return CircularProgressIndicator(); // Handle loading state
        }
      },
    );
  }
}


class VideoPlayerPage extends StatelessWidget {
  final String videoId;

  VideoPlayerPage({required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          ),
        ),
      ),
    );
  }
}
