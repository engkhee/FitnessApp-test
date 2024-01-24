//import 'dart:js';

import 'package:fitnessapp/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitnessapp/view/admin/Test2.dart';
import 'package:fitnessapp/view/admin/admin_page.dart';
import 'package:fitnessapp/view/admin/contact_developer.dart';
import 'package:fitnessapp/view/admin/developer_chat_room.dart';
import 'package:fitnessapp/view/admin/email_to_developer.dart';
import 'package:fitnessapp/view/admin/manage_fitness.dart';
import 'package:fitnessapp/view/admin/nutritionist.dart';
import 'package:fitnessapp/view/admin/verify_code.dart';
import 'package:fitnessapp/view/admin/verify_nutritionist.dart';
import 'package:fitnessapp/view/admin/view_database.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/finish_workout/finish_workout_screen.dart';
import 'package:fitnessapp/view/foodview/admin_viewfood.dart';
import 'package:fitnessapp/view/foodview/food_viewpage.dart';
import 'package:fitnessapp/view/foodview/nutri_viewfood.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/notification/notification_screen.dart';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:fitnessapp/view/on_boarding/start_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/signup/nutritionist_privacy_terms.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/tutorial_videos/add_video_v2.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
import 'package:fitnessapp/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:fitnessapp/view/tutorial_videos/admin_add_video.dart';
import 'package:fitnessapp/view/tutorial_videos/user_watch_video.dart';
import 'package:fitnessapp/view/tutorial_videos/create_playlist.dart';
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
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  FinishWorkoutScreen.routeName: (context) => const FinishWorkoutScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  ActivityTrackerScreen.routeName: (context) => const ActivityTrackerScreen(),
  WorkoutScheduleView.routeName: (context) => const WorkoutScheduleView(),
  AddVideo.routeName: (context) => AddVideo(),
  AddVideo2.routeName: (context) => AddVideo2(),
  UserPage.routeName: (context) => UserPage(),
  PlaylistManagementPage.routeName: (context) => PlaylistManagementPage(),
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
  Test2.routeName:(context) => Test2(),
  NutritionistPage.routeName:(context) => NutritionistPage(),
  VerifyCode.routeName:(context) => VerifyCode(),
  NutriFoodViewPage.routeName:(context) =>NutriFoodViewPage(),


};
