import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:base_flutter_getx/shared/widgets/composed_button.dart';
import 'package:base_flutter_getx/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../core/base/base_get_widget.dart';
import 'login_controller.dart';

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
          padding: EdgeInsets.all(16.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 64.h),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24.sp, color: kPrimarySwatch),
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
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
