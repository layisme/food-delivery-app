# Build Flavors Setup - Dev, UAT, Prod

This guide explains how to build and run the Food Delivery app with different flavors (environments).

## Overview

The app supports three flavors:
- **dev** - Development environment
- **uat** - User Acceptance Testing environment  
- **prod** - Production environment

Each flavor has different configurations:
- API endpoints
- App names
- Logging settings
- Application IDs

## Android Setup

The Android flavors are configured in `android/app/build.gradle.kts` with three product flavors:

```gradle
flavorDimensions += "default"

productFlavors {
    create("dev") {
        dimension = "default"
        applicationId = "com.example.food_delivery_app.dev"
        resValue("string", "app_name", "Food Delivery Dev")
    }
    create("uat") {
        dimension = "default"
        applicationId = "com.example.food_delivery_app.uat"
        resValue("string", "app_name", "Food Delivery UAT")
    }
    create("prod") {
        dimension = "default"
        applicationId = "com.example.food_delivery_app"
        resValue("string", "app_name", "Food Delivery")
    }
}
```

## iOS Setup

iOS flavor support is configured through XCConfig files:
- `ios/Flutter/Debug-dev.xcconfig`
- `ios/Flutter/Debug-uat.xcconfig`
- `ios/Flutter/Release-dev.xcconfig`
- `ios/Flutter/Release-uat.xcconfig`

For complete iOS flavor support, create schemes in Xcode:
1. Open `Runner.xcworkspace` in Xcode
2. Create schemes for each flavor (dev, uat, prod)
3. Configure build settings for each scheme

## Dart Configuration

Flavor configuration is managed in `lib/config/app_flavor.dart` and `lib/config/environment.dart`:

### AppFlavor Enum
```dart
enum AppFlavor {
  dev('dev', 'Development'),
  uat('uat', 'User Acceptance Testing'),
  prod('prod', 'Production');
  
  final String value;
  final String displayName;
  
  bool get isDev => this == AppFlavor.dev;
  bool get isUat => this == AppFlavor.uat;
  bool get isProd => this == AppFlavor.prod;
}
```

### AppConfig
Environment-specific settings:
```dart
class AppConfig {
  final AppFlavor flavor;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
}
```

Each flavor maps to different configurations:
- **dev**: `https://api-dev.example.com`, Logging enabled
- **uat**: `https://api-uat.example.com`, Logging enabled
- **prod**: `https://api.example.com`, Logging disabled

## Running with Flavors

### Android

**Development:**
```bash
flutter run -t lib/main.dart --flavor dev
```

**UAT:**
```bash
flutter run -t lib/main.dart --flavor uat
```

**Production:**
```bash
flutter run -t lib/main.dart --flavor prod
```

### iOS

**Development:**
```bash
flutter run -t lib/main.dart --flavor dev
```

**UAT:**
```bash
flutter run -t lib/main.dart --flavor uat
```

**Production:**
```bash
flutter run -t lib/main.dart --flavor prod
```

Alternatively, select the desired scheme in Xcode and run.

## Building APK/Bundles with Flavors

### Android APK

**Development:**
```bash
flutter build apk --flavor dev --split-per-abi
```

**UAT:**
```bash
flutter build apk --flavor uat --split-per-abi
```

**Production:**
```bash
flutter build apk --flavor prod --split-per-abi
```

### Android App Bundle

**Development:**
```bash
flutter build appbundle --flavor dev
```

**UAT:**
```bash
flutter build appbundle --flavor uat
```

**Production:**
```bash
flutter build appbundle --flavor prod
```

## Building iOS with Flavors

### iOS App (Debug)

**Development:**
```bash
flutter build ios --flavor dev --debug
```

**UAT:**
```bash
flutter build ios --flavor uat --debug
```

**Production:**
```bash
flutter build ios --flavor prod --debug
```

### iOS App (Release)

**Development:**
```bash
flutter build ios --flavor dev --release
```

**UAT:**
```bash
flutter build ios --flavor uat --release
```

**Production:**
```bash
flutter build ios --flavor prod --release
```

## Accessing Flavor Configuration in Code

### Get Current Flavor and Config

```dart
import 'package:food_delivery_app/config/environment.dart';

// Access global flavor
AppFlavor currentFlavor = appFlavor;

// Access global config
String apiUrl = appConfig.apiBaseUrl;
String appName = appConfig.appName;
bool loggingEnabled = appConfig.enableLogging;
```

### Using in Conditional Logic

```dart
if (appFlavor.isDev) {
  // Dev-specific code
}

if (appFlavor.isUat) {
  // UAT-specific code
}

if (appFlavor.isProd) {
  // Production-specific code
  debugShowCheckedModeBanner: false,
}
```

### Logging Example

```dart
import 'package:food_delivery_app/config/environment.dart';

void logDebug(String message) {
  if (appConfig.enableLogging) {
    print('[${appFlavor.displayName}] $message');
  }
}
```

## Setting the Flavor

In `lib/main.dart`, the flavor is set before running the app:

```dart
void main() {
  // Set the flavor - this can be overridden at build time
  setAppFlavor(AppFlavor.dev);
  
  runApp(MyApp());
}
```

For build-time flavor selection, you can modify this to use the `--dart-define` flag:

```dart
void main() {
  String flavorString = const String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  AppFlavor flavor = AppFlavor.fromString(flavorString);
  setAppFlavor(flavor);
  
  runApp(MyApp());
}
```

Then run with:
```bash
flutter run --dart-define=FLAVOR=prod
```

## Extending Flavor Configuration

To add more environment-specific configuration:

1. Add new properties to `AppConfig`:
```dart
class AppConfig {
  final String analyticsKey;
  final String crashlyticsToken;
  // ... other properties
}
```

2. Update `AppConfig.fromFlavor()` for each flavor:
```dart
factory AppConfig.fromFlavor(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return AppConfig(
        // ...
        analyticsKey: 'dev-analytics-key',
        crashlyticsToken: 'dev-crashlytics-token',
      );
    // ... other flavors
  }
}
```

3. Use in your code:
```dart
String analyticsKey = appConfig.analyticsKey;
```

## File Structure

```
lib/
├── config/
│   ├── app_flavor.dart      # Flavor enum and AppConfig
│   └── environment.dart      # Global flavor & config setup
├── main.dart                 # App entry point with flavor setup
└── ...

android/
├── app/
│   └── build.gradle.kts      # Android flavor configuration
└── ...

ios/
└── Flutter/
    ├── Debug-dev.xcconfig
    ├── Debug-uat.xcconfig
    ├── Release-dev.xcconfig
    └── Release-uat.xcconfig
```

## Troubleshooting

**Issue:** Flavor not recognized
- **Solution:** Run `flutter clean` and rebuild

**Issue:** App still shows debug banner in prod
- **Solution:** Check `main.dart` and ensure `debugShowCheckedModeBanner: !appFlavor.isProd`

**Issue:** iOS build fails with flavor
- **Solution:** Ensure schemes exist in Xcode for each flavor

**Issue:** API endpoint not changing
- **Solution:** Verify flavor is set correctly in `main.dart` and used from `appConfig.apiBaseUrl`
