import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import '../../common_widgets/round_button.dart';
import 'database_helper.dart';
import 'fooditem.dart';

class AddFood extends StatefulWidget {
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final PageController _pageController = PageController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
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

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
        backgroundColor: AppColors.secondaryColor1,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable swipe gesture
        children: [
          _buildPageOne(),
          _buildPageTwo(),
          _buildPageThree(),
        ],
      ),
    );
  }


  Widget _buildPageOne() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField('Meal Name', nameController),
            const SizedBox(height: 12),
            const Text(
              'Description:',
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildInputField('Image URL', imageController),
            const SizedBox(height: 12),
            _buildDropdownField('Category', selectedCategories, categories),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: RoundButton(
                title: 'Next',
                onPressed: () {
                  _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  setState(() {
                    _currentPage = 1;
                  });
                },
                type: RoundButtonType.primaryBG,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTwo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField('Calories', caloriesController),
            const SizedBox(height: 12),
            _buildInputField('Fat (g)', fatController),
            const SizedBox(height: 12),
            _buildInputField('Protein (g)', proteinController),
            const SizedBox(height: 12),
            _buildInputField('Carbohydrate (g)', carbohydrateController),
            const SizedBox(height: 12),
            _buildDropdownField('Suitable for BMI Group', bmiGroupsselected, bmiGroups),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RoundButton(
                    title: 'Back',
                    onPressed: () {
                      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      setState(() {
                        _currentPage = 0;
                      });
                    },
                    type: RoundButtonType.primaryBG,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundButton(
                    title: 'Next',
                    onPressed: () {
                      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      setState(() {
                        _currentPage = 2;
                      });
                    },
                    type: RoundButtonType.primaryBG,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageThree() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients:',
              style: const TextStyle(
                color: AppColors.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ingredientsController,
              maxLines: null,  // Allow multiple lines
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Preparation Video Link:',
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: preparationController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RoundButton(
                    title: 'Back',
                    onPressed: () {
                      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      setState(() {
                        _currentPage = 1;
                      });
                    },
                    type: RoundButtonType.primaryBG,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundButton(
                    title: 'Submit',
                    onPressed: () {
                      _addFoodItem(context);
                    },
                    type: RoundButtonType.primaryBG,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String labelText, TextEditingController controller) {
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

  Widget _buildDropdownField(String labelText, List<String> selectedItems, List<String> items) {
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
            if (newValue != null && !selectedItems.contains(newValue)) {
              setState(() {
                selectedItems.add(newValue);
              });
            }
          },
          value: selectedItems.isNotEmpty ? selectedItems.last : null,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
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

  void _addFoodItem(BuildContext context) async {
    final String name = nameController.text;

    if (name.isNotEmpty) {
      try {
        await DatabaseHelper().insertFoodItem(
          FoodItem(
            name: name,
            image: imageController.text,
            description: descriptionController.text,
            category: selectedCategories.join(', '), // Combine selected categories into a string
            calories: double.tryParse(caloriesController.text) ?? 0.0,
            fat: double.tryParse(fatController.text) ?? 0.0,
            protein: double.tryParse(proteinController.text) ?? 0.0,
            carbohydrate: double.tryParse(carbohydrateController.text) ?? 0.0,
            BMIgroup: bmiGroupsselected.join(', '),
            ingredient: ingredientsController.text,
            preparvideo: preparationController.text,
          ),
        );

        // Clear the text fields after adding
        nameController.clear();
        descriptionController.clear();
        imageController.clear();
        caloriesController.clear();
        selectedCategories.clear();
        fatController.clear();
        proteinController.clear();
        carbohydrateController.clear();
        bmiGroupsselected.clear();
        preparationController.clear();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meal added successfully!'),
        ));

        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });

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
