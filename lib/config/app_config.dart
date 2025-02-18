// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:base_flutter_getx/main_dev.dart';
import 'package:base_flutter_getx/main_production.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._({
    required this.apiUrl,
    required this.flavor,
  });

  static void set({
    required String apiUrl,
    required AppFlavor flavor,
  }) {
    _config = AppConfig._(
      apiUrl: apiUrl,
      flavor: flavor,
    );
  }

  final String apiUrl;
  final AppFlavor flavor;
  static AppConfig get config => _config!;
  static AppConfig? _config;
  static Map<AppFlavor, Function()> configurerMap = {
    AppFlavor.production: configProduction,
    AppFlavor.dev: configDev,
  };

  bool get isDebug => kDebugMode;

  // Setup app config & dependencies
  // Call this from isolate or bg notification handler before access app dependencies
  static Future<void> autoConfigByBundleId() async {
    AppFlavor env = await getFlavorByCurrentAppBundleId();
    configurerMap[env]?.call();
  }

  static Future<AppFlavor> getFlavorByCurrentAppBundleId() async {
    return AppFlavor.dev;

    // TODO;
    // PackageInfo info = await PackageInfo.fromPlatform();
    // String bundleId = info.packageName;
    // if (bundleId.toLowerCase().contains('dev')) {
    //   return AppFlavor.DEV;
    // }
    // if (bundleId.toLowerCase().contains('staging')) {
    //   return AppFlavor.STAGING;
    // }
    // if (bundleId.toLowerCase().contains('staging_dev')) {
    //   return AppFlavor.STAGING_DEV;
    // }
    // return AppFlavor.PRODUCTION;
  }

  // Flavor need match with bundle id like below role
  // to make background notificaiton working correctly in
  Future<void> validateFlavorMatchingBundleId() async {
    assert(
      flavor == await getFlavorByCurrentAppBundleId(),
      """Native bundle id must contains match env name. 
      Ex: dev bundle id mus contains 'dev' => dev bundle id may be 'app.test.dev'""",
    );
  }
}

enum AppFlavor { dev, production }
