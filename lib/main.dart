import 'package:fitnessapp/view/Traning/fitnesss_list.dart';
import 'package:fitnessapp/view/Traning/train2.dart';
import 'package:fitnessapp/view/forum/forum_screen.dart';
import 'package:fitnessapp/routes.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/auth/auth.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/profile/user_profile.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/tutorial_videos/admin_add_video.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
import 'package:fitnessapp/view/activity/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/view/firebase/firebase_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import 'view/admin/admin_page.dart';

// void main() {
//   runApp(const MyApp());
// }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FirebaseFunctions.initializeFirebase(); // Initialize Firebase
    await Firebase.initializeApp();
    runApp(MyApp());
  }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness',
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(
          primaryColor: AppColors.primaryColor1,
          useMaterial3: true,
          fontFamily: "Poppins"
      ),
      home: train2(),
        // Authpage
        //LoginScreen UserPage AddVideo
        //DashboardScreen training VideoInfo ActivityScreen
        // AdminPage
    );
  }
}