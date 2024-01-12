import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'fooditem.dart';
import 'package:fitnessapp/utils/app_colors.dart';

class EditFoodItem extends StatefulWidget {
  final FoodItem originalFoodItem;

  const EditFoodItem(this.originalFoodItem);

  @override
  _EditFoodItemState createState() => _EditFoodItemState();
}

class _EditFoodItemState extends State<EditFoodItem> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  List<String> selectedCategories =[] ;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with original values
    nameController.text = widget.originalFoodItem.name;
    imageController.text = widget.originalFoodItem.image;
    descriptionController.text = widget.originalFoodItem.description;
    caloriesController.text = widget.originalFoodItem.calories.toString();
    selectedCategories = widget.originalFoodItem.category.split(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Meal'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', nameController),
            _buildTextField('Image URL', imageController),
            _buildTextField('Description', descriptionController),
            _buildTextField('Calories', caloriesController, keyboardType: TextInputType.number),
            _buildMultiselectDropdownField('Category', selectedCategories, categoryOptions: ['Breakfast', 'Lunch', 'Dinner', 'Snack']),            const SizedBox(height: 16),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateFoodItem();
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.secondaryColor1,
                onPrimary: AppColors.lightGrayColor,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, List<String>? categoryOptions}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: categoryOptions != null
          ? DropdownButtonFormField<String>(
        value: controller.text,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.text = newValue;
          }
        },
        items: categoryOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: AppColors.lightGrayColor,
        ),
      )
          : TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: AppColors.lightGrayColor,
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildMultiselectDropdownField(String labelText, List<String> selectedCategories, {List<String>? categoryOptions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText: ',
          style: const TextStyle(
            color: AppColors.grayColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                if (selectedCategories.contains(newValue)) {
                  selectedCategories.remove(newValue);
                } else {
                  selectedCategories.add(newValue);
                }
              });
            }
          },
          value: null, // DropdownButtonFormField requires a value, but we handle it in onChanged
          items: categoryOptions?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Checkbox(
                    value: selectedCategories.contains(value),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked != null) {
                          if (isChecked) {
                            selectedCategories.add(value);
                          } else {
                            selectedCategories.remove(value);
                          }
                        }
                      });
                    },
                  ),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: selectedCategories.map((category) {
            return Chip(
              label: Text(category),
              onDeleted: () {
                setState(() {
                  selectedCategories.remove(category);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _updateFoodItem() async {
    // Validate the input (you may want to add more validation logic)
    if (nameController.text.isEmpty || caloriesController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    // Create an updated FoodItem object
    FoodItem updatedFoodItem = FoodItem(
      id: widget.originalFoodItem.id,
      name: nameController.text,
      image: imageController.text,
      description: descriptionController.text,
      calories: int.parse(caloriesController.text),
      category: selectedCategories.join(', ') ,
    );

    DatabaseHelper dbHelper = DatabaseHelper();
    // Update the database using the instance of DatabaseHelper
    await dbHelper.updateFoodItem(updatedFoodItem);
    Navigator.pop(context, updatedFoodItem);
  }
}
