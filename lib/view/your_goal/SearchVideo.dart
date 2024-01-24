import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SearchVideo extends StatelessWidget {
  final List<String> searchQueries;

  const SearchVideo({Key? key, required this.searchQueries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommended Workouts:"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Search Queries:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display search queries
            for (String query in searchQueries)
              ListTile(
                title: Text(query),
              ),
            // Add your video search result widgets here
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
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        title: Text(video['title']),
                        subtitle: Text(video['description']),
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
      appBar: isFullScreen
          ? null // Hide AppBar in full-screen mode
          : AppBar(
        backgroundColor: Color(0xFF9575CD),
        title: Text(
          widget.title,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: isFullScreen ? size.width : size.height, // Adjust height for full-screen
            width: size.width,
            decoration: BoxDecoration(color: Color(0xFFD1C4E9)),
            child: Center(
              child: YoutubePlayer(controller: _controller),
            ),
          ),
          if (!isFullScreen) // Show controls only in non-fullscreen mode
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
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
