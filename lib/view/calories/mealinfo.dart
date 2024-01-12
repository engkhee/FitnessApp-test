import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';
import 'dbhelper.dart';
import 'editcalories.dart';

class MealInformationWidget extends StatelessWidget {
  final DateTime selectedDate;
  final DatabaseHelper dbHelper = DatabaseHelper();

  MealInformationWidget({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Meal>>(
        future: dbHelper.getMealsForDate(selectedDate),
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
              } else if (mealType == 'Supper') {
                boxColor = AppColors.lightgreenColor;
              } else if (mealType == 'Teatime') {
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
                                  editMeal(context, meal);
                                } else if (value == 'delete') {
                                  deleteMeal(context, meal);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                              [
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

  void editMeal (BuildContext context, Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditCalories(meal)),
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

  void deleteMeal(BuildContext context, Meal meal) {
    print('Deleting meal with ID: ${meal.id}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Food Item'),
          content: const Text(
            'Are you sure you want to delete this meal record?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Print debug information
                print('Deleting meal with ID: ${meal.id}');
                // Perform the deletion using dbHelper
                await dbHelper.deleteMeal(meal.id);
                print('Meal deleted successfully.');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
