import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
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
          padding: EdgeInsets.all(s32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                h32sb,
                const AppNameWidget(),
                h32sb,
                LoginForm(controller: controller),
                h64sb,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
