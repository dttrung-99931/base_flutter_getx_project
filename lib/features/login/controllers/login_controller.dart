import 'package:base_flutter_getx/config/routes.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:base_flutter_getx/shared/services/storage_service.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';

class LoginController extends BaseController {
  LoginController({required LoginService loginService, required Storage storage}) : _service = loginService, _storage = storage;

  final isLoginSucces = RxBool(false);
  final LoginService _service;
  final Storage _storage;

  Future<void> login(String phone, String password) async {
    await handleServiceResult<LoginResponse>(
      serviceResult: _service.login(
        LoginRequestDto(phone: phone, password: password),
      ),
      onSuccess: (LoginResponse result) {
        _storage.token = result.token;
        Get.offNamed(Routes.home);
      },
    );
  }
}