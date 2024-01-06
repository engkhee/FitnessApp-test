import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import '../../common_widgets/round_button.dart';
import 'database_helper.dart';
import 'fooditem.dart';

class AddFood extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  String selectedCategory = 'Breakfast'; // Default category

  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
        backgroundColor: AppColors.secondaryColor1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text(
                  'Meal Name: ',
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondaryColor1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Description: ',
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 3, // Allowing for 3 lines in the description
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondaryColor1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Image URL: ',
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondaryColor1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Category: ',
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedCategory = newValue;
                    }
                  },
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Calories: ',
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondaryColor1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            RoundButton(
              title: 'Add Meal',
              onPressed: () {
                _addFoodItem(context);
              },
              type: RoundButtonType.primaryBG,
            ),
          ],
        ),
      ),
    );
  }

  void _addFoodItem(BuildContext context) async {
    final String name = nameController.text;

    if (name.isNotEmpty) {
      try {
        await DatabaseHelper().insertFoodItem(
          FoodItem(
            name: name,
            image: imageController.text,
            description: descriptionController.text,
            calories: int.tryParse(caloriesController.text) ?? 0,
            category: selectedCategory,
          ),
        );

        // Clear the text fields after adding
        nameController.clear();
        descriptionController.clear();
        imageController.clear();
        caloriesController.clear();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meal added successfully!'),
        ));

        // Navigate back to FoodViewPage
        Navigator.pop(context);

      } catch (e) {
        print('Error adding food item: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred while adding the meal.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter the meal name.'),
      ));
    }
  }
}
