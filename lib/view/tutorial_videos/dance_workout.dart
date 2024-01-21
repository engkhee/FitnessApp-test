import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DanceWorkout extends StatefulWidget {
  static String routeName = "/DanceWorkout";

  DanceWorkout({Key? key}) : super(key: key);

  @override
  _DanceWorkoutState createState() => _DanceWorkoutState();
}

class _DanceWorkoutState extends State<DanceWorkout> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All'; // Default category


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD1C4E9),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Dance Workout",
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Videos',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
                    ),
                    onChanged: (value) => (context as Element).markNeedsBuild(),
                  ),
                ),
                SizedBox(width: 10),
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
                    items: ['All', 'English', 'K-POP', 'Others'].map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 8,
              thumbVisibility: true,
              radius: const Radius.circular(10),
              child: TutorialVideoList(
                searchQuery: _searchController.text,
                selectedCategory: selectedCategory,
              ),
            ),
          ),
        ],
      ),
    );
}
}

class TutorialVideoList extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;

  TutorialVideoList({
    Key? key,
    required this.searchQuery,
    required this.selectedCategory,
  }) : super(key: key);

  Future<List<QueryDocumentSnapshot>> getVideos() async {
    CollectionReference collectionReference;

    switch (selectedCategory) {
      case 'English':
        collectionReference = FirebaseFirestore.instance.collection('eng_videos');
        break;
      case 'K-POP':
        collectionReference = FirebaseFirestore.instance.collection('kpop_videos');
        break;
      case 'Others':
        collectionReference = FirebaseFirestore.instance.collection('other_videos');
        break;
      default:
      // Fetch documents from all collections
      List<QueryDocumentSnapshot> allVideos = [];
      allVideos.addAll(await FirebaseFirestore.instance.collection('eng_videos').get().then((value) => value.docs));
      allVideos.addAll(await FirebaseFirestore.instance.collection('kpop_videos').get().then((value) => value.docs));
      allVideos.addAll(await FirebaseFirestore.instance.collection('other_videos').get().then((value) => value.docs));
      return allVideos;
    }
    return await collectionReference.get().then((value) => value.docs);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getVideos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var documents = snapshot.data ?? [];
          var videos = documents.where((doc) {
            var video = doc.data() as Map<String, dynamic>;
            return (video['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
                video['description'].toString().toLowerCase().contains(searchQuery.toLowerCase()));
          }).toList();

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              var video = videos[index].data() as Map<String, dynamic>;
              var videoId = YoutubePlayer.convertUrlToId(video['videoId']) ?? '';
              var thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
              var views = video['views'] ?? 0;

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
                          views: views,
                          selectedCategory: selectedCategory,
                          onViewsUpdated: (newViews) {
                            // Update views in the video list when returning from the player page
                            video['views'] = newViews;
                          },
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
                        trailing: Text('$views views'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}


class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final int views;
  final String selectedCategory;
  final Function(int) onViewsUpdated;

  VideoPlayerPage({
    Key? key,
    required this.videoId,
    required this.title,
    required this.description,
    required this.views,
    required this.selectedCategory,
    required this.onViewsUpdated,
    }) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  late Size size;
  bool isFullScreen = false;

  String getCategoryCollectionPath(String category) {
    switch (category) {
      case 'English':
        return 'eng_videos';
      case 'K-POP':
        return 'kpop_videos';
      case 'Others':
        return 'other_videos';
      default:
        return ''; // Handle other cases as needed
    }
  }

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
    // Update views when the VideoPlayerPage is initialized
    updateViews(widget.videoId, widget.views);
  }

  void updateViews(String videoId, int currentViews) async {
    try {
      await FirebaseFirestore.instance
          .collection(getCategoryCollectionPath(widget.selectedCategory))
          .doc(videoId)
          .update({'views': currentViews + 1});

      // Callback to update views in the parent list
      widget.onViewsUpdated(currentViews + 1);
    } catch (error) {
      print('Error updating views: $error');
    }
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
    widget.onViewsUpdated(widget.views + 1);
  }
}

