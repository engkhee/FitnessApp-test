import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';

class MealInformationWidget extends StatelessWidget {
  final DateTime selectedDate;

  MealInformationWidget({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Meal>>(
        future: getMealsForDate(selectedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No meal information available for this date.'),
            );
          } else {
            // Build a list of widgets displaying meal information
            List<Widget> mealWidgets = snapshot.data!.map((meal) {
              return ListTile(
                title: Text(meal.mealName),
                subtitle: Text('Type: ${meal.mealType}, Calories: ${meal.totalCalories}'),
              );
            }).toList();

            return ListView(
              children: mealWidgets,
            );
          }
        },
      ),
    );
  }

  Future<List<Meal>> getMealsForDate(DateTime date) async {
    try {
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
    } catch (e) {
      print('Error getting meals for date: $e');
      return [];
    }
  }
}
