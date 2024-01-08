import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'fooditem.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetailPage(this.foodItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Detail: ${foodItem.name}'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              foodItem.image,
              width: double.infinity,
              height: 200,
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
            Text(
              'Description: ${foodItem.description}',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.grayColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${foodItem.category}',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.grayColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Calories: ${foodItem.calories}',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.grayColor,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
