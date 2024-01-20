import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';

class ManageFitness extends StatelessWidget {
  static String routeName = "/ManageFitness";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Fitness',),
        backgroundColor: AppColors.adminpageColor2,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {Navigator.pop(context);},
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
      ),
    );
  } // widget
} // class