import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/home/widgets/workout_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:fitnessapp/view/calories/caloriestracker.dart';
import 'package:fitnessapp/view/calories/piechart.dart';
import '../../common_widgets/round_button.dart';
import '../notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<int> showingTooltipOnSpots = [21];

  List<FlSpot> get allSpots =>
      const [
        FlSpot(0, 20),
        FlSpot(1, 25),
        FlSpot(2, 40),
        FlSpot(3, 50),
        FlSpot(4, 35),
        FlSpot(5, 40),
        FlSpot(6, 30),
        FlSpot(7, 20),
        FlSpot(8, 25),
        FlSpot(9, 40),
        FlSpot(10, 50),
        FlSpot(11, 35),
        FlSpot(12, 50),
        FlSpot(13, 60),
        FlSpot(14, 40),
        FlSpot(15, 50),
        FlSpot(16, 20),
        FlSpot(17, 25),
        FlSpot(18, 40),
        FlSpot(19, 50),
        FlSpot(20, 35),
        FlSpot(21, 80),
        FlSpot(22, 30),
        FlSpot(23, 20),
        FlSpot(24, 25),
        FlSpot(25, 40),
        FlSpot(26, 50),
        FlSpot(27, 35),
        FlSpot(28, 50),
        FlSpot(29, 60),
        FlSpot(30, 40),
      ];

  List waterArr = [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"}
  ];

  List<LineChartBarData> get lineBarsData1 =>
      [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 =>
      LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          AppColors.primaryColor2.withOpacity(0.5),
          AppColors.primaryColor1.withOpacity(0.5),
        ]),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 25),
          FlSpot(6, 70),
          FlSpot(7, 35),
        ],
      );

  LineChartBarData get lineChartBarData1_2 =>
      LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          AppColors.secondaryColor2.withOpacity(0.5),
          AppColors.secondaryColor1.withOpacity(0.5),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

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
                            fontWeight: FontWeight.w700,),),
                      ],
                    )
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
                        EdgeInsets.symmetric(vertical: 25, horizontal: 25),
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
                                    color:
                                    AppColors.whiteColor.withOpacity(0.7),
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
                                    touchCallback: (FlTouchEvent event,
                                        pieTouchResponse) {},
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
                          builder: (context) => CaloriesTrackerPage()),
                    );
                  },
                  child: //DailyPieChart(date: DateTime(2024, 1, 18)),
                  DailyPieChart(date: DateTime.now()),
                ),
                SizedBox(height: media.width * 0.05),
                    // Expanded(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       const Text(
                    //         "Calories Tracker",
                    //         style: TextStyle(
                    //           color: AppColors.blackColor,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       SizedBox(height: media.width * 0.02),
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(builder: (context) => CaloriesTrackerPage()),
                    //           );
                    //         },
                    //         child: DailyPieChart(date: DateTime(2024, 1, 18)),
                    //
                    //         //DailyPieChart(date: DateTime.now()),
                    //       ),
                    //       SizedBox(height: media.width * 0.05),
                    //
                    //     ],
                    //   ),
                    // )



                SizedBox(height: media.width * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
                          icon: Icon(Icons.expand_more,
                              color: AppColors.whiteColor),
                          hint: Text("Weekly",
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
                    Text(
                      "Latest Workout",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
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
                badgeWidget: Text("20.1", style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
                ));
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

