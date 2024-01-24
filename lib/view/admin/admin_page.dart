import 'dart:ui';
import 'package:fitnessapp/view/admin/contact_developer.dart';
import 'package:fitnessapp/view/admin/manage_fitness.dart';
import 'package:fitnessapp/view/admin/verify_nutritionist.dart';
import 'package:fitnessapp/view/admin/view_database.dart';
import 'package:fitnessapp/view/forum/main_forum.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import '../foodview/admin_viewfood.dart';
import '../login/login_screen.dart';

class AdminPage extends StatelessWidget {
  static String routeName = "/AdminPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.adminpageColor1,
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
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
      ),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/background_for_adminpage.png"),
        fit: BoxFit.cover,
      ),
    ),
      child :ListView(
          children: [
            SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, NutritionistList.routeName);
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
                      "assets/icons/verify_logo.png",
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Verify Nutritionist',
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
                  Navigator.pushNamed(context, ViewDatabase.routeName);
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
                      'View Database',
                      style: TextStyle(fontSize: 18),
                    ),
                    Image.asset(
                      "assets/icons/database_logo.png",
                      width: 150,
                      height: 150,
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
                  // Navigator.pushNamed(context, ContactDeveloper.routeName);
                  Navigator.pushNamed(context, ContactDeveloper.routeName);

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
                      "assets/icons/contact_logo.png",
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Contact Developer',
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
                  Navigator.pushNamed(context, ManageFitness.routeName);
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
                      'Manage Fitness',
                      style: TextStyle(fontSize: 18),
                    ),
                    Image.asset(
                      "assets/icons/fitness_logo.png",
                      width: 150,
                      height: 150,
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
                    Navigator.pushNamed(context, AdminFoodViewPage.routeName);
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
                        'View Food List',
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
                        'Manage Forum',
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
  } // widget
} // class



