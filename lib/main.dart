import 'package:fitnessapp/routes.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/admin/admin_page.dart';
import 'package:fitnessapp/view/auth/auth.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/profile/provider.dart';
import 'package:fitnessapp/view/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/view/firebase/firebase_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseFunctions.initializeFirebase(); // Initialize Firebase
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: Authpage(),
         //LoginScreen(),
      //UserProfile(),
      //CaloriesTrackerPage(),
    );
  }
}