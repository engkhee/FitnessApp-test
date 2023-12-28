import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fitnessapp/view/tutorial_videos/create_playlist.dart';

class UserPage extends StatelessWidget {
  static String routeName = "/UserPage";

  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.playlist_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaylistManagementPage()),
              );
            },
          ),
        ],
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
          var videos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              var video = videos[index].data() as Map<String, dynamic>;
              var videoId = video['videoId'].toString();
              return ListTile(
                title: Text(video['title']),
                subtitle: Text(video['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(videoId: videoId),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoId;

  VideoPlayerPage({Key? key, required this.videoId}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize YoutubePlayerController with either Firebase-sourced or hardcoded video ID
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoId) ?? 'dQw4w9WgXcQ', // Fallback to hardcoded ID if conversion fails
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: YoutubePlayer(controller: _controller),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

