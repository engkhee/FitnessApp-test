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
  final TextEditingController fatController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbohydrateController = TextEditingController();
  List<String> selectedCategories = [];
  List<String> bmiGroupsselected = [];
  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  final List<String> bmiGroups = ['Overweight', 'Normal', 'Lightweight'];
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController preparationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with original values
    nameController.text = widget.originalFoodItem.name;
    imageController.text = widget.originalFoodItem.image;
    descriptionController.text = widget.originalFoodItem.description;
    selectedCategories = widget.originalFoodItem.category.split(',');
    caloriesController.text = widget.originalFoodItem.calories.toString();
    fatController.text = widget.originalFoodItem.fat.toString();
    proteinController.text = widget.originalFoodItem.protein.toString();
    carbohydrateController.text = widget.originalFoodItem.carbohydrate.toString();
    bmiGroupsselected = widget.originalFoodItem.BMIgroup.split(',');
    ingredientsController.text = widget.originalFoodItem.ingredient.toString();
    preparationController.text = widget.originalFoodItem.preparvideo.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Meal'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name', nameController),
              _buildTextField('Image URL', imageController),
              _buildTextField('Description', descriptionController),
              _buildTextField('Calories', caloriesController, keyboardType: TextInputType.number),
              _buildTextField('Fat (g)', fatController, keyboardType: TextInputType.number),
              _buildTextField('Protein (g)', proteinController, keyboardType: TextInputType.number),
              _buildTextField('Carbohydrate (g)', carbohydrateController, keyboardType: TextInputType.number),
              _buildMultiselectDropdownField('Category', selectedCategories, categoryOptions: categories),
              const SizedBox(height: 16),
              _buildMultiselectDropdownField('BMI Group', bmiGroupsselected, categoryOptions: bmiGroups),
              const SizedBox(height: 16),
              _buildTextField('Ingredients', ingredientsController),
              const SizedBox(height: 16),
              _buildTextField('Preparation', preparationController),
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
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, List<String>? categoryOptions}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: AppColors.lightGrayColor,
        ),
        keyboardType: keyboardType,
        maxLines: null,
      ),
    );
  }

  Widget _buildMultiselectDropdownField(String labelText, List<String> selectedItems, {List<String>? categoryOptions}) {
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
                if (selectedItems.contains(newValue)) {
                  selectedItems.remove(newValue);
                } else {
                  selectedItems.add(newValue);
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
                    value: selectedItems.contains(value),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked != null) {
                          if (isChecked) {
                            selectedItems.add(value);
                          } else {
                            selectedItems.remove(value);
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
          children: selectedItems.map((item) {
            return Chip(
              label: Text(item),
              onDeleted: () {
                setState(() {
                  selectedItems.remove(item);
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
      category: selectedCategories.join(', '),
      calories: double.parse(caloriesController.text),
      fat: double.parse(fatController.text),
      protein: double.parse(proteinController.text),
      carbohydrate: double.parse(carbohydrateController.text),
      BMIgroup: bmiGroupsselected.join(', '),
      ingredient: ingredientsController.text,
      preparvideo: preparationController.text,
    );

    DatabaseHelper dbHelper = DatabaseHelper();
    // Update the database using the instance of DatabaseHelper
    await dbHelper.updateFoodItem(updatedFoodItem);
    Navigator.pop(context, updatedFoodItem);
  }
}
