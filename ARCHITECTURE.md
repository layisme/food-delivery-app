# Provider with Repository Pattern Implementation

This food delivery app implements the **Provider with Repository Pattern**, a clean architecture approach for state management and data handling in Flutter.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer (Screens)                   │
│                    (HomeScreen)                         │
└───────────────────────┬─────────────────────────────────┘
                        │ consumes
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Provider Layer (State Management)          │
│                  (HomeProvider)                         │
└───────────────────────┬─────────────────────────────────┘
                        │ uses
                        ▼
┌─────────────────────────────────────────────────────────┐
│            Repository Layer (Data Access)               │
│             (FoodRepository)                            │
└───────────────────────┬─────────────────────────────────┘
                        │ calls
                        ▼
┌─────────────────────────────────────────────────────────┐
│         Data Layer (API / Database / Cache)             │
│                  (Mock Data)                            │
└─────────────────────────────────────────────────────────┘
```

## Key Components

### 1. **Models** (`lib/models/food.dart`)
- Represents the data structure
- Includes `fromJson()` and `toJson()` for serialization
- Provides `copyWith()` for immutability

### 2. **Repository** (`lib/repositories/food_repository.dart`)
- **Abstract Interface (`IFoodRepository`)**: Defines contracts
- **Concrete Implementation (`FoodRepository`)**: Implements data operations
- Benefits:
  - Easy to test (swap implementations)
  - Decouples UI from data source
  - Can easily switch between API, database, or mock data

### 3. **Provider** (`lib/provider/home_provider.dart`)
- Manages application state using `ChangeNotifier`
- Depends on repository via constructor injection
- Handles business logic:
  - Fetching data
  - Filtering
  - Searching
  - Error handling
  - Loading states

### 4. **Dependency Injection** (`lib/main.dart`)
- Setup in `MultiProvider` at app root
- Repository is provided first
- Provider receives repository via `context.read<IFoodRepository>()`

### 5. **UI** (`lib/screens/home_screen.dart`)
- Consumes provider using `Consumer<HomeProvider>`
- Triggers data loading in `initState`
- Displays loading, error, and data states

## How to Use

### Basic Setup
```dart
// The provider is already set up in main.dart
// Just use it in any widget with Provider package

Consumer<HomeProvider>(
  builder: (context, provider, _) {
    // Access provider's state and methods
    return Text('Foods: ${provider.foods.length}');
  },
)
```

### Fetch Foods
```dart
context.read<HomeProvider>().fetchAllFoods();
```

### Filter by Category
```dart
await context.read<HomeProvider>().filterByCategory('Pizza');
```

### Search Foods
```dart
await context.read<HomeProvider>().searchFoods('pizza');
```

### Access State
```dart
final provider = context.read<HomeProvider>();

// State getters
List<Food> foods = provider.filteredFoods;
bool isLoading = provider.isLoading;
String? error = provider.error;
String category = provider.selectedCategory;
```

## Adding New Features

### 1. Add a New Method to Repository

```dart
// In food_repository.dart
@override
Future<List<Food>> getFoodsByPriceRange(double min, double max) async {
  // Implementation
}
```

### 2. Add corresponding method to Provider

```dart
// In home_provider.dart
Future<void> filterByPrice(double min, double max) async {
  _setLoading(true);
  try {
    _filteredFoods = await _foodRepository.getFoodsByPriceRange(min, max);
    notifyListeners();
  } catch (e) {
    _error = 'Failed to filter by price: ${e.toString()}';
    notifyListeners();
  } finally {
    _setLoading(false);
  }
}
```

### 3. Use in UI

```dart
// In home_screen.dart
context.read<HomeProvider>().filterByPrice(5.0, 15.0);
```

## Replacing Mock Data with Real API

Simply modify `FoodRepository` to make actual API calls:

```dart
@override
Future<List<Food>> getAllFoods() async {
  final response = await http.get(Uri.parse('https://api.example.com/foods'));
  
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Food.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load foods');
  }
}
```

## Benefits of This Pattern

✅ **Separation of Concerns**: Each layer has a specific responsibility  
✅ **Testability**: Easy to mock repository for unit tests  
✅ **Reusability**: Provider can be used across multiple screens  
✅ **Maintainability**: Changes to data source only affect repository  
✅ **Scalability**: Easy to add new features and repositories  
✅ **Dependency Injection**: Loose coupling between layers  

## Testing Example

```dart
// Mock repository for testing
class MockFoodRepository implements IFoodRepository {
  @override
  Future<List<Food>> getAllFoods() async {
    return [
      Food(id: '1', name: 'Test Pizza', ...),
    ];
  }
  // ... implement other methods
}

// Use in tests
testWidgets('HomeProvider fetches foods', (WidgetTester tester) async {
  final mockRepo = MockFoodRepository();
  final provider = HomeProvider(foodRepository: mockRepo);
  
  await provider.fetchAllFoods();
  
  expect(provider.foods.length, 1);
  expect(provider.foods[0].name, 'Test Pizza');
});
```

## Next Steps

1. Connect to a real API (replace mock data)
2. Add caching mechanism
3. Implement pagination
4. Add error boundary widgets
5. Create additional repositories (OrderRepository, UserRepository, etc.)
6. Add unit and widget tests
