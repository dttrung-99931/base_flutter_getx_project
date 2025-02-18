import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';

void main() async {
  await configProduction();
  startApp();
}

Future<void> configProduction() async {
  WidgetsFlutterBinding.ensureInitialized();
}
