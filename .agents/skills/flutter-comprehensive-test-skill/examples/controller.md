# Controller test

Unit test the controller with a mocked service. No widget, no HTTP.

The names below are the login shape. Rename them to the feature under test. The host repo does not need an existing login page or a `test/` tree.

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Host types. Point these imports at the feature you are testing.
import 'package:app/features/login/login_controller.dart';
import 'package:app/features/login/login_request.dart';
import 'package:app/features/login/login_response.dart';
import 'package:app/features/login/login_service.dart';

class MockLoginService with Mock implements LoginService {}

void main() {
  late MockLoginService loginService;
  late LoginController loginController;

  setUpAll(() {
    // The controller builds a new request object. Without ==, mocktail
    // cannot match a specific instance, so stub login(any()) and register
    // a fallback for that argument type.
    registerFallbackValue(LoginRequest(phone: '', password: ''));
  });

  setUp(() {
    loginService = MockLoginService();
    loginController = LoginController(loginService: loginService);
  });

  group('Login controller', () {
    test('sets success when the service returns Right', () async {
      when(() => loginService.login(any())).thenAnswer(
        (_) async => Right(LoginResponse(userID: 123, token: 'token')),
      );

      await loginController.login('09882202201', 'aa123345');

      expect(loginController.isLoginSuccess.value, true);
    });

    test('keeps success false when the service returns Left', () async {
      when(() => loginService.login(any())).thenAnswer(
        (_) async => Left(AppError(message: 'Login failed')),
      );

      await loginController.login('09882202201', 'aa123345');

      expect(loginController.isLoginSuccess.value, false);
    });
  });
}
```
