import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'meal.dart';
import 'dbhelper.dart';

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
  void initState() {
    super.initState();
    // Set the original date in the date controller
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.originalMeal.date);
    date = widget.originalMeal.date;

    // Print the original meal's ID
    print('Original Meal ID: ${widget.originalMeal.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminpageColor3,
      appBar: AppBar(
        title: const Text('Edit Meal Record'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDropdown('Meal Type:', widget.originalMeal.mealType),
                  _buildTextField('Meal Name:', widget.originalMeal.mealName, (value) {
                    mealName = value;
                  }),
                  _buildTextField('Description:', widget.originalMeal.description, (value) {
                    description = value;
                  }),
                  _buildTextField('Protein (g):', widget.originalMeal.protein.toString(), (value) {
                    protein = double.parse(value!);
                  }),
                  _buildTextField('Carbohydrate (g):', widget.originalMeal.carbohydrate.toString(), (value) {
                    carbohydrate = double.parse(value!);
                  }),
                  _buildTextField('Fat (g):', widget.originalMeal.fat.toString(), (value) {
                    fat = double.parse(value!);
                  }),
                  _buildTextField('Calories:', widget.originalMeal.totalCalories.toString(), (value) {
                    totalCalories = double.parse(value!);
                  }),
                  _buildDateField(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      print('Update button pressed!');

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print('Form saved!');
                        print('mealType: $mealType');
                        print('mealName: $mealName');
                        print('description: $description');
                        print('protein: $protein');
                        print('carbohydrate: $carbohydrate');
                        print('fat: $fat');
                        print('totalCalories: $totalCalories');
                        print('date: $date');

                        // Create a new Meal object with updated calorie information
                        Meal updatedMeal = Meal(
                          id: widget.originalMeal.id,
                          mealType: mealType!,
                          mealName: mealName!,
                          description: description!,
                          protein: protein!,
                          carbohydrate: carbohydrate!,
                          fat: fat!,
                          totalCalories: totalCalories!,
                          date: date!,
                        );

                        // Update logic
                        print('Updating meal...');

                        try {
                          // // Update the meal in Firebase using DatabaseHelper
                          // await _dbHelper.updateMeal(widget.originalMeal.id, updatedMeal);
                          // print('Meal updated successfully!');
                          // Check if the meal ID is not null and not empty using null-aware operators
                          if (widget.originalMeal.id?.isNotEmpty == true) {
                            // Pass the non-nullable String to the updateMeal method
                            await _dbHelper.updateMeal(widget.originalMeal.id!, updatedMeal);
                          } else {
                            print('Error: Meal ID is empty or null');
                          }

                          // Provide feedback to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calories updated successfully!'),
                            ),
                          );
                          // Update the UI or navigate back
                          Navigator.pop(context, widget.originalMeal.date);
                        } catch (e) {
                          print('Error updating meal: $e');
                          // Provide feedback to the user about the error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error updating meal: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

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

  Widget _buildDropdown(String label, String initialValue) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightorangeColor,
        border: Border.all(color: AppColors.grayColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonFormField<String>(
        value: initialValue,
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
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String? initialValue, void Function(String?)? onSaved) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightorangeColor,
        border: Border.all(color: AppColors.grayColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        initialValue: initialValue ?? '', // Provide a default value when initialValue is null
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        ),
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
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
          labelText: 'Date:',
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
    );
  }
}