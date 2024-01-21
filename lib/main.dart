import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/Traning/fitnesss_list.dart';
import 'package:fitnessapp/routes.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitnessapp/view/admin/manage_fitness.dart';
import 'package:fitnessapp/view/auth/auth.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/forum/main_forum.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:fitnessapp/view/on_boarding/start_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/profile/update_profile_page.dart';
import 'package:fitnessapp/view/profile/user_profile.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/view/firebase/firebase_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import'package:fitnessapp/view/foodview/nutri_viewfood.dart';
import'package:fitnessapp/view/foodview/admin_viewfood.dart';
import'package:fitnessapp/view/calories/caloriestracker.dart';
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
      home: DashboardScreen(),
      //LoginScreen
      //DashboardScreen  ActivityScreen
      // AdminPage
      // FoodViewPage(),
      //CaloriesTrackerPage(),
    );
  }
}