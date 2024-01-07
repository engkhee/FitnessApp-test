import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fitnessapp/view/Traning/training_home.dart';

import '../../common_widgets/round_button.dart';

class VideoInfo extends StatefulWidget{
  const VideoInfo({Key? key}) : super(key:key);

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo>{
  List videoinfo = [];
  bool _playArea = false;
  int _currentVideoIndex = 0;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _initData();
    _initYoutubePlayer();
  }

  void _initYoutubePlayer() {
    if (videoinfo.isNotEmpty) {
      final videoUrl = videoinfo[_currentVideoIndex]["videoUrl"];
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  Future<void> _initData() async {
    String data = await DefaultAssetBundle.of(context).loadString("json/videoinfo.json");
    List<dynamic> jsonResult = jsonDecode(data);
    if (jsonResult.isNotEmpty) {
      setState(() {
        videoinfo = jsonResult;
        _initYoutubePlayer(); // Initialize the player after data is loaded
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: _playArea==false? BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFA000),
                Color(0xFFFFE082).withOpacity(0.5),
              ],
              begin: const FractionalOffset(0.0, 0.4),
              end: Alignment.topRight,
            )
          ): BoxDecoration(
            color: Color(0xffffcdd2),
          ),
          child: Column(
            children: [
              _playArea==false? Container(
                padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>training()));
                          },
                          child: Icon(Icons.arrow_back_ios, size: 20,
                          color: Colors.black,),
                        ),
                        Expanded(child: Container()),
                        Icon(Icons.info_outline, size: 20,
                          color: Colors.black,),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Text(
                      "Legs Toning",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "and Glutes Workout",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Row(
                      children: [
                        Container(
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white70,
                                Colors.white12,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer, size: 20, color: Colors.black,),
                              SizedBox(width: 5,),
                              Text(
                                "23 min",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                        ),
                        SizedBox(width: 20,),
                        Container(
                          width: 220,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white70,
                                  Colors.white12,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.handyman_outlined, size: 20, color: Colors.black,),
                              SizedBox(width: 5,),
                              Text(
                                "Resistent band",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ],
                    ),
                  ],
                ),
              ): Container(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              debugPrint("tapped");
                            },
                            child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.info_outline, size: 20, color: Colors.black,),
                        ],
                      ),
                    ),
                    _playView(context),
                  ],
                ),
              ),
              Expanded(child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        SizedBox(width: 30,),
                        Text(
                          "Credit to: MadFit",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Icon(Icons.loop, size: 20, color: Colors.black,),
                            SizedBox(width: 5,),
                            Text("1 set",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),)
                          ],
                        ),
                        SizedBox(width: 20,),
                      ],
                    ),
                    Expanded(child: _listView())
                  ],
                ),
              ))
            ],
          ),
        ),
    );
  }

  _playView(BuildContext context) {
    return Column(
      children: [
        YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
        ),
        _videoControls(), // Add this line
      ],
    );
  }

  Widget _videoControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: _playPrevious,
        ),
        IconButton(
          icon: Icon(
            _youtubeController.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: _playPause,
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: _playNext,
        ),
      ],
    );
  }

  void _playPause() {
    if (_youtubeController.value.isPlaying) {
      _youtubeController.pause();
    } else {
      _youtubeController.play();
    }
    setState(() {});
  }

  void _playNext() {
    if (_currentVideoIndex < videoinfo.length - 1) {
      _currentVideoIndex++;
      _loadVideo(_currentVideoIndex);
    } else {
      // User has finished watching all videos
      _showCongratulationsMessage();
    }
  }

  void _showCongratulationsMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("Well done! You've finished this workout!"),
          actions: <Widget>[
            RoundButton(
              onPressed: () {
                _youtubeController.pause(); // Pause the video
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => training())); // Navigate to the training page
              },
              title: 'OK',
            ),
          ],
        );
      },
    );
  }

  void _playPrevious() {
    if (_currentVideoIndex > 0) {
      _currentVideoIndex--;
      _loadVideo(_currentVideoIndex);
    }
  }

  void _loadVideo(int index) {
    final videoUrl = videoinfo[index]["videoUrl"];
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _youtubeController.load(videoId!);
    setState(() {});
  }

  _onTapVideo(int index) {
    final videoUrl = videoinfo[index]["videoUrl"];
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    setState(() {
      if (_playArea == false) {
        _playArea = true;
      }
    });
  }

  _listView(){
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        itemCount: videoinfo.length, //array number of videos in the list
        itemBuilder:(_,int index){

          return GestureDetector(
            onTap: (){
              _onTapVideo(index);
              debugPrint(index.toString());
              setState(() {
                if(_playArea==false){
                  _playArea = true;
                }
              });
            },
            child: _buildCard(index),
          );

        });
  }

  _buildCard(int index){
    return Container(
      height: 135,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        videoinfo[index]["thumbnail"],
                      ),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              SizedBox(width: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoinfo[index]["title"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      videoinfo[index]["time"],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 18,),
          Row(
            children: [
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFFFFD180).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "15s rest",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xffff9100),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for(int i=0; i<80; i++)
                    i.isEven? Container(
                      width: 3,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Color(0xffff9800),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ):Container(
                      width: 3,
                      height: 1,
                      color: Colors.white,
                    ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }
}