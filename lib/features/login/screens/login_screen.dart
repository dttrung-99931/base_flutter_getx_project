import 'package:base_flutter_getx/core/constants/colors.dart';
import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:base_flutter_getx/core/utils/extension/ui_extensions.dart';
import 'package:base_flutter_getx/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;

  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    controller = Get.find<LoginController>();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(s16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                h32sb,
                Text(
                  'Base GetX App',
                  style: textTheme.titleMedium,
                ),
                h32sb,
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  style: textTheme.bodyMedium,
                ),
                h16sb,
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  style: textTheme.bodyMedium,
                ),
                h32sb,
                SizedBox(
                  width: double.infinity,
                  height: h40,
                  child: Obx(() {
                    // Use the controller instance from the state
                    return ElevatedButton(
                      onPressed: controller.isLoading // Access the RxBool value
                          ? null
                          : () {
                              controller.login(
                                phoneController.text,
                                passwordController.text,
                              );
                            },
                      child: controller.isLoading // Access the RxBool value
                          ? const LoadingWidget()
                          : Text('Login',
                              style: textTheme.bodyMedium
                                  .withColor(AppColors.white)),
                    );
                  }),
                ),
                h64sb,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
