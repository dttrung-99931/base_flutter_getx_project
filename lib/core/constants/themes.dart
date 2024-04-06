
import 'package:flutter/material.dart';

/// Theme
final kAppTheme = ThemeData(
  primarySwatch: kPrimarySwatch,
  scaffoldBackgroundColor: kBackgroundColor,
  iconTheme: const IconThemeData(color: kPrimarySwatch),
  appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
  fontFamily: 'Urbanist',
);

/// Colors
const kPrimarySwatch = Colors.teal;
final kBackgroundColor = Colors.grey[300]!;
const kShadowColor = Colors.black38;
