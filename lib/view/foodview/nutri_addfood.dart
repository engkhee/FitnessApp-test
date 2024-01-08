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
  final FocusNode nameFocusNode = FocusNode();
  String selectedCategory = 'Breakfast'; // Default category

  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
        backgroundColor: AppColors.secondaryColor1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField('Meal Name', nameController, nameFocusNode),
              const SizedBox(height: 12),
              _buildInputField('Description', descriptionController, null),
              const SizedBox(height: 12),
              _buildInputField('Image URL', imageController, null),
              const SizedBox(height: 12),
              _buildDropdownField('Category', selectedCategory),
              const SizedBox(height: 12),
              _buildInputField('Calories', caloriesController, null),
              const SizedBox(height: 12),
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
      ),
    );
  }

  Widget _buildInputField(String labelText, TextEditingController controller, FocusNode? focusNode) {
    return Row(
      children: [
        Text(
          '$labelText: ',
          style: const TextStyle(
            color: AppColors.grayColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.secondaryColor1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String labelText, String value) {
    return Row(
      children: [
        Text(
          '$labelText: ',
          style: const TextStyle(
            color: AppColors.grayColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: value,
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
