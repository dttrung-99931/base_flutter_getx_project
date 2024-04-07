import 'package:base_flutter_getx/config/assets/assets.dart';
import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:base_flutter_getx/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../core/base/base_get_widget.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends BaseGetWidget<LoginController> {
  LoginScreen({super.key});
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(s16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                h64sb,
                Text(
                  'Login',
                  style: textTheme.titleMedium,
                ),
                h32sb,
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  style: textTheme.bodyMedium,
                ),
                h16sb,
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  style: textTheme.bodyMedium,
                ),
                h32sb,
                SizedBox(
                  width: double.infinity,
                  height: h48,
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () {
                              controller.login(
                                phoneController.text,
                                passwordController.text,
                              );
                            },
                      child: controller.isLoading
                          ? const LoadingWidget()
                          : const Text('Login'),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
