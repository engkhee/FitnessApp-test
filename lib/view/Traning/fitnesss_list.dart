import 'dart:convert';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/Traning/train2.dart';
import 'package:fitnessapp/view/Traning/train3.dart';
import 'package:fitnessapp/view/Traning/train4.dart';
import 'package:fitnessapp/view/Traning/train5.dart';
import 'package:fitnessapp/view/Traning/training_home.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/round_button.dart';

class FitnessList extends StatefulWidget {
  const FitnessList({Key? key}) : super(key: key);

  @override
  State<FitnessList> createState() => _FitnessListState();
}

class _FitnessListState extends State<FitnessList> {
  List workout_info = [];

  final Map<String, Widget Function(BuildContext)> pageRoutes = {
    'training': (context) => training(),
    'train2': (context) => train2(),
    'train3': (context) => train3(),
    'train4': (context) => train4(),
    'train5': (context) => train5(),
  };

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    DefaultAssetBundle.of(context).loadString("json/workout.json").then((
        value) {
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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.primaryG)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          //padding: EdgeInsets.only(top: 60, left: 10, right: 10,),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                title: const Text(
                  "Fitness List",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()));
                    },
                    child: Icon(Icons.home, size: 20, color: Colors.black,),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 30, left: 30,),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          _listView(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listView() {
    if (workout_info.isEmpty) {
      return Center(child: Text('No workouts available'));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: workout_info.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            debugPrint(index.toString());
          },
          child: _buildCard(index),
        );
      },
    );
  }


  _buildCard(int index) {
    // Array of colors for the background
    List<Color> cardColors = [
      Colors.blue.withOpacity(0.2),
      Colors.green.withOpacity(0.3),
      Colors.red.withOpacity(0.3),
      Colors.yellow.withOpacity(0.2),
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 140,
      decoration: BoxDecoration(
          color: cardColors[index % cardColors.length],
          // Ensure index is within range
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(1,5),
              color: Color(0xFFBBDEFB).withOpacity(0.1),
            ),
            BoxShadow(
              blurRadius: 4,
              offset: Offset(-1,-5),
              color: Color(0xFFBBDEFB).withOpacity(0.3),
            )
          ]
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(workout_info[index]["image"]),
                    fit: BoxFit.contain, // Changed to BoxFit.contain
                  ),
                ),
              ),
            ),
            // Image Container
            SizedBox(width: 10),
            // Text and Button Column
            Expanded( // Expanded to fill the remaining space
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout_info[index]["title"],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    workout_info[index]["time"],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    workout_info[index]["exercises"],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, right: 15,),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 75,
                  height: 25,
                  child: RoundButton(
                    title: 'Start',
                    onPressed: () =>
                        _navigateToPage(workout_info[index]["filename"]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}