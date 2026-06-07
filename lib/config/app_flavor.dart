enum AppFlavor {
  dev('dev', 'Development'),
  uat('uat', 'User Acceptance Testing'),
  prod('prod', 'Production');

  const AppFlavor(this.value, this.displayName);

  final String value;
  final String displayName;

  static AppFlavor fromString(String flavor) {
    return AppFlavor.values.firstWhere(
      (f) => f.value == flavor,
      orElse: () => throw ArgumentError('Unknown flavor: $flavor'),
    );
  }

  bool get isDev => this == AppFlavor.dev;
  bool get isUat => this == AppFlavor.uat;
  bool get isProd => this == AppFlavor.prod;

  @override
  String toString() => value;
}

/// AppConfig holds environment-specific configuration
class AppConfig {
  final AppFlavor flavor;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;

  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
  });

  factory AppConfig.fromFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return AppConfig(
          flavor: AppFlavor.dev,
          apiBaseUrl: 'https://api-dev.example.com',
          appName: 'Food Delivery Dev',
          enableLogging: true,
        );
      case AppFlavor.uat:
        return AppConfig(
          flavor: AppFlavor.uat,
          apiBaseUrl: 'https://api-uat.example.com',
          appName: 'Food Delivery UAT',
          enableLogging: true,
        );
      case AppFlavor.prod:
        return AppConfig(
          flavor: AppFlavor.prod,
          apiBaseUrl: 'https://api.example.com',
          appName: 'Food Delivery',
          enableLogging: false,
        );
    }
  }

  @override
  String toString() {
    return '''
    AppConfig(
      flavor: $flavor,
      apiBaseUrl: $apiBaseUrl,
      appName: $appName,
      enableLogging: $enableLogging,
    )
    ''';
  }
}
