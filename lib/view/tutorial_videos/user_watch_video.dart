import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//import 'package:fitnessapp/view/tutorial_videos/create_playlist.dart';

class UserPage extends StatelessWidget {
  static String routeName = "/UserPage";
  final TextEditingController _searchController = TextEditingController();

  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD1C4E9),
        //title: Text('Tutorial Videos'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tutorial Videos",
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        //actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.playlist_add),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => PlaylistManagementPage()),
          //     );
          //   },
          // ),
        //],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Videos',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
              ),
              onChanged: (value) => (context as Element).markNeedsBuild(), // To rebuild the widget tree
            ),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 8,
              thumbVisibility: true,
              radius: const Radius.circular(10),
              child: TutorialVideoList(searchQuery: _searchController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialVideoList extends StatelessWidget {
  final String searchQuery;
  TutorialVideoList({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tutorial_videos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var videos = snapshot.data!.docs.where((doc) {
            var video = doc.data() as Map<String, dynamic>;
            return (video['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()) || video['description'].toString().toLowerCase().contains(searchQuery.toLowerCase()));
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
    );
  }

  void seekForward() {
    _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds + 5));
  }

  void seekBackward() {
    _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - 5));
  }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9575CD),
        title: Text(widget.title,
            style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(color: Color(0xFFD1C4E9)),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  YoutubePlayer(controller: _controller,),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_5),
                              onPressed: seekBackward,
                              color: Colors.purple,
                            ),
                            IconButton(
                              icon: Icon(_controller.value.isPlaying? Icons.pause:Icons.play_arrow),
                              onPressed: (){
                                if(_controller.value.isPlaying)
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
                              icon: Icon(_controller.value.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                              onPressed: () async {
                                if (_controller.value.isFullScreen) {
                                  exitFullScreen();
                                }
                                else
                                  enterFullScreen();
                              })
                              ],
                            )
                          ],
                        )
                  )],
                    ),
                  ),
          )],
              )
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

