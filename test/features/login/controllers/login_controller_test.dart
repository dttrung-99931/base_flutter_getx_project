import 'package:base_flutter_getx/features/login/controllers/login_controller.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:base_flutter_getx/shared/services/storage_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../shared/base_test.dart';

class MockLoginService with Mock implements LoginService {}

class MockStorage with Mock implements Storage {}

void main() {
  late MockLoginService loginService;
  late MockStorage storageService;
  late LoginController loginController;

  setUp(() {
    setUpTest();
    loginService = MockLoginService();
    storageService = MockStorage();
    loginController = LoginController(
      loginService: loginService,
      storage: storageService,
    );
    registerFallbackValue(LoginRequestDto(phone: '', password: ''));
  });

  group("Login Controller", () {
    test("Login successfully when login with correct account", () async {
      when(() => loginService.login(any())).thenAnswer(
        (_) async => Right(LoginResponse(userID: 123, token: 'token')),
      );
      await loginController.login('0123456789', 'password');
      expect(loginController.isLoginSucces.value, true);
    });
  });
}
