import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/Traning/training_home.dart';
import 'package:fitnessapp/view/tutorial_videos/user_watch_video.dart';
import '../../common_widgets/round_button.dart';
import '../Traning/fitnesss_list.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List workout_info = [];

  final Map<String, Widget Function(BuildContext)> pageRoutes = {
    'training': (context) => training(), // Replace with actual page
    // Add more entries for different workouts
    // 'anotherFilename': (context) => AnotherPage(),
    // 'yetAnotherFilename': (context) => YetAnotherPage(),
  };

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    DefaultAssetBundle.of(context).loadString("json/workout.json").then((value) {
      setState(() {
        workout_info = jsonDecode(value);
      });
    });
  }

  void _navigateToPage(String filename) {
    final pageBuilder = pageRoutes[filename];
    if (pageBuilder != null) {
      Navigator.push(context, MaterialPageRoute(builder: pageBuilder));
    } else {
      print('Filename not recognized: $filename');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor1,
        title: const Text(
          "Fitness",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.whiteColor,
            ),
            onPressed: () {
              // Your action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSection(
              title: "Explore more tutorial videos",
              description: "Discover a variety of tutorial videos",
              imageAsset: "assets/images/pp_2.png",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPage(),
                  ),
                );
              },
            ),
            _buildSection(
              title: "Explore more workout plans",
              description: "Find the perfect fitness workout plans",
              imageAsset: "assets/images/pp_5.png",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FitnessList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required String imageAsset,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Search",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ActivityScreen(),
  ));
}

