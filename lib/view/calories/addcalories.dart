import 'package:flutter/material.dart';
import 'meal.dart';
import 'dbhelper.dart';

class AddCaloriesPage extends StatefulWidget {
  const AddCaloriesPage({Key? key, required this.selectedDate}) : super(key: key);

  final DateTime selectedDate;

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

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Meals'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButtonFormField<String>(
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
                      decoration: const InputDecoration(
                        labelText: 'Meal Type:',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: 'Roti Canai',
                      decoration: const InputDecoration(
                        labelText: 'Meal Name:',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
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
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: '2 slices',
                      decoration: const InputDecoration(
                        labelText: 'Description:',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      onSaved: (value) {
                        description = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Protein (g):',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      onSaved: (value) {
                        protein = double.parse(value!);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Carbohydrate (g):',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      onSaved: (value) {
                        carbohydrate = double.parse(value!);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Fat (g):',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      onSaved: (value) {
                        fat = double.parse(value!);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Calories:',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
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
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        if (widget.selectedDate != null) {
                          // Create a Meal object
                          Meal meal = Meal(
                            mealType: mealType!,
                            mealName: mealName!,
                            description: description!,
                            protein: protein!,
                            carbohydrate: carbohydrate!,
                            fat: fat!,
                            totalCalories: totalCalories!,
                            date: widget.selectedDate,
                          );

                          // Add the meal to Firebase using DatabaseHelper
                          await _dbHelper.insertMeal(meal);

                          // Provide feedback to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Meal added successfully!'),
                            ),
                          );

                          // Update the UI or navigate back
                          Navigator.pop(context, widget.selectedDate);

                          setState(() {});
                        }
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}