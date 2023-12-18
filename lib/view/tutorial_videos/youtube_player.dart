import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Function to create a YouTube player
Widget buildYoutubePlayer(String videoId) {
  return YoutubePlayer(
    controller: YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
  );
}
