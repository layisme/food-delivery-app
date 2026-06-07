import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food.dart';
import 'package:food_delivery_app/repositories/food_repository.dart';

class HomeProvider extends ChangeNotifier {
  final IFoodRepository _foodRepository;

  HomeProvider({IFoodRepository? foodRepository})
      : _foodRepository = foodRepository ?? FoodRepository();

  // State variables
  List<Food> _foods = [];
  List<Food> _filteredFoods = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Getters
  List<Food> get foods => _foods;
  List<Food> get filteredFoods => _filteredFoods;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Initialize and fetch all foods
  Future<void> fetchAllFoods() async {
    _setLoading(true);
    try {
      _foods = await _foodRepository.getAllFoods();
      _filteredFoods = _foods;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch foods: ${e.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Filter foods by category
  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _setLoading(true);
    try {
      if (category == 'All') {
        _filteredFoods = _foods;
      } else {
        _filteredFoods = await _foodRepository.getFoodsByCategory(category);
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to filter foods: ${e.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Search foods by query
  Future<void> searchFoods(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredFoods = _foods;
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _filteredFoods = await _foodRepository.searchFoods(query);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to search foods: ${e.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Get a specific food item
  Future<Food> getFoodById(String id) async {
    try {
      return await _foodRepository.getFoodById(id);
    } catch (e) {
      throw Exception('Failed to get food: ${e.toString()}');
    }
  }

  // Reset filters
  void resetFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _filteredFoods = _foods;
    _error = null;
    notifyListeners();
  }

  // Private helper method
  void _setLoading(bool value) {
    _isLoading = value;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}