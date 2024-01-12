import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';

class DailyPieChart extends StatelessWidget {
  final DateTime? date;

  DailyPieChart({required this.date});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meal>>(
      future: getMealsForDate(date),
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

          return Column(
            children: [
              PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: totalProtein,
                      title: 'Protein',
                      radius: 50,
                      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: totalCarbohydrate,
                      title: 'Carbs',
                      radius: 50,
                      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: totalFat,
                      title: 'Fat',
                      radius: 50,
                      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 0,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Total Calories: ${calculateTotalCalories(snapshot.data!)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }
      },
    );
  }

  double calculateTotalCalories(List<Meal> meals) {
    return meals.map((meal) => meal.totalCalories).reduce((a, b) => a + b);
  }

  Future<List<Meal>> getMealsForDate(DateTime? date) async {
    try {
      if (date != null) {
        DateTime startDate = DateTime(date.year, date.month, date.day);
        DateTime endDate = DateTime(date.year, date.month, date.day + 1);

        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('meals')
            .where('date', isGreaterThanOrEqualTo: startDate, isLessThan: endDate)
            .get() as QuerySnapshot<Map<String, dynamic>>;

        return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Meal(
            mealType: doc['mealType'],
            mealName: doc['mealName'],
            description: doc['description'],
            protein: doc['protein'],
            carbohydrate: doc['carbohydrate'],
            fat: doc['fat'],
            totalCalories: doc['totalCalories'],
            date: DateTime.parse(doc['date']),
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting meals for date: $e');
      return [];
    }
  }
}
