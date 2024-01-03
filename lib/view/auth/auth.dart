import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:flutter/material.dart';

class Authpage extends StatelessWidget{
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData){
            return const DashboardScreen();
          }
          // user is NOT logged in
          else{
            return const LoginScreen();
          }
        },
      ),
    );
  }
}