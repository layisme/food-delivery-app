import 'package:food_delivery_app/models/food.dart';

abstract class IFoodRepository {
  Future<List<Food>> getAllFoods();
  Future<List<Food>> getFoodsByCategory(String category);
  Future<Food> getFoodById(String id);
  Future<List<Food>> searchFoods(String query);
}

class FoodRepository implements IFoodRepository {
  // Mock data - In a real app, this would call an API
  static final List<Food> _mockFoods = [
    Food(
      id: '1',
      name: 'Double Cheese',
      description: 'Stacked burger with melted cheese and signature sauce',
      price: 8.90,
      imageUrl:
          'https://www.figma.com/api/mcp/asset/4f82994e-883a-4e5f-ba67-04dac8c14fdd',
      rating: 4.8,
      reviewCount: 245,
      category: 'Burgers',
      isAvailable: true,
    ),
    Food(
      id: '2',
      name: 'Glazed Donuts',
      description: 'Soft glazed donuts with a rich chocolate finish',
      price: 4.50,
      imageUrl:
          'https://www.figma.com/api/mcp/asset/6fc088ae-4be9-4b7d-beb4-41ecf193bdab',
      rating: 4.6,
      reviewCount: 128,
      category: 'Dessert',
      isAvailable: true,
    ),
    Food(
      id: '3',
      name: 'Harvest Bowl',
      description: 'Healthy salad bowl with avocado, greens, and grains',
      price: 12.50,
      imageUrl:
          'https://www.figma.com/api/mcp/asset/6de1e99e-b35e-48f7-bd9e-87ad16b2a81e',
      rating: 4.9,
      reviewCount: 356,
      category: 'Healthy',
      isAvailable: true,
    ),
    Food(
      id: '4',
      name: 'Artisan Pizza',
      description: 'Wood-fired pizza with mozzarella, basil, and tomato',
      price: 10.99,
      imageUrl:
          'https://www.figma.com/api/mcp/asset/fb77541f-43d7-4503-8dad-f773fa014d50',
      rating: 4.6,
      reviewCount: 512,
      category: 'Pizza',
      isAvailable: true,
    ),
    Food(
      id: '5',
      name: 'Sakura Sushi',
      description: 'Fresh sushi selection from Sakura Zen',
      price: 18.99,
      imageUrl:
          'https://www.figma.com/api/mcp/asset/cc3a8e8b-c88a-44e8-8d86-6ba53eda1c34',
      rating: 4.7,
      reviewCount: 189,
      category: 'Seafood',
      isAvailable: true,
    ),
  ];

  @override
  Future<List<Food>> getAllFoods() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockFoods;
  }

  @override
  Future<List<Food>> getFoodsByCategory(String category) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockFoods
        .where((food) => food.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<Food> getFoodById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockFoods.firstWhere(
      (food) => food.id == id,
      orElse: () => throw Exception('Food not found'),
    );
  }

  @override
  Future<List<Food>> searchFoods(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    final lowerQuery = query.toLowerCase();
    return _mockFoods
        .where(
          (food) =>
              food.name.toLowerCase().contains(lowerQuery) ||
              food.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }
}
