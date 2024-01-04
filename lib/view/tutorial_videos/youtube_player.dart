// import 'package:flutter/cupertino.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// // Function to create a YouTube player
// Widget buildYoutubePlayer(String videoId) {
//   return YoutubePlayer(
//     controller: YoutubePlayerController(
//       initialVideoId: videoId,
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//         enableCaption: true,
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoId;

  YoutubePlayerWidget({Key? key, required this.videoId}) : super(key: key);

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Here we're ensuring the videoId is indeed a String.
    // If videoId is not null, we use it as is, otherwise, we provide a default value.
    String videoIdString = widget.videoId ?? 'Bgl5-sSjmYL5t4wz'; // Replace 'default_video_id' with an actual default ID if needed.

    _controller = YoutubePlayerController(
      initialVideoId: videoIdString,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.indigoAccent,
      progressColors: ProgressBarColors(
        playedColor: Colors.purple,
        handleColor: Colors.deepPurpleAccent,
      ),

    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
