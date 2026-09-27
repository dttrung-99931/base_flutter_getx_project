import 'package:base_flutter_getx/config/routes.dart';
import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:base_flutter_getx/core/translation/app_translation.dart';
import 'package:base_flutter_getx/features/home/home_route.dart';
import 'package:base_flutter_getx/features/login/controllers/login_controller.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:base_flutter_getx/features/login/screens/login_screen.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:base_flutter_getx/shared/services/storage_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../shared/base_test.dart';

class MockLoginService with Mock implements LoginService {}

class MockStorage with Mock implements Storage {}

void main() {
  late MockLoginService loginService;
  late LoginController loginController;

  setUpAll(() {
    registerFallbackValue(LoginRequestDto(phone: '', password: ''));
  });

  setUp(() {
    setUpTest();
    loginService = MockLoginService();
    loginController = LoginController(
      loginService: loginService,
      storage: MockStorage(),
    );
    Get.put(loginController);
  });

  tearDown(Get.reset);

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ShadApp.custom(
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        appBuilder: (context) {
          return GetMaterialApp(
            translations: AppTranslation(),
            locale: const Locale('en', 'US'),
            initialRoute: Routes.login,
            getPages: [
              homeRoute,
              GetPage(
                name: Routes.login,
                page: () => const LoginScreen(),
              ),
            ],
            builder: (context, child) {
              return ResponsiveBreakpoints.builder(
                child: ShadAppBuilder(child: child!),
                breakpoints: const [
                  Breakpoint(start: 0, end: 599, name: MOBILE),
                  Breakpoint(start: 600, end: 1023, name: TABLET),
                  Breakpoint(
                    start: 1024,
                    end: double.infinity,
                    name: DESKTOP,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Login Screen Widget Test', () {
    testWidgets('shows phone, password and login button', (tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('Phone number'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('empty phone shows validation and does not call login',
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

      expect(find.text('home'), findsOneWidget);
      verify(() => loginService.login(any())).called(1);
    });
  });
}
