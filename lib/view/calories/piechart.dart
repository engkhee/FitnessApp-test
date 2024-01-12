import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';
import 'dbhelper.dart';

class DailyPieChart extends StatelessWidget {
  final DateTime date;
  final DatabaseHelper dbHelper = DatabaseHelper();

  DailyPieChart({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Daily Nutrition',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          FutureBuilder<List<Meal>>(
            future: dbHelper.getMealsForDate(date),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data available for this date.');
              } else {
                // Calculate total protein, carbohydrate, fat, and calories for the day
                double totalProtein = snapshot.data!.map((meal) => meal.protein).reduce((a, b) => a + b);
                double totalCarbohydrate = snapshot.data!.map((meal) => meal.carbohydrate).reduce((a, b) => a + b);
                double totalFat = snapshot.data!.map((meal) => meal.fat).reduce((a, b) => a + b);
                double totalCalories = calculateTotalCalories(snapshot.data!);

                return Column(
                  children: [
                    SizedBox(
                      height: 150, // Set the desired height
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    color: AppColors.primaryColor1,
                                    value: totalProtein,
                                    title: 'Protein',
                                    radius: 30,
                                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.black),
                                  ),
                                  PieChartSectionData(
                                    color: AppColors.verifyNut3,
                                    value: totalCarbohydrate,
                                    title: 'Carbs',
                                    radius: 30,
                                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.black),
                                  ),
                                  PieChartSectionData(
                                    color: AppColors.lightyellowColor,
                                    value: totalFat,
                                    title: 'Fat',
                                    radius: 30,
                                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.black),
                                  ),
                                ],
                                centerSpaceRadius: 20,
                                sectionsSpace: 0,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildColorBox(AppColors.primaryColor1, totalProtein / totalCalories),
                                _buildColorBox(AppColors.verifyNut3, totalCarbohydrate / totalCalories),
                                _buildColorBox(AppColors.lightyellowColor, totalFat / totalCalories),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Calories: $totalCalories',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  double calculateTotalCalories(List<Meal> meals) {
    return meals.map((meal) => meal.totalCalories).reduce((a, b) => a + b);
  }

  Widget _buildColorBox(Color color, double percentage) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text('${(percentage * 100).toStringAsFixed(2)}%'),
      ],
    );
  }
}
