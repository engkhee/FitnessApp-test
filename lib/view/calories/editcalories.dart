import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'meal.dart';
import 'dbhelper.dart';
import 'package:intl/intl.dart';


class EditCalories extends StatefulWidget {
  final Meal originalMeal;

  const EditCalories(this.originalMeal);

  @override
  _EditCaloriesState createState() => _EditCaloriesState();
}

class _EditCaloriesState extends State<EditCalories> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? mealType;
  String? mealName;
  String? description;
  double? protein;
  double? carbohydrate;
  double? fat;
  double? totalCalories;
  DateTime? date;

  final TextEditingController _dateController = TextEditingController();
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminpageColor3,
      appBar: AppBar(
        title: Text('Edit Meal Record'),
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
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: widget.originalMeal.mealType,
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
                        labelText: 'Meal Type: ',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: widget.originalMeal.mealName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Meal Name: ',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      onSaved: (value) {
                        mealName = value;
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: widget.originalMeal.description,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Description: ',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      onSaved: (value) {
                        mealName = value;
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: widget.originalMeal.protein.toString(),
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
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: widget.originalMeal.carbohydrate.toString(),
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
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: widget.originalMeal.fat.toString(),
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
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      initialValue: widget.originalMeal.totalCalories.toString(),
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
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightorangeColor,
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: widget.originalMeal.date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null && selectedDate != widget.originalMeal.date) {
                          setState(() {
                            _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                            date = selectedDate;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Date: ',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        date = DateTime.parse(value!);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Create a new Meal object with updated calorie information
                        Meal updatedMeal = Meal(
                          id: widget.originalMeal.id,
                          mealType: widget.originalMeal.mealType,
                          mealName: widget.originalMeal.mealName,
                          description: widget.originalMeal.description,
                          protein: protein!,
                          carbohydrate: carbohydrate!,
                          fat: fat!,
                          totalCalories: totalCalories!,
                          date: widget.originalMeal.date,
                        );

                        // Update the meal in Firebase using DatabaseHelper
                        await _dbHelper.updateMeal(updatedMeal);

                        // Provide feedback to the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Calories updated successfully!'),
                          ),
                        );

                        // Update the UI or navigate back
                        Navigator.pop(context, widget.originalMeal.date);

                        setState(() {});
                      }
                    },
                    child: const Text('Update'),
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
