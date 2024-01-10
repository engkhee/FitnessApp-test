import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';

class AddCaloriesPage extends StatefulWidget {
  const AddCaloriesPage({Key? key}) : super(key: key);

  @override
  _AddCaloriesPageState createState() => _AddCaloriesPageState();
}

class _AddCaloriesPageState extends State<AddCaloriesPage> {
  final _formKey = GlobalKey<FormState>();
  String? mealType;
  String? mealName;
  String? description;
  double? protein;
  double? carbohydrate;
  double? fat;
  double? totalCalories;
  DateTime? date;

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Meals'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: mealType,
                    onChanged: (value) {
                      setState(() {
                        mealType = value;
                      });
                    },
                    items: [
                      'Breakfast',
                      'Lunch',
                      'Dinner',
                      'Supper',
                      'Teatime',
                      'Snack',
                    ].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Meal Type: '),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Meal Name: '),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Meal Name!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      mealName = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description: '),
                    onSaved: (value) {
                      description = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Protein (g): '),
                    onSaved: (value) {
                      protein = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Carbohydrate (g): '),
                    onSaved: (value) {
                      carbohydrate = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Fat (g): '),
                    onSaved: (value) {
                      fat = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Calories: '),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Calories!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      totalCalories = double.parse(value!);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        if (_selectedDate != null) {
                          date = _selectedDate; // Update the date variable with the selected date

                          print('Meal Type: $mealType');
                          print('Meal Name: $mealName');
                          print('Description: $description');
                          print('Protein: $protein');
                          print('Carbohydrate: $carbohydrate');
                          print('Fat: $fat');
                          print('Total Calories: $totalCalories');
                          print('Date: $date');

                          // Create a Meal object and save it to the database
                          Meal meal = Meal(
                            mealType: mealType!,
                            mealName: mealName!,
                            description: description!,
                            protein: protein!,
                            carbohydrate: carbohydrate!,
                            fat: fat!,
                            totalCalories: totalCalories!,
                            date: date!,
                          );

                          // Add the await keyword to wait for the asynchronous operation to complete
                          await addMeal(meal);

                          // Provide feedback to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Meal added successfully!'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          SfCalendar(
            view: CalendarView.month,
            showNavigationArrow: true,
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.calendarCell) {
                setState(() {
                  _selectedDate = details.date!;
                  date = details.date!;
                });
              }
            },
          ),
          // Add other widgets as needed
        ],
      ),
    );
  }
}

Future<void> addMeal(Meal meal) async {
  try {
    // Get a reference to the 'meals' collection
    CollectionReference mealsCollection = FirebaseFirestore.instance.collection('meals');

    // Add the meal document
    await mealsCollection.add({
      ...meal.toMap(),
      'date': Timestamp.fromDate(meal.date), // Convert DateTime to Firestore Timestamp
    });

    print('Meal added successfully!');
  } catch (e) {
    print('Error adding meal: $e');
  }
}
