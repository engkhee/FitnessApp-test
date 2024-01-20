class FoodItem {
  final String id;
  final String name;
  final String image;
  final String description;
  final String category;
  final double calories;
  final double fat;
  final double protein;
  final double carbohydrate;
  final String BMIgroup;
  final String ingredient;
  final String preparvideo;
  bool isFavorite;
  int likes;


  // Constructor with named parameters
  FoodItem({
    this.id='',
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.calories,
    required this.fat,
    required this.protein,
    required this.carbohydrate,
    required this.BMIgroup,
    required this.ingredient,
    required this.preparvideo,
    this.isFavorite = false,
    this.likes=0,
  });

  // Factory method to create a FoodItem from a map
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      calories: map['calories'] ?? 0.0,
      fat: map['fat'] ?? 0.0,
      protein: map['protein'] ?? 0.0,
      carbohydrate: map['carbohydrate'] ?? 0.0,
      BMIgroup: map['BMIgroup'] ?? '',
      ingredient: map['ingredient'] ?? '',
      preparvideo: map['preparvideo'] ?? '',
      isFavorite: map['isFavorite']==true ,
      likes: map['likes'] ?? 0,
    );
  }

  // Method to convert FoodItem to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'category': category,
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'BMIgroup': BMIgroup,
      'ingredient': ingredient,
      'preparvideo':preparvideo,
      'isFavorite':isFavorite,
      'likes':likes,
    };
  }
}