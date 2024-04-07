import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:base_flutter_getx/shared/widgets/title_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/base/base_get_widget.dart';
import 'home_controller.dart';

class HomeScreen extends BaseGetWidget<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text("Counter ${controller.counter.value}"),
              ),
              h16sb,
              TitleIconButton(
                iconData: Icons.plus_one,
                title: 'add'.tr,
                onPressed: () {
                  controller.increase();
                },
              ),
              h8sb,
              TitleIconButton(
                iconData: Icons.exposure_minus_1,
                title: 'subtract'.tr,
                onPressed: () {
                  controller.decrease();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
