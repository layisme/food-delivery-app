import 'package:flutter/material.dart';
import 'package:food_delivery_app/config/environment.dart';
import 'package:food_delivery_app/provider/home_provider.dart';
import 'package:food_delivery_app/repositories/food_repository.dart';
import 'package:food_delivery_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:food_delivery_app/config/app_flavor.dart';

void main() {
  // Set the flavor based on the build configuration
  // For development: dev
  // For staging: uat
  // For production: prod
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
          create: (context) => HomeProvider(
            foodRepository: context.read<IFoodRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: appConfig.appName,
        home: HomeScreen(),
        debugShowCheckedModeBanner: appFlavor.isProd ? false : true,
      ),
    );
  }
}
