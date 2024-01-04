import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fitnessapp/view/tutorial_videos/create_playlist.dart';

class UserPage extends StatelessWidget {
  static String routeName = "/UserPage";
  final TextEditingController _searchController = TextEditingController();

  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Tutorial Videos'),
        title: const Text(
          "Tutorial Videos",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
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

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoId) ?? 'dQw4w9WgXcQ',
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
        title: Text(widget.title),

      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: YoutubePlayer(controller: _controller),
            ),
          ),
          Padding(
            // padding: EdgeInsets.all(8.0),
            // child: Text(
            //   widget.description,
            //   style: TextStyle(fontSize: 16),
            // ),
            padding: const EdgeInsets.all(32),
            child: Text(
              widget.description,
              softWrap: true,
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
  }
}

