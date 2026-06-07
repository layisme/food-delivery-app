import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food.dart';
import 'package:food_delivery_app/provider/home_provider.dart';
import 'package:food_delivery_app/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _promoImage =
      'https://www.figma.com/api/mcp/asset/7e9899c3-0429-48cf-8a3d-c539b814293b';
  static const String _grillImage =
      'https://www.figma.com/api/mcp/asset/402ca456-dead-4463-b691-f5b6f831f2f8';
  static const String _sakuraImage =
      'https://www.figma.com/api/mcp/asset/cc3a8e8b-c88a-44e8-8d86-6ba53eda1c34';
  static const String _harvestImage =
      'https://www.figma.com/api/mcp/asset/6de1e99e-b35e-48f7-bd9e-87ad16b2a81e';
  static const String _burgerImage =
      'https://www.figma.com/api/mcp/asset/4f82994e-883a-4e5f-ba67-04dac8c14fdd';
  static const String _donutImage =
      'https://www.figma.com/api/mcp/asset/6fc088ae-4be9-4b7d-beb4-41ecf193bdab';

  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchAllFoods();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F6),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _HomeContent(
              searchController: _searchController,
              promoImage: _promoImage,
              grillImage: _grillImage,
              sakuraImage: _sakuraImage,
              harvestImage: _harvestImage,
              burgerImage: _burgerImage,
              donutImage: _donutImage,
            ),
            _SearchTab(searchController: _searchController),
            const CartScreen(embedded: true),
            const _SimpleTab(
              title: 'Profile',
              subtitle: 'Manage account, orders, support, and preferences.',
              icon: Icons.person_outline,
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  onPressed: () => setState(() => _selectedIndex = 2),
                  backgroundColor: const Color(0xFFAB3500),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF261814),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Color(0xFFFFF8F6),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFE9E3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFFAB3500)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: Color(0xFFAB3500)),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFFAB3500)),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFFAB3500)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final TextEditingController searchController;
  final String promoImage;
  final String grillImage;
  final String sakuraImage;
  final String harvestImage;
  final String burgerImage;
  final String donutImage;

  const _HomeContent({
    required this.searchController,
    required this.promoImage,
    required this.grillImage,
    required this.sakuraImage,
    required this.harvestImage,
    required this.burgerImage,
    required this.donutImage,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _TopAppBar()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              sliver: SliverList.list(
                children: [
                  _SearchBar(
                    controller: searchController,
                    onChanged: provider.searchFoods,
                  ),
                  const SizedBox(height: 18),
                  _PromoBanner(imageUrl: promoImage),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    title: 'Explore Categories',
                    action: 'View All',
                    onTap: provider.resetFilters,
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _CategoryItem(
                      label: 'Pizza',
                      icon: Icons.local_pizza_outlined,
                      selected: provider.selectedCategory == 'Pizza',
                      onTap: () => provider.filterByCategory('Pizza'),
                    ),
                    _CategoryItem(
                      label: 'Burger',
                      icon: Icons.lunch_dining_outlined,
                      selected: provider.selectedCategory == 'Burgers',
                      onTap: () => provider.filterByCategory('Burgers'),
                    ),
                    _CategoryItem(
                      label: 'Coffee',
                      icon: Icons.local_cafe_outlined,
                      selected: provider.selectedCategory == 'Coffee',
                      onTap: () => provider.filterByCategory('Coffee'),
                    ),
                    _CategoryItem(
                      label: 'Healthy',
                      icon: Icons.eco_outlined,
                      selected: provider.selectedCategory == 'Healthy',
                      onTap: () => provider.filterByCategory('Healthy'),
                    ),
                    _CategoryItem(
                      label: 'Khmer',
                      icon: Icons.ramen_dining_outlined,
                      selected: provider.selectedCategory == 'Khmer',
                      onTap: () => provider.filterByCategory('Khmer'),
                    ),
                    _CategoryItem(
                      label: 'Dessert',
                      icon: Icons.icecream_outlined,
                      selected: provider.selectedCategory == 'Dessert',
                      onTap: () => provider.filterByCategory('Dessert'),
                    ),
                    _CategoryItem(
                      label: 'Drinks',
                      icon: Icons.local_drink_outlined,
                      selected: provider.selectedCategory == 'Drinks',
                      onTap: () => provider.filterByCategory('Drinks'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverList.list(
                children: [
                  const _SectionHeader(
                    title: 'Popular Restaurants',
                    action: 'See All',
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 258,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _RestaurantCard(
                      imageUrl: grillImage,
                      name: 'The Golden Grill',
                      cuisine: r'Western • Steakhouse • $$$',
                      rating: '4.8',
                      time: '20-30 min',
                    ),
                    _RestaurantCard(
                      imageUrl: sakuraImage,
                      name: 'Sakura Zen',
                      cuisine: r'Japanese • Sushi • $$$$',
                      rating: '4.9',
                      time: '15-25 min',
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              sliver: SliverList.list(
                children: [
                  const _SectionHeader(
                    title: 'Recommended for You',
                    action: 'Customize',
                  ),
                  const SizedBox(height: 14),
                  _HeroFoodCard(
                    imageUrl: harvestImage,
                    onTap: () =>
                        _openProduct(context, _featuredFood(harvestImage)),
                  ),
                  const SizedBox(height: 16),
                  if (provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _SmallFoodCard(
                            imageUrl: _foodImage(
                              provider.filteredFoods,
                              0,
                              burgerImage,
                            ),
                            name: _foodName(
                              provider.filteredFoods,
                              0,
                              'Double Cheese',
                            ),
                            price: _foodPrice(provider.filteredFoods, 0, 8.90),
                            onTap: () => _openProduct(
                              context,
                              _foodAt(
                                provider.filteredFoods,
                                0,
                                _fallbackFood(
                                  id: 'fallback-burger',
                                  name: 'Double Cheese',
                                  description:
                                      'Stacked burger with melted cheese and signature sauce',
                                  price: 8.90,
                                  imageUrl: burgerImage,
                                  category: 'Burgers',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _SmallFoodCard(
                            imageUrl: _foodImage(
                              provider.filteredFoods,
                              1,
                              donutImage,
                            ),
                            name: _foodName(
                              provider.filteredFoods,
                              1,
                              'Glazed Donuts',
                            ),
                            price: _foodPrice(provider.filteredFoods, 1, 4.50),
                            onTap: () => _openProduct(
                              context,
                              _foodAt(
                                provider.filteredFoods,
                                1,
                                _fallbackFood(
                                  id: 'fallback-donut',
                                  name: 'Glazed Donuts',
                                  description:
                                      'Soft glazed donuts with a rich chocolate finish',
                                  price: 4.50,
                                  imageUrl: donutImage,
                                  category: 'Dessert',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (provider.error != null) ...[
                    const SizedBox(height: 16),
                    _ErrorBanner(
                      message: provider.error!,
                      onClose: provider.clearError,
                    ),
                  ],
                  const SizedBox(height: 84),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static String _foodImage(List<Food> foods, int index, String fallback) {
    if (foods.length <= index) return fallback;
    return foods[index].imageUrl;
  }

  static String _foodName(List<Food> foods, int index, String fallback) {
    if (foods.length <= index) return fallback;
    return foods[index].name;
  }

  static double _foodPrice(List<Food> foods, int index, double fallback) {
    if (foods.length <= index) return fallback;
    return foods[index].price;
  }

  static Food _foodAt(List<Food> foods, int index, Food fallback) {
    if (foods.length <= index) return fallback;
    return foods[index];
  }

  static Food _featuredFood(String imageUrl) {
    return _fallbackFood(
      id: 'featured-harvest-bowl',
      name: 'Harvest Bowl',
      description: 'Healthy salad bowl with avocado, greens, and grains',
      price: 12.50,
      imageUrl: imageUrl,
      category: 'Healthy',
    );
  }

  static Food _fallbackFood({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
  }) {
    return Food(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      rating: 4.8,
      reviewCount: 128,
      category: category,
      isAvailable: true,
    );
  }

  static void _openProduct(BuildContext context, Food food) {
    Navigator.of(context).pushNamed('/product-details', arguments: food);
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F6).withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Color(0xFFAB3500),
            size: 22,
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Deliver to',
                style: TextStyle(
                  color: Color(0xFF594139),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Current Location',
                style: TextStyle(
                  color: Color(0xFF261814),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.notifications_none, color: Color(0xFF261814)),
              ),
              Positioned(
                right: 9,
                top: 9,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB3500),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFF8F6),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search for food, coffee...',
        hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF555F6F)),
        suffixIcon: Container(
          width: 42,
          height: 42,
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFF555F6F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tune, color: Colors.white, size: 20),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final String imageUrl;

  const _PromoBanner({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 192,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.38),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAB3500),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'LIMITED OFFER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '50% Off\non All Pizzas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Order now from Top Rated shops',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Claim Deal',
                      style: TextStyle(
                        color: Color(0xFFAB3500),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 24,
              bottom: 18,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.white : Colors.white30,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, required this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF261814),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFFAB3500),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFFFD2C4)
                    : const Color(0xFFFDE3DB),
                borderRadius: BorderRadius.circular(16),
                border: selected
                    ? Border.all(color: const Color(0xFFFF6B35), width: 1.2)
                    : null,
              ),
              child: Icon(icon, color: const Color(0xFFAB3500), size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF594139),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String cuisine;
  final String rating;
  final String time;

  const _RestaurantCard({
    required this.imageUrl,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 176,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Positioned(
                  left: 12,
                  top: 12,
                  child: _Pill(
                    icon: Icons.star,
                    label: rating,
                    background: Colors.white.withValues(alpha: 0.9),
                    foreground: const Color(0xFF261814),
                  ),
                ),
                const Positioned(
                  right: 12,
                  top: 12,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Color(0xFFAB3500),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAB3500),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF261814),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cuisine,
                  style: const TextStyle(
                    color: Color(0xFF594139),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFoodCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _HeroFoodCard({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 224,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.74),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Harvest Bowl',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Healthy Salad • 340 kcal',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFAB3500),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        r'$12.50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
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

class _SmallFoodCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final VoidCallback onTap;

  const _SmallFoodCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFFDE3DB),
                      child: const Icon(
                        Icons.fastfood,
                        color: Color(0xFFAB3500),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF261814),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFAB3500),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE9E3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFFFF6B35),
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  const _Pill({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFFFB800)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTab extends StatelessWidget {
  final TextEditingController searchController;

  const _SearchTab({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            const _TopAppBar(),
            const SizedBox(height: 16),
            _SearchBar(
              controller: searchController,
              onChanged: provider.searchFoods,
            ),
            const SizedBox(height: 24),
            const Text(
              'Search Results',
              style: TextStyle(
                color: Color(0xFF261814),
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            for (final food in provider.filteredFoods)
              InkWell(
                onTap: () => Navigator.of(
                  context,
                ).pushNamed('/product-details', arguments: food),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          food.imageUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 72,
                              height: 72,
                              color: const Color(0xFFFDE3DB),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                color: Color(0xFF261814),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Color(0xFF594139)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFAB3500),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SimpleTab extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SimpleTab({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        const _TopAppBar(),
        const SizedBox(height: 80),
        Icon(icon, size: 64, color: const Color(0xFFAB3500)),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF261814),
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF594139),
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const _ErrorBanner({required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE1DC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFAB3500)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFAB3500)),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Color(0xFFAB3500)),
          ),
        ],
      ),
    );
  }
}
