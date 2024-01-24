import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/home/widgets/workout_row.dart';
import 'package:fitnessapp/view/on_boarding/start_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/view/calories/caloriestracker.dart';
import 'package:fitnessapp/view/calories/piechart.dart';
import '../../common_widgets/round_button.dart';
import '../notification/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/HomeScreen";
  final double? bmi;

  const HomeScreen({Key? key, this.bmi}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(bmi: bmi);
}

class _HomeScreenState extends State<HomeScreen> {
  final double? bmi;

  _HomeScreenState({this.bmi});

  final CollectionReference _userProfileCollection =
  FirebaseFirestore.instance.collection('User_profile_info');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }


  List<int> showingTooltipOnSpots = [21];

  List lastWorkoutArr = [
    {
      "name": "Full Body Workout",
      "image": "assets/images/Workout1.png",
      "kcal": "180",
      "time": "20",
      "progress": 0.3
    },
    {
      "name": "Lower Body Workout",
      "image": "assets/images/Workout2.png",
      "kcal": "200",
      "time": "30",
      "progress": 0.4
    },
    {
      "name": "Ab Workout",
      "image": "assets/images/Workout3.png",
      "kcal": "300",
      "time": "40",
      "progress": 0.7
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery
        .of(context)
        .size;


    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, NotificationScreen.routeName);
                            },
                            icon: Image.asset(
                              "assets/icons/notification_icon.png",
                              width: 25,
                              height: 25,
                              fit: BoxFit.fitHeight,
                            )),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back,",
                              style: TextStyle(
                                color: AppColors.midGrayColor,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Stefani Wong",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 20,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,),),
                          ],
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, StartScreen.routeName);
                          },
                          icon: const Icon(Icons.info_outline, color: Colors.black,),
                        ),
                      ],
                    ),
                    SizedBox(height: media.width * 0.05),
                    Container(
                      height: media.width * 0.4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: AppColors.primaryG),
                          borderRadius: BorderRadius.circular(media.width * 0.065)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRect(
                                              child: Image.asset(
                                                "assets/icons/bg_dots.png",
                                                height: media.width * 0.4,
                                                width: double.maxFinite,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "BMI (Body Mass Index)",
                                      style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // Text(
                                    //   "You have a normal weight",
                                    //   style: TextStyle(
                                    //     color:
                                    //     AppColors.whiteColor.withOpacity(0.7),
                                    //     fontSize: 12,
                                    //     fontFamily: "Poppins",
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // ),
                                    // SizedBox(height: media.width * 0.05),
                                    FutureBuilder<DocumentSnapshot>(
                                      future: _userProfileCollection.doc(_user?.uid).get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return Text('No BMI data available.');
                                        }

                                        // Access user's BMI data
                                        var userData = snapshot.data!.data();
                                        double? bmi = (userData as Map<String, dynamic>)?['bmi'];
                                        if (bmi != null) {
                                          String bmiCategory = getBMICategory(bmi);
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'BMI: $bmi',
                                                style: const TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 16,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(height: media.width * 0.02),
                                              Text(
                                                bmiCategory,
                                                style: const TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text('No BMI data available.');
                                        }
                                      },
                                    ),
                                    SizedBox(height: media.width * 0.05),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: SizedBox(
                                        height: 35,
                                        width: 100,
                                        child: RoundButton(
                                            title: "View More", onPressed: () {}),
                                      ),
                                    )
                                  ],
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                                      ),
                                      startDegreeOffset: 250,
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 1,
                                      centerSpaceRadius: 0,
                                      sections: showingSections(bmi), // Pass the BMI value here
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: media.width * 0.05),
                    const Text(
                      "Calories Tracker",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: media.width * 0.02),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CaloriesTrackerPage()),
                        );
                      },
                      child: //DailyPieChart(date: DateTime(2024, 1, 18)),
                      DailyPieChart(date: DateTime.now()),
                    ),
                    SizedBox(height: media.width * 0.05),

                    // SizedBox(height: media.width * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Workout Progress",
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: AppColors.primaryG),
                              borderRadius: BorderRadius.circular(15)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: ["Weekly", "Monthly"]
                                  .map((name) =>
                                  DropdownMenuItem(
                                      value: name,
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 14),
                                      )))
                                  .toList(),
                              onChanged: (value) {},
                              icon: const Icon(Icons.expand_more,
                                  color: AppColors.whiteColor),
                              hint: const Text("Weekly",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: AppColors.whiteColor, fontSize: 12)),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: media.width * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Latest Workout",
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "See More",
                            style: TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: lastWorkoutArr.length,
                        itemBuilder: (context, index) {
                          var wObj = lastWorkoutArr[index] as Map? ?? {};
                          return InkWell(
                              onTap: () {
                                //Navigator.pushNamed(context, FinishWorkoutScreen.routeName);
                              },
                              child: WorkoutRow(wObj: wObj));
                        }),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                  ]
              ),
            ),
          ),
        )
    );
  }

  List<PieChartSectionData> showingSections(double? bmi) {
    bmi ??= 0.0; // If bmi is null, set it to 0.0
    return List.generate(2,
          (i) {
        const color0 = AppColors.secondaryColor2;
        const color1 = AppColors.whiteColor;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 33,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.55,
              badgeWidget: Text(
                bmi.toString(),
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 75,
              title: '',
              radius: 42,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }
  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return "You are underweight";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return "You have a normal weight";
    } else if (bmi >= 25 && bmi <= 29.9) {
      return "You are overweight";
    } else {
      return "You are in the obese range";
    }
  }


}