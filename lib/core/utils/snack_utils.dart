import 'package:base_flutter_getx/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showSnackbar(String message, {String title = 'Thông báo'}) async {
  await Get.snackbar(
    title,
    message,
    colorText: Colors.black,
    backgroundColor: AppColors.background,
  ).future;
}

void commingSoon() {
  showSnackbar('Tính năng đang được phát triển');
}
