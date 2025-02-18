import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';

void main() async {
  await configDev();
  startApp();
}

Future<void> configDev() async {
  WidgetsFlutterBinding.ensureInitialized();
}
