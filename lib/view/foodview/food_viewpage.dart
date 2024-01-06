import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'database_helper.dart';
import 'fooditem.dart';
import 'nutri_addfood.dart';
import 'fooddetails.dart';

class FoodViewPage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recommend Meals",
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16), // Add some spacing if needed
            FutureBuilder<List<FoodItem>>(
              future: dbHelper.getFoodItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No food items available.');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: (snapshot.data!.length / 2).ceil(),
                      itemBuilder: (context, rowIndex) {
                        final index1 = rowIndex * 2;
                        final index2 = index1 + 1;

                        return Row(
                          children: [
                            Expanded(
                              child: index1 < snapshot.data!.length
                                  ? _buildFoodItemBox(context, snapshot.data![index1])
                                  : Container(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: index2 < snapshot.data!.length
                                  ? _buildFoodItemBox(context, snapshot.data![index2])
                                  : Container(),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Food Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFood()),
          );
        },
        backgroundColor: AppColors.primaryColor1,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildFoodItemBox(BuildContext context, FoodItem foodItem) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigate to the detailed food information page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodDetailPage(foodItem)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                foodItem.image,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodItem.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Calories: ${foodItem.calories}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


