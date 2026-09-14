import 'package:base_flutter_getx/core/utils/extension/num_extensions.dart';
import 'package:base_flutter_getx/features/login/controllers/login_controller.dart';
import 'package:base_flutter_getx/features/login/screens/widgets/login_form.dart';
import 'package:base_flutter_getx/shared/widgets/common/app_name_wdiget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                32.hsb,
                const AppNameWidget(),
                32.hsb,
                LoginForm(controller: controller),
                64.hsb,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
