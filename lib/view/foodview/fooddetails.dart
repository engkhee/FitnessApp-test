import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'fooditem.dart';
import 'ingredientdetails.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetailPage(this.foodItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${foodItem.name}'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                foodItem.image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                foodItem.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.grayColor, // Change the color to a darker color
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrayColor), // Border color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '${foodItem.description}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.grayColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayColor, // Change the color to a darker color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrayColor), // Border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${foodItem.category}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Calories:  ',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayColor, // Change the color to a darker color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrayColor), // Border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${foodItem.calories}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Fat: ',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayColor, // Change the color to a darker color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrayColor), // Border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${foodItem.fat}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Protein: ',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayColor, // Change the color to a darker color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrayColor), // Border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${foodItem.protein}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Carbohydrate:  ',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayColor, // Change the color to a darker color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrayColor), // Border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${foodItem.carbohydrate}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IngredientsPage(foodItem)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primaryColor1,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                ),
                child: const Text(
                  'Lets Cook Now',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.lightyellowColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
