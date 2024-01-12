import 'package:fitnessapp/utils/app_colors.dart';
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
            // Organize meals by meal type
            Map<String, List<Meal>> mealsByType = groupMealsByType(snapshot.data!);

            // Build a list of widgets displaying meal information
            List<Widget> mealWidgets = [];

            mealsByType.forEach((mealType, meals) {
              // Choose a color for each meal type
              Color boxColor;
              if (mealType == 'Breakfast') {
                boxColor = AppColors.adminpageColor1;
              } else if (mealType == 'Lunch') {
                boxColor = AppColors.verifyNut2;
              } else if (mealType == 'Dinner') {
                boxColor = AppColors.lightyellowColor;
              }else if (mealType == 'Supper') {
                boxColor = AppColors.lightgreenColor;
              }else if (mealType == 'Teatime') {
                boxColor = AppColors.lightorangeColor;
              } else {
                // Default color
                boxColor = Colors.grey;
              }

              mealWidgets.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$mealType Meals',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        border: Border.all(color: AppColors.secondaryColor1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: meals.map((meal) {
                          return ListTile(
                            title: Text(meal.mealName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${meal.description}, Calories: ${meal.totalCalories}',
                                ),
                                Text(
                                  'Protein: ${meal.protein}, Carbohydrate: ${meal.carbohydrate}, Fat: ${meal.fat}',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  // Handle Edit action
                                  // You can navigate to the edit screen or show a dialog
                                } else if (value == 'delete') {
                                  // Handle Delete action
                                  // You can show a confirmation dialog and delete the meal if confirmed
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Edit'),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Delete'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            });

            return ListView(
              children: mealWidgets,
            );
          }
        },
      ),
    );
  }

  Map<String, List<Meal>> groupMealsByType(List<Meal> meals) {
    Map<String, List<Meal>> mealsByType = {};

    for (var meal in meals) {
      if (!mealsByType.containsKey(meal.mealType)) {
        mealsByType[meal.mealType] = [];
      }

      mealsByType[meal.mealType]!.add(meal);
    }

    return mealsByType;
  }

// Inside MealInformationWidget
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);

      Timestamp startTimestamp = Timestamp.fromDate(startDate);
      Timestamp endTimestamp = Timestamp.fromDate(endDate);

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('date', isGreaterThanOrEqualTo: startTimestamp, isLessThan: endTimestamp)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return Meal.fromMap(doc.data()!);
      }).toList();
    } catch (e) {
      print('Error getting meals for date: $e');
      return [];
    }
  }

}
