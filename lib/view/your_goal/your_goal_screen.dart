import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/activity/activity_screen.dart';
import 'package:fitnessapp/view/your_goal/widget/selectedGoal.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/round_gradient_button.dart';

class YourGoalScreen extends StatefulWidget {
  static String routeName = "/YourGoalScreen";

  const YourGoalScreen({Key? key}) : super(key: key);

  @override
  State<YourGoalScreen> createState() => _YourGoalScreenState();
}

class _YourGoalScreenState extends State<YourGoalScreen> {
  List pageList = [
    {
      "id": "1",
      "title": "Arms & Shoulder",
      "subtitle": "Sculpt Your Upper Body Strength",
      "image": "assets/images/goal_1.png",
    },
    {
      "id": "2",
      "title": "Chest & Back",
      "subtitle": "Build a Powerful Torso",
      "image": "assets/images/goal_2.png",
    },
    {
      "id": "3",
      "title": "Abs",
      "subtitle": "Define Your Core, Unleash Your Power",
      "image": "assets/images/goal_3.png",
    },
    {
      "id": "4",
      "title": "Glutes & Legs",
      "subtitle": "Shape Your Lower Body for Strength and Stamina",
      "image": "assets/images/welcome_promo.png",
    }
  ];
  CarouselController carouselController = CarouselController();
  int selectedPageIndex = 0; // Variable to store the selected page index

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: CarouselSlider(
                items: pageList.map((obj) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: AppColors.primaryG,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: media.width * 0.01,
                    horizontal: 25,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          obj["image"],
                          width: media.width * 0.5,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(height: media.width * 0.02),
                        Text(
                          obj["title"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: media.width * 0.01),
                        Container(
                          width: 50,
                          height: 1,
                          color: AppColors.lightGrayColor,
                        ),
                        SizedBox(height: media.width * 0.02),
                        Text(
                          obj["subtitle"],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 3,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
                    .toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 0.74,
                  initialPage: 0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      selectedPageIndex = index; // Update the selected page index
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: media.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "What is your goal ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "It will help us to choose a best\nprogram for you",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const Spacer(),
                    SizedBox(height: media.width * 0.05),
                    RoundGradientButton(
                      title: "Confirm",
                      onPressed: () {
                        var selectedId = pageList[selectedPageIndex]['id'];
                        print("Selected Goal ID: $selectedId");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                selectedGoal(selectedGoalId: selectedId),
                          ),
                        );

                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
