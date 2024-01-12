import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/foodview/database_helper.dart';
import 'package:fitnessapp/view/foodview/fooditem.dart';
import 'package:fitnessapp/view/foodview/fooddetails.dart';

class UserFoodViewPage extends StatefulWidget {
  @override
  _UserFoodViewPageState createState() => _UserFoodViewPageState();
}

enum SortingOption { Name, Calories, Favorite }

class _UserFoodViewPageState extends State<UserFoodViewPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String selectedCategory = 'All'; // Default category
  SortingOption selectedSortingOption = SortingOption.Name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recommend Meals",
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryColor1,
        actions: [
          _buildSortingButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Add some spacing if needed
            _buildCategoryFilterDropdown(),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<FoodItem>>(
                future: dbHelper.getFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No food items available.');
                  } else {
                    // Filter and sort the items
                    List<FoodItem> filteredItems = snapshot.data!;
                    if (selectedCategory != 'All') {
                      filteredItems = filteredItems
                          .where((foodItem) =>
                          foodItem.category.contains(selectedCategory))
                          .toList();
                    }

                    // Sort the items based on the selected sorting option
                    filteredItems.sort((a, b) {
                      switch (selectedSortingOption) {
                        case SortingOption.Name:
                          return a.name.compareTo(b.name);
                        case SortingOption.Calories:
                          return a.calories.compareTo(b.calories);
                        case SortingOption.Favorite:
                          return a.isFavorite ? -1 : 1;
                      }
                    });

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.75, // Adjust the aspect ratio as needed
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildFoodItemBox(
                            context, filteredItems[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterDropdown() {
    return Row(
      children: [
        const Text(
          'Filter by Category: ',
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
              setState(() {
                selectedCategory = newValue;
              });
            }
          },
          items: ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortingButton() {
    return IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        _showSortingOptions(context);
      },
    );
  }

  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Sort by Meals Name'),
                onTap: () {
                  setState(() {
                    selectedSortingOption = SortingOption.Name;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Sort by Calories'),
                onTap: () {
                  setState(() {
                    selectedSortingOption = SortingOption.Calories;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Sort by Favorite'),
                onTap: () {
                  setState(() {
                    selectedSortingOption = SortingOption.Favorite;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodItemBox(BuildContext context, FoodItem foodItem) {
    List<String> itemCategories =
    foodItem.category.split(', ').map((category) => category.trim()).toList();

    // Check if the selected category is 'All' or if the food item contains any of the selected categories
    if (selectedCategory == 'All' || itemCategories.contains(selectedCategory)) {
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          foodItem.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: foodItem.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          _toggleFavorite(foodItem);
                        },
                      ),
                      Text(
                        '${foodItem.likes}',
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
    } else {
      // If the item doesn't match the selected categories, return an empty container
      return Container();
    }
  }

  void _toggleFavorite(FoodItem foodItem) async {
    // Toggle the 'isFavorite' status in Firestore
    dbHelper.updateFavoriteStatus(foodItem.id, !foodItem.isFavorite);

    // Update the UI to reflect the new 'isFavorite' status
    setState(() {
      foodItem.isFavorite = !foodItem.isFavorite;
      foodItem.likes += foodItem.isFavorite ? 1 : -1;
    });

    await dbHelper.updateLikes(foodItem.id, foodItem.isFavorite, foodItem.likes);
  }
}
