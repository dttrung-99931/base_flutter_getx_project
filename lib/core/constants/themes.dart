// ignore_for_file: unnecessary_late

import 'package:base_flutter_getx/core/constants/colors.dart';
import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ThemeData buildTheme(BuildContext appContext) {
  return ThemeData(
    primarySwatch: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    iconTheme: const IconThemeData(color: AppColors.primary),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: AppColors.primary,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white90, // Text color
        textStyle: TextStyle(
          fontSize: fz16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    fontFamily: 'Urbanist',
    textTheme: Theme.of(appContext).textTheme.copyWith(
          titleLarge: TextStyle(
            fontSize: fz32,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          titleMedium: TextStyle(
            fontSize: fz24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          titleSmall: TextStyle(
            fontSize: fz20,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),

          // Contennt
          bodyLarge: TextStyle(
            fontSize: fz18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: fz16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          bodySmall: TextStyle(
            fontSize: fz14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),

          /// Lable
          labelMedium: TextStyle(
            fontSize: fz12,
            fontWeight: FontWeight.w600,
          ),

          labelSmall: TextStyle(
            fontSize: fz10,
            fontWeight: FontWeight.w600,
          ),
        ),
  );
}

late TextTheme _textTheme = Theme.of(Get.context!).textTheme;
TextTheme get textTheme => _textTheme;
