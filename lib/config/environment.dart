import 'package:food_delivery_app/config/app_flavor.dart';

/// Global app configuration
late AppConfig appConfig;

/// Global flavor
late AppFlavor appFlavor;

void setAppFlavor(AppFlavor flavor) {
  appFlavor = flavor;
  appConfig = AppConfig.fromFlavor(flavor);
}
