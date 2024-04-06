import 'package:base_flutter_getx/features/login/login_service.dart';
import 'package:base_flutter_getx/features/login/model/login_request.dart';
import 'package:base_flutter_getx/features/login/model/login_response.dart';
import 'package:get/get.dart';

import '../../core/base/base_controller.dart';

class LoginController extends BaseController {
  final isLoginSucces = RxBool(false);
  final LoginService _service = Get.find();

  Future<void> login(String phone, String password) async {
     handleServiceResult(
      serviceResult: _service.login(
        LoginRequestModel(phone: phone, password: password),
      ),
      onSuccess: (LoginResponseModel result) {
        showSnackbar('Login success');
      },
    );
  }
}
