//import 'dart:js';

import 'package:fitnessapp/view/admin/admin_page.dart';
import 'package:fitnessapp/view/admin/contact_developer.dart';
import 'package:fitnessapp/view/admin/developer_chat_room.dart';
import 'package:fitnessapp/view/admin/manage_fitness.dart';
import 'package:fitnessapp/view/admin/nutritionist.dart';
import 'package:fitnessapp/view/admin/verify_code.dart';
import 'package:fitnessapp/view/admin/verify_nutritionist.dart';
import 'package:fitnessapp/view/admin/view_database.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/foodview/admin_viewfood.dart';
import 'package:fitnessapp/view/foodview/nutri_viewfood.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/notification/notification_screen.dart';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:fitnessapp/view/on_boarding/start_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/signup/nutritionist_privacy_terms.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/tutorial_videos/add_exercise_tuto.dart';
import 'package:fitnessapp/view/tutorial_videos/add_video_v2.dart';
import 'package:fitnessapp/view/tutorial_videos/dance_workout.dart';
import 'package:fitnessapp/view/tutorial_videos/exercise_tuto.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:fitnessapp/view/tutorial_videos/admin_add_video.dart';
import 'package:fitnessapp/view/tutorial_videos/user_watch_video.dart';
import 'package:fitnessapp/view/signup/auth_service.dart';
import 'package:fitnessapp/view/Traning/training_home.dart';
import 'package:flutter/cupertino.dart';


final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  StartScreen.routeName: (context) => const StartScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  YourGoalScreen.routeName: (context) => const YourGoalScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  AddVideo.routeName: (context) => AddVideo(),
  AddVideo2.routeName: (context) => AddVideo2(),
  AddVideo3.routeName: (context) => AddVideo3(),
  UserPage.routeName: (context) => UserPage(),
  DanceWorkout.routeName: (context) => DanceWorkout(),
  ExerciseTutos.routeName: (context) => ExerciseTutos(),
  AuthService.routeName:(context) => AuthService(),
  training.routeName:(context) => training(),
  AdminPage.routeName: (context) => AdminPage(),
  NutritionistList.routeName: (context) => NutritionistList(),
  ViewDatabase.routeName: (context) => ViewDatabase(),
  ContactDeveloper.routeName: (context) => ContactDeveloper(),
  DeveloperChatRoom.routeName:(context) => DeveloperChatRoom(),
  ManageFitness.routeName:(context) => ManageFitness(),
  NutritionistTermsConditionsScreen.routeName:(context) => NutritionistTermsConditionsScreen(),
  AdminFoodViewPage.routeName:(context) => AdminFoodViewPage(),
  NutritionistPage.routeName:(context) => NutritionistPage(),
  VerifyCode.routeName:(context) => VerifyCode(),
  NutriFoodViewPage.routeName:(context) =>NutriFoodViewPage(),
};
