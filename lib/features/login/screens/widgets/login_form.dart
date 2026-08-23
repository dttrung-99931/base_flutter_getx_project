import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:base_flutter_getx/core/utils/validate.dart';
import 'package:base_flutter_getx/features/login/controllers/login_controller.dart';
import 'package:base_flutter_getx/shared/widgets/button/app_button.dart';
import 'package:base_flutter_getx/shared/widgets/form/app_form.dart';
import 'package:base_flutter_getx/shared/widgets/input/app_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.controller,
  });

  final LoginController controller;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<AppFormState>();

  static const _phoneFieldId = 'phone';
  static const _passwordFieldId = 'password';

  void onLoginPressed() {
    final formState = formKey.currentState;
    if (formState == null || !formState.saveAndValidate()) return;

    widget.controller.login(
      formState.value[_phoneFieldId] as String? ?? '',
      formState.value[_passwordFieldId] as String? ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      key: formKey,
      child: Column(
        children: [
          AppInput(
            id: _phoneFieldId,
            label: 'phone_number'.tr,
            placeholder: 'phone_number'.tr,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            leadingIcon: Icons.phone,
            validator: (value) {
              if (value.isEmpty) {
                return 'phone_number_required'.tr;
              }
              return Validate.phone(value);
            },
          ),
          h16sb,
          AppInput(
            id: _passwordFieldId,
            label: 'password'.tr,
            placeholder: 'password'.tr,
            leadingIcon: Icons.lock,
            isPassword: true,
            validator: Validate.pass,
          ),
          h32sb,
          Obx(() {
            final isLoading = widget.controller.isLoading;
            return AppButton(
              width: double.infinity,
              isLoading: isLoading,
              onPressed: onLoginPressed,
              child: Text(isLoading ? 'please_wait'.tr : 'login'.tr),
            );
          }),
        ],
      ),
    );
  }
}
