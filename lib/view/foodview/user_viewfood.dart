import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/foodview/database_helper.dart';
import 'package:fitnessapp/view/foodview/fooditem.dart';
import 'package:fitnessapp/view/foodview/fooddetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/forum/like_button.dart';

enum SortingOption { Name, Calories, Favorite }

class UserFoodViewPage extends StatefulWidget {
  @override
  _UserFoodViewPageState createState() => _UserFoodViewPageState();
}

class _UserFoodViewPageState extends State<UserFoodViewPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String selectedCategory = 'All';
  SortingOption selectedSortingOption = SortingOption.Name;
  String? currentUserId;
  Map<String, List<String>> userLikes = {};
  String userBMIGroup = "Normal";
  Map<String, bool> favoriteStatusMap = {};

  @override
  void initState() {
    super.initState();
    print('Initializing state...');
    _getCurrentUser();
  }

  void _getCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUserId = user?.uid;
        print('Current user ID: $currentUserId');
        if (currentUserId != null) {
          _loadUserLikes().then((_) {
            _loadUserBMIGroup();
          });
        }
      });
    });
  }


  Future<void> _loadUserLikes() async {
    try {
      List<String> likes = await dbHelper.getUserLikes(currentUserId!);
      print('User likes loaded for $currentUserId: $likes');

      Map<String, bool> updatedFavoriteStatusMap = {};
      likes.forEach((foodItemId) {
        updatedFavoriteStatusMap[foodItemId] = true;
      });

      setState(() {
        userLikes[currentUserId!] = likes;
        favoriteStatusMap = updatedFavoriteStatusMap;
      });
    } catch (e) {
      print('Error loading user likes: $e');
    }
  }

  Future<void> _loadUserBMIGroup() async {
    try {
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

  bool _isUserFavorite(String foodItemId) {
    return favoriteStatusMap.containsKey(foodItemId) &&
        favoriteStatusMap[foodItemId]!;
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
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Text('No food items available.');
                    } else {
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
    return FutureBuilder<bool>(
      future: dbHelper.getUserLikeStatus(foodItem.id),
      builder: (context, snapshot) {
        bool isFavorite = snapshot.data ?? _isUserFavorite(foodItem.id);

        return FutureBuilder<int>(
          future: dbHelper.getLikesCount(foodItem.id),
          builder: (context, likesSnapshot) {
            int likesCount = likesSnapshot.data ?? foodItem.likes;

            if (selectedCategory == 'All' || foodItem.BMIgroup.contains(userBMIGroup)) {
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
                                  isLiked: isFavorite,
                                  onTap: () {
                                    _toggleFavorite(foodItem.id).then((_) {
                                      // Update the isFavorite variable after the toggle
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });
                                    });
                                  },
                                ),
                              Text(
                                '$likesCount',
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
          },
        );
      },
    );
  }

  Future<void> _toggleFavorite(String foodItemId) async {
    try {
      if (currentUserId != null) {
        bool isAlreadyLiked = await dbHelper.getUserLikeStatus(foodItemId);

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

          favoriteStatusMap[foodItemId] = !isAlreadyLiked;
        });

        int currentLikes = await dbHelper.getLikesCount(foodItemId);
        await dbHelper.updateLikes(foodItemId, !isAlreadyLiked, currentLikes);
      } else {
        print('Current user ID is null.');
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }
}