# Widget test

Runs with `flutter test` (no device). Mock the service and pump a test route. Do not use the production route binding: that binding creates the real service and replaces the mock.

`GetMaterialApp` ignores the `initialRoute` argument and opens `getPages.first`. If home is `/` and the widget under test is passed as `home:`, `Get.offNamed('/')` does not show another screen. Register home and the screen under test as two pages, and start on the screen under test.

`flutter test` uses the automated binding, so `ResponsiveBreakpoints` inside `GetMaterialApp.builder` is fine here.

Visible strings below are examples. Assert the strings the host screen actually shows.

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

// Host types.
import 'package:app/features/home/home_screen.dart';
import 'package:app/features/login/login_controller.dart';
import 'package:app/features/login/login_request.dart';
import 'package:app/features/login/login_response.dart';
import 'package:app/features/login/login_screen.dart';
import 'package:app/features/login/login_service.dart';

class MockLoginService with Mock implements LoginService {}

void main() {
  late MockLoginService loginService;

  setUpAll(() {
    registerFallbackValue(LoginRequest(phone: '', password: ''));
  });

  setUp(() {
    loginService = MockLoginService();
    // Put the controller yourself. The production GetPage binding would
    // construct the real LoginService.
    Get.put(LoginController(loginService: loginService));
  });

  tearDown(Get.reset);

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/login',
        getPages: [
          // Home is not first. GetMaterialApp opens getPages.first,
          // so this route would start at '/' if home were listed first.
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/', page: () => const HomeScreen()),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Login screen', () {
    testWidgets('shows the fields and the login button', (tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('Phone number'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('empty submit shows validation and does not call login',
        (tester) async {
      await pumpLoginScreen(tester);

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Enter phone number'), findsOneWidget);
      verifyNever(() => loginService.login(any()));
    });

    testWidgets('valid login navigates to home', (tester) async {
      when(() => loginService.login(any())).thenAnswer(
        (_) async => Right(LoginResponse(userID: 123, token: 'token')),
      );
      await pumpLoginScreen(tester);

      final fields = find.byType(EditableText);
      await tester.enterText(fields.at(0), '09882202201');
      await tester.enterText(fields.at(1), 'aa123345');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      verify(() => loginService.login(any())).called(1);
    });
  });
}
```
