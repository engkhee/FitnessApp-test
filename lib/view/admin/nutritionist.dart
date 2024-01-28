import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import '../foodview/nutri_viewfood.dart';
import '../forum/main_forum.dart';
import '../login/login_screen.dart';


class NutritionistPage extends StatelessWidget {
  static String routeName = "/NutritionistPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Nutritionist Dashboard',
          style: TextStyle(
            fontSize: 22.0,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: AppColors.adminpageColor1,
        leadingWidth: 40,
        leading: TextButton(
          // onPressed: () {Navigator.pop(context);},
          onPressed: () {Navigator.pushNamed(context, LoginScreen.routeName);},
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                "assets/icons/logout.png",
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],




      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_for_nutritionistpage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child :ListView(
            children: [
              SizedBox(height: 150),
              SizedBox(
                width: 200,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, NutriFoodViewPage.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.adminpageColor1, // Background color
                      onPrimary: AppColors.blackColor, // Text color
                      elevation: 8, // Elevation (shadow)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0), // Rounded corners
                        side: BorderSide(color: AppColors.adminpageColor4), // Border color
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/icons/food_logo.png",
                          width: 150,
                          height: 150,
                        ),
                        Text(
                          'Food Center',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),

                  ),
                ),
              ),

              SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainForum()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.adminpageColor3, // Background color
                      onPrimary: AppColors.blackColor, // Text color
                      elevation: 8, // Elevation (shadow)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0), // Rounded corners
                        side: BorderSide(color: AppColors.adminpageColor4), // Border color
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Forum Center',
                          style: TextStyle(fontSize: 18),
                        ),
                        Image.asset(
                          "assets/icons/forum_logo.png",
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ] // children
        ),// Clid Column
      ),
    );
  }
}