import 'package:flutter/material.dart';
import 'package:fitnessapp/view/forum/fitness/fitness_forum_screen.dart';
import 'package:fitnessapp/view/forum/food/food_forum_screen.dart';
import 'package:fitnessapp/view/forum/general/forum_screen.dart';
import '../../utils/app_colors.dart';

class MainForum extends StatefulWidget {
  static String routeName = "/MainForum";
  const MainForum({Key? key}) : super(key: key);

  @override
  State<MainForum> createState() => _MainForumState();
}

class _MainForumState extends State<MainForum> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color appBarColor = AppColors.lightblueColor; // Default color for AppBar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            appBarColor = AppColors.lightblueColor;
            break;
          case 1:
            appBarColor = AppColors.lightgreenColor;
            break;
          case 2:
            appBarColor = AppColors.lightorangeColor;
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.secondaryG),
      ),
      child: Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 0,
          leading: const SizedBox(),
          title: Text(
            "Discussion Forum ✎",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.5,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Colors.grey,
                  offset: Offset(0, 0.8),
                  blurRadius: 1.2,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
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
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 1st tab
                  ForumScreen(),
                  // 2nd tab
                  FitnessForumScreen(),
                  // 3rd tab
                  FoodForumScreen(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
