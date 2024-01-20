import 'package:fitnessapp/view/forum/fitness/fitness_forum_screen.dart';
import 'package:fitnessapp/view/forum/food/food_forum_screen.dart';
import 'package:fitnessapp/view/forum/general/forum_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class MainForum extends StatefulWidget {
  const MainForum({Key? key}) : super(key: key);

  @override
  State<MainForum> createState() => _MainForumState();
}

class _MainForumState extends State<MainForum> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.secondaryG)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            leadingWidth: 0,
            leading: const SizedBox(),
            title: Text(
              "Discussion Forum ✎",
              style: TextStyle(
                  color: AppColors.whiteColor, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.question_answer,
                        color: Colors.white,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.accessibility,
                        color: Colors.white,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.fastfood,
                        color: Colors.white,
                      ),
                    )
                  ]
              ),

              Expanded(
                child: TabBarView(
                    children: [
                      // 1st tab
                      ForumScreen(),

                      // 2nd tab
                      FitnessForumScreen(),

                      // 3rd tab
                      FoodForumScreen(),
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
