import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import '../admin/register_user.dart';
import '../login/login_screen.dart';
import 'auth_service.dart';


class RegisterPage extends StatelessWidget {
  static String routeName = "/RegisterPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registeration Counter',
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
            image: AssetImage("assets/images/background_for_nutritionistpage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child :ListView(
            children: [
              SizedBox(height: 120),
              Text(
                'Do you want to register as a...?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.adminpageColor4, // Choose a color that fits your design
                  letterSpacing: 1.2,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),
              SizedBox(
                width: 200,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
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
                        Image.asset(
                          "assets/icons/user_icon.png",
                          width: 150,
                          height: 150,
                        ),
                        Text(
                          'User',
                          style: TextStyle(fontSize: 25),
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
                      Navigator.pushNamed(context, AuthService.routeName);
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
                          'Nutritionist',
                          style: TextStyle(fontSize: 25),
                        ),
                        Image.asset(
                          "assets/icons/user_icon.png",
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

