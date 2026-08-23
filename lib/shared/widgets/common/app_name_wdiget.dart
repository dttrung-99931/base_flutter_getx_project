import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'app_name'.tr,
      style: textTheme.titleSmall,
    );
  }
}
