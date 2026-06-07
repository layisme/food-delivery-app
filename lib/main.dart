import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/config/app_flavor.dart';
import 'package:food_delivery_app/config/environment.dart';
import 'package:food_delivery_app/models/food.dart';
import 'package:food_delivery_app/provider/home_provider.dart';
import 'package:food_delivery_app/repositories/food_repository.dart';
import 'package:food_delivery_app/screens/cart_screen.dart';
import 'package:food_delivery_app/screens/checkout_screen.dart';
import 'package:food_delivery_app/screens/home_screen.dart';
import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:food_delivery_app/screens/onboarding_screen.dart';
import 'package:food_delivery_app/screens/product_details_screen.dart';
import 'package:food_delivery_app/screens/splash_screen.dart';
import 'package:food_delivery_app/screens/tracking_order_screen.dart';
import 'package:provider/provider.dart';

void main() {
  // Default flavor is dev - can be overridden at build time
  setAppFlavor(AppFlavor.dev);

  runApp(
    DevicePreview(
      defaultDevice: Devices.ios.iPhone16ProMax,
      builder: (context) {
        return MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the repository
        Provider<IFoodRepository>(create: (_) => FoodRepository()),
        // Provide the HomeProvider with the repository
        ChangeNotifierProvider<HomeProvider>(
          create: (context) =>
              HomeProvider(foodRepository: context.read<IFoodRepository>()),
        ),
      ],
      child: MaterialApp(
        title: appConfig.appName,
        home: const SplashScreen(),
        routes: {
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/cart': (_) => const CartScreen(),
          '/checkout': (context) {
            final total =
                ModalRoute.of(context)?.settings.arguments as double? ?? 25.50;
            return CheckoutScreen(total: total);
          },
          '/product-details': (context) {
            final food = ModalRoute.of(context)!.settings.arguments as Food;
            return ProductDetailsScreen(food: food);
          },
          '/tracking-order': (_) => const TrackingOrderScreen(),
          '/home': (_) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: !appFlavor.isProd,
        theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
            side: BorderSide(
              color: Colors.black.withValues(alpha: 0.4),
              width: 2
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black.withValues(alpha: 0.25)),
            )
          )
        ),
      ),
    );
  }
}
