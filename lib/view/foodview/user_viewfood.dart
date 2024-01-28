// Import necessary packages and classes
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/foodview/database_helper.dart';
import 'package:fitnessapp/view/foodview/fooditem.dart';
import 'package:fitnessapp/view/foodview/fooddetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/forum/like_button.dart';

// Enum to represent sorting options
enum SortingOption { Name, Calories, Favorite }

// Main class for the user's food view page
class UserFoodViewPage extends StatefulWidget {
  @override
  _UserFoodViewPageState createState() => _UserFoodViewPageState();
}

// State class for the user's food view page
class _UserFoodViewPageState extends State<UserFoodViewPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String selectedCategory = 'All'; // Default category
  SortingOption selectedSortingOption = SortingOption.Name;
  String? currentUserId;
  Map<String, List<String>> userLikes = {};
  String userBMIGroup = "Normal"; // Set a default BMI group

  @override
  void initState() {
    super.initState();
    print('Initializing state...');
    _getCurrentUser();
  }

  // Method to get the current user's information
  void _getCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUserId = user?.uid;
        print('Current user ID: $currentUserId');
        if (currentUserId != null) {
          // Load user likes when the user logs in
          _loadUserLikes().then((_) {
            // After likes are loaded, build the UI
            setState(() {
              // Update any other UI state if needed
            });
          });
          // Load user BMI group
          _loadUserBMIGroup();
        }
      });
    });
  }

  // Method to load user likes from the database
  Future<void> _loadUserLikes() async {
    try {
      // Load user likes from the database
      List<String> likes = await dbHelper.getUserLikes(currentUserId!);
      print('User likes loaded for $currentUserId: $likes');

      setState(() {
        userLikes[currentUserId!] = likes;
      });
    } catch (e) {
      print('Error loading user likes: $e');
    }
  }

  // Method to load user's BMI group from the database
  Future<void> _loadUserBMIGroup() async {
    try {
      // Load user's BMI group from the database
      String? bmiGroup = await dbHelper.getUserBMIgroup();
      if (bmiGroup != null && bmiGroup.isNotEmpty) {
        setState(() {
          userBMIGroup = bmiGroup;
        });
      }
    } catch (e) {
      print('Error loading user BMI group: $e');
    }
  }

  // Method to check if a food item is the user's favorite
  bool _isUserFavorite(String foodItemId) {
    print('Checking favorite status for item $foodItemId');
    print('currentUserId: $currentUserId');
    print('userLikes: $userLikes');

    if (currentUserId != null &&
        userLikes.containsKey(currentUserId!) &&
        userLikes[currentUserId!]!.contains(foodItemId)) {
      print('Returning true');
      return true;
    } else {
      print('Returning false');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building FutureBuilder...');
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
            const SizedBox(height: 10),
            _buildCategoryFilterDropdown(),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<FoodItem>?>(
                future: dbHelper.UsergetFoodItems(userBMIGroup),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data == null || snapshot.data!.isEmpty) {
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

                      filteredItems.sort((a, b) {
                        switch (selectedSortingOption) {
                          case SortingOption.Name:
                            return a.name.compareTo(b.name);
                          case SortingOption.Calories:
                            return a.calories.compareTo(b.calories);
                          case SortingOption.Favorite:
                            bool isAFavorite = _isUserFavorite(a.id);
                            bool isBFavorite = _isUserFavorite(b.id);
                            return isAFavorite == isBFavorite ? 0 : isAFavorite
                                ? -1
                                : 1;
                        }
                      });

                      return GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return _buildFoodItemBox(
                              context, filteredItems[index]);
                        },
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the category filter dropdown
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

  // Helper method to build the sorting button
  Widget _buildSortingButton() {
    return IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        _showSortingOptions(context);
      },
    );
  }

  // Helper method to show sorting options in a modal bottom sheet
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

  // Helper method to build a food item box
  Widget _buildFoodItemBox(BuildContext context, FoodItem foodItem) {
    List<String> itemBMIgroups =
    foodItem.BMIgroup.split(',').map((group) => group.trim()).toList();

    List<String> itemCategories =
    foodItem.category.split(', ').map((category) => category.trim()).toList();

    if (selectedCategory == 'All' ||
        itemBMIgroups.contains(userBMIGroup)) {
      bool isFavorite = _isUserFavorite(foodItem.id);

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
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
                      if (currentUserId != null)
                        LikeButton(
                          isLiked: _isUserFavorite(foodItem.id),
                          onTap: () {
                            _toggleFavorite(foodItem.id);
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
      return Container();
    }
  }


  // Method to toggle the favorite status of a food item
  void _toggleFavorite(String foodItemId) async {
    if (currentUserId != null) {
      bool isAlreadyLiked = await dbHelper.getUserLikeStatus(foodItemId);

      int currentLikes = await dbHelper.getLikesCount(foodItemId);

      // Update the likes count and favorite status in the user interface
      dbHelper.updateLikes(foodItemId, !isAlreadyLiked, currentLikes);

      setState(() {
        if (userLikes.containsKey(currentUserId!)) {
          if (isAlreadyLiked) {
            userLikes[currentUserId!]!.remove(foodItemId);
          } else {
            userLikes[currentUserId!]!.add(foodItemId);
          }
        } else {
          userLikes[currentUserId!] = [foodItemId];
        }
      });
    } else {
      print('Current user ID is null.');
    }
  }
}
