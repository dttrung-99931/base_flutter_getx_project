import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base_flutter_getx/core/constants/sizes.dart';
import 'package:base_flutter_getx/shared/widgets/composed_button.dart';
import '../../core/base/base_get_widget.dart';
import 'controller.dart';

class HomeScreen extends BaseGetWidget<HomeController> {
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
              const SizedBox(height: Sizes.s16),
              ComposedButton(
                iconData: Icons.plus_one,
                title: 'add'.tr,
                onPressed: () {
                  controller.increase();
                },
              ),
              const SizedBox(height: Sizes.s8),
              ComposedButton(
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
