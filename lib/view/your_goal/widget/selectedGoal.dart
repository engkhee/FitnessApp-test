import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/activity/activity_screen.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class selectedGoal extends StatefulWidget {
  final String selectedGoalId;

  const selectedGoal({Key? key, required this.selectedGoalId}) : super(key: key);

  @override
  _selectedGoalState createState() => _selectedGoalState();
}

class _selectedGoalState extends State<selectedGoal> {
  late List<String> searchQueries;

  @override
  void initState() {
    super.initState();
    searchQueries = getSearchQueriesForGoalId(widget.selectedGoalId);
  }

  List<String> getSearchQueriesForGoalId(String goalId) {
    switch (goalId) {
      case '1':
        return ['arm', 'shoulder'];
      case '2':
        return ['chest', 'back'];
      case '3':
        return ['ab'];
      case '4':
        return ['leg', 'glute'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommended Workouts",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),),
        backgroundColor: Color(0xFF9575CD),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Area(s) of Focus:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (String query in searchQueries)
                  Chip(
                    label: Text(query),
                    backgroundColor: Colors.purple.withOpacity(0.7),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Scrollbar(
                thickness: 8,
                thumbVisibility: true,
                radius: const Radius.circular(10),
                child: VideoSearchResults(searchQueries: searchQueries),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoSearchResults extends StatelessWidget {
  final List<String> searchQueries;

  VideoSearchResults({Key? key, required this.searchQueries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tutorial_videos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var videos = snapshot.data!.docs.where((doc) {
            var video = doc.data() as Map<String, dynamic>;
            return searchQueries.any((query) =>
            video['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
                video['description'].toString().toLowerCase().contains(query.toLowerCase()));
          }).toList();

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              var video = videos[index].data() as Map<String, dynamic>;
              var videoId = YoutubePlayer.convertUrlToId(video['videoId']) ?? '';
              var thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(
                          videoId: videoId,
                          title: video['title'],
                          description: video['description'],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video['title'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              video['description'],
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
  final String title;
  final String description;

  VideoPlayerPage({Key? key, required this.videoId, required this.title, required this.description}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  late Size size;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoId) ?? 'dQw4w9WgXcQ',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    )..addListener(() {
      if (_controller.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = _controller.value.isFullScreen;
        });
      }
    });
  }

  void seekForward() {
    _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds + 5));
  }

  void seekBackward() {
    _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - 5));
  }

  void toggleFullScreen() {
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    _controller.toggleFullScreenMode();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: isFullScreen ? null : AppBar(
        backgroundColor: Color(0xFF9575CD),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: isFullScreen ? size.width : size.height,
            width: size.width,
            decoration: BoxDecoration(color: Color(0xFFD1C4E9)),
            child: Center(
              child: YoutubePlayer(controller: _controller),
            ),
          ),
          if (!isFullScreen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _controller.pause();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DashboardScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controller.pause();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_5),
                          onPressed: seekBackward,
                          color: Colors.purple,
                        ),
                        IconButton(
                          icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: () {
                            if (_controller.value.isPlaying)
                              _controller.pause();
                            else
                              _controller.play();
                          },
                          color: Colors.purple,
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_5),
                          onPressed: seekForward,
                          color: Colors.purple,
                        ),
                        IconButton(
                          icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                          onPressed: toggleFullScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}
