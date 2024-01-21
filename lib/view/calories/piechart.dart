import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'meal.dart';
import 'dbhelper.dart';

class DailyPieChart extends StatelessWidget {
  final DateTime date;
  final DatabaseHelper dbHelper = DatabaseHelper();

  DailyPieChart({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color:AppColors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Daily Nutrition',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          FutureBuilder<List<Meal>>(
            future: dbHelper.getMealsForDate(date),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Column(
                  children: [
                    Text(
                      'No data available for this date.',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Record Now ',
                          style: TextStyle(
                            color: AppColors.midGrayColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          '😊',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                double totalProtein = snapshot.data!.map((meal) => meal.protein).reduce((a, b) => a + b);
                double totalCarbohydrate = snapshot.data!.map((meal) => meal.carbohydrate).reduce((a, b) => a + b);
                double totalFat = snapshot.data!.map((meal) => meal.fat).reduce((a, b) => a + b);
                double totalCalories = calculateTotalCalories(snapshot.data!);

                return Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: PieChart(
                              PieChartData(
                                sections: _getSections(totalProtein, totalCarbohydrate, totalFat),
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
                                _buildColorBox('Protein', AppColors.protein),
                                _buildColorBox('Carbs', AppColors.verifyNut3),
                                _buildColorBox('Fat', AppColors.lightyellowColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Calories: $totalCalories',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  List<PieChartSectionData> _getSections(double totalProtein, double totalCarbohydrate, double totalFat) {
    return [
      PieChartSectionData(
        color: AppColors.protein,
        value: totalProtein,
        title: '${((totalProtein / (totalProtein + totalCarbohydrate + totalFat)) * 100).toStringAsFixed(2)}%',
        radius: 30,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.black),
      ),
      PieChartSectionData(
        color: AppColors.verifyNut3,
        value: totalCarbohydrate,
        title: '${((totalCarbohydrate / (totalProtein + totalCarbohydrate + totalFat)) * 100).toStringAsFixed(2)}%',
        radius: 30,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.black),
      ),
      PieChartSectionData(
        color: AppColors.lightyellowColor,
        value: totalFat,
        title: '${((totalFat / (totalProtein + totalCarbohydrate + totalFat)) * 100).toStringAsFixed(2)}%',
        radius: 30,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.black),
      ),
    ];
  }

  Widget _buildColorBox(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
