import 'dart:async';

import 'package:base_flutter_getx/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';

void main() async {
  await configDev();
  startApp();
}

Future<void> configDev() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.set(
    apiUrl: '',
    flavor: AppFlavor.dev,
    serpAPIKey:
        '88a00f841eab63057b327fc357971ba9259f24d261b46111f71bc48c78b1bbf1',
  );
}
