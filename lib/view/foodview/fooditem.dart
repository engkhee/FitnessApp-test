class FoodItem {
  final String id;
  final String name;
  final String image;
  final String description;
  final int calories;
  final String category;
  bool isFavorite;


  // Constructor with named parameters
  FoodItem({
    this.id='',
    required this.name,
    required this.image,
    required this.description,
    required this.calories,
    required this.category,
    this.isFavorite = false,
  });

  // Factory method to create a FoodItem from a map
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      calories: map['calories'] ?? 0,
      category: map['category'] ?? '',
      isFavorite: map['isFavorite']==1,
    );
  }

  // Method to convert FoodItem to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'calories': calories,
      'category': category,
    };
  }
}
