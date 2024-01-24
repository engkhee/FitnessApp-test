import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'database_helper.dart';
import 'fooditem.dart';
import 'nutri_addfood.dart';
import 'fooddetails.dart';
import 'editfooditem.dart';

class NutriFoodViewPage extends StatefulWidget {
  static String routeName = "/NutriFoodViewPage";
  @override
  _FoodViewPageState createState() => _FoodViewPageState();
}

class _FoodViewPageState extends State<NutriFoodViewPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text(' '),
        backgroundColor: AppColors.primaryColor1,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
              });
            },
          ),
        ],
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
                                  ? _buildFoodItemBox(
                                  context, snapshot.data![index1])
                                  : Container(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: index2 < snapshot.data!.length
                                  ? _buildFoodItemBox(
                                  context, snapshot.data![index2])
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
        onPressed: () async {
          // Navigate to the Add Food Page
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFood()),
          );

          // Check if result is true (added successfully)
          if (result == true) {
            // Refresh the data
            setState(() {});
          }
        },
        backgroundColor: AppColors.primaryColor1,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          child: Stack(
            children: [
              Column(
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
              // Kebab menu button for deletion
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteFoodItem(context, foodItem);
                    } else if (value=='edit'){
                      _editFoodItem(context,foodItem);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                    ),

                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
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

  void _editFoodItem(BuildContext context, FoodItem foodItem) {
    // Navigate to the Edit Food Item Page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditFoodItem(foodItem)),
    );
  }


  void _deleteFoodItem(BuildContext context, FoodItem foodItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Food Item'),
          content: const Text(
              'Are you sure you want to delete this food item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform the deletion
                await dbHelper.deleteFoodItem(foodItem.id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
