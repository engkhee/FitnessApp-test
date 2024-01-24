import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

double calculateBMI(double weightInKg, double heightInCM) {
  // BMI formula: BMI = weight (kg) / (height (m) * height (m))
  if (heightInCM > 0) {
    return weightInKg / ((heightInCM / 100) * (heightInCM / 100));
  } else {
    return 0.0;
  }
}

String getBMICategory(double bmi) {
  if (bmi < 18.5) {
    return "You are underweight";
  } else if (bmi >= 18.5 && bmi <= 24.9) {
    return "You have a normal weight";
  } else if (bmi >= 25 && bmi <= 29.9) {
    return "You are overweight";
  } else {
    return "You are in the obese range";
  }
}

List<PieChartSectionData> getBMISections(double bmi, Size media) {
  const color0 = AppColors.secondaryColor2;
  const color1 = AppColors.whiteColor;

  return [
    PieChartSectionData(
      color: color0,
      value: 33,
      title: '',
      radius: 55,
      titlePositionPercentageOffset: 0.55,
      badgeWidget: Text(
        bmi.toString(),
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    ),
    PieChartSectionData(
      color: color1,
      value: 75,
      title: '',
      radius: 42,
      titlePositionPercentageOffset: 0.55,
    ),
  ];
}

Future<Widget> buildBMIWidget(User? user, CollectionReference userProfileCollection, Size media) async {
  double? bmi;

  if (user != null) {
    DocumentSnapshot snapshot = await userProfileCollection.doc(user.uid).get();
    var userData = snapshot.data();

    if (userData != null) {
      bmi = (userData as Map<String, dynamic>)?['bmi'];
    }
  }

  if (bmi != null) {
    String bmiCategory = getBMICategory(bmi);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BMI: $bmi',
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: media.width * 0.02),
        Text(
          bmiCategory,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  } else {
    return Text('No BMI data available.');
  }
}
