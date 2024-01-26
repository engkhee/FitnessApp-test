import 'package:fitnessapp/view/calories/piechart.dart';
import 'package:fitnessapp/view/tutorial_videos/exercise_tuto.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/on_boarding/start_screen.dart';
import 'package:fitnessapp/view/calories/caloriestracker.dart';
import '../../common_widgets/round_button.dart';
import '../notification/notification_screen.dart';
import '../recognition/tflite_model.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      if (_currentPage <= 3 - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
                        Navigator.pushNamed(context, NotificationScreen.routeName);
                      },
                      icon: Image.asset(
                        "assets/icons/notification_icon.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TfliteModel()),
                        );
                      },
                      icon: Icon(Icons.settings_overscan_outlined, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, StartScreen.routeName);
                      },
                      icon: Icon(Icons.info_outline, color: Colors.black,),
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
                        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
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
                                Text(
                                  "You have a normal weight",
                                  style: TextStyle(
                                    color: AppColors.whiteColor.withOpacity(0.7),
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: media.width * 0.05),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SizedBox(
                                    height: 35,
                                    width: 100,
                                    child: RoundButton(
                                      title: "View More", onPressed: () {},
                                    ),
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
                                  sections: showingSections(),
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
                        builder: (context) => CaloriesTrackerPage(),
                      ),
                    );
                  },
                  child: DailyPieChart(date: DateTime.now()),
                ),
                SizedBox(height: media.width * 0.05),
                SizedBox(height: media.width * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Learning Space",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                Container(
                  height: 230,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 4, // Number of images
                    itemBuilder: (context, index) {
                      List<String> imageUrls = [
                        'https://preview.redd.it/x7qubqqjv6061.jpg?width=640&crop=smart&auto=webp&s=6d60c801be6beff90be2073d53e8b24afa8e9d82',
                        'https://fitnesshealthforever.b-cdn.net/wp-content/uploads/2019/10/Burpees.jpg',
                        'https://th.bing.com/th/id/OIP.t7p9QZ6a87-Y4SsUn_u-HwHaE8?rs=1&pid=ImgDetMain',
                        'https://inshape.blog/wp-content/uploads/2021/10/how-to-do-jumping-jacks-guide.jpg',
                      ];

                      return Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor1.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Find Out Exercise Tutorials",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: SizedBox(
                          height: 35,
                          width: 100,
                          child: RoundButton(
                            title: "View More", onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExerciseTutos()));
                          }, //hi
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
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
                "20.1",
                style: TextStyle(
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
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: HomeScreen(),
    ),
  ));
}
