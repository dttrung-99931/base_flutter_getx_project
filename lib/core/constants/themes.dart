// ignore_for_file: unnecessary_late

import 'package:base_flutter_getx/core/constants/colors.dart';
import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:base_flutter_getx/core/constants/text_theme_adapter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

ShadThemeData buildLightTheme() {
  return _buildShadTheme(
    brightness: Brightness.light,
    colorScheme: ShadZincColorScheme.light(
      background: AppColors.background,
      foreground: AppColors.black,
      card: AppColors.white,
      cardForeground: AppColors.black,
      popover: AppColors.white,
      popoverForeground: AppColors.black,
      primary: AppColors.primary,
      primaryForeground: AppColors.white90,
      secondary: AppColors.background,
      secondaryForeground: AppColors.black,
      muted: AppColors.background,
      mutedForeground: Colors.black54,
      accent: AppColors.background,
      accentForeground: AppColors.black,
      ring: AppColors.primary,
    ),
  );
}

ShadThemeData buildDarkTheme() {
  const darkBackground = Color(0xFF121212);
  const darkSurface = Color(0xFF1E1E1E);
  const darkMuted = Color(0xFF2C2C2C);

  return _buildShadTheme(
    brightness: Brightness.dark,
    colorScheme: ShadZincColorScheme.dark(
      background: darkBackground,
      foreground: AppColors.white,
      card: darkSurface,
      cardForeground: AppColors.white,
      popover: darkSurface,
      popoverForeground: AppColors.white,
      primary: AppColors.primary,
      primaryForeground: AppColors.white90,
      secondary: darkMuted,
      secondaryForeground: AppColors.white,
      muted: darkMuted,
      mutedForeground: AppColors.white70,
      accent: darkMuted,
      accentForeground: AppColors.white,
      ring: AppColors.primary,
    ),
  );
}

ShadThemeData _buildShadTheme({
  required Brightness brightness,
  required ShadColorScheme colorScheme,
}) {
  return ShadThemeData(
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: ShadTextTheme(
      family: 'Urbanist',
      h1: TextStyle(
        fontSize: fz32,
        fontWeight: FontWeight.w600,
      ),
      h2: TextStyle(
        fontSize: fz24,
        fontWeight: FontWeight.w600,
      ),
      h3: TextStyle(
        fontSize: fz20,
        fontWeight: FontWeight.w600,
      ),
      h4: TextStyle(
        fontSize: fz18,
        fontWeight: FontWeight.w600,
      ),
      p: TextStyle(
        fontSize: fz16,
        fontWeight: FontWeight.w600,
      ),
      large: TextStyle(
        fontSize: fz16,
        fontWeight: FontWeight.w600,
      ),
      small: TextStyle(
        fontSize: fz14,
        fontWeight: FontWeight.w600,
      ),
      muted: TextStyle(
        fontSize: fz12,
        fontWeight: FontWeight.w600,
      ),
      custom: {
        'labelSmall': TextStyle(
          fontSize: fz10,
          fontWeight: FontWeight.w600,
        ),
      },
    ),
    primaryButtonTheme: ShadButtonTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white90,
      
      textStyle: TextStyle(
        fontSize: fz16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

late TextTheme _textTheme =
    TextThemeAdapter(ShadTheme.of(Get.context!).textTheme);

TextTheme get textTheme => _textTheme;
