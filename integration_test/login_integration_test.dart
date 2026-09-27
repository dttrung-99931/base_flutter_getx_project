import 'package:base_flutter_getx/app.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:base_flutter_getx/features/settings/controller.dart';
import 'package:base_flutter_getx/shared/services/storage_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/shared/base_test.dart';

class MockLoginService with Mock implements LoginService {}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Draw every frame the test requests. The default policy can skip them,
  // which leaves the native splash on screen.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  late MockLoginService loginService;

  setUpAll(() {
    registerFallbackValue(LoginRequestDto(phone: '', password: ''));
  });

  setUp(() async {
    setUpTest();
    await GetStorage.init();
    Get.find<Storage>().languageCode = 'en';
    await Get.find<SettingController>().onInit();
    loginService = MockLoginService();
    when(() => loginService.login(any())).thenAnswer(
      (_) async => Right(LoginResponse(userID: 123, token: 'token')),
    );
    // Registered before the login route lazyPut, so the route keeps this mock.
    Get.put<LoginService>(loginService);
  });

  tearDown(Get.reset);

  // The harness attaches "Test starting..." with a timer. Let that timer
  // finish so pumpWidget is the last root and the login screen stays up.
  Future<void> openLogin(WidgetTester tester) async {
    await tester.binding.delayed(Duration.zero);
    await tester.pump();
    await tester.pumpWidget(const App(isResponsiveEnabled: false));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(EditableText), findsNWidgets(2));
  }

  Future<void> enterAccount(
    WidgetTester tester, {
    required String phone,
    required String password,
  }) async {
    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), phone);
    await tester.enterText(fields.at(1), password);
  }

  Future<void> tapLogin(WidgetTester tester) async {
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
  }

  group('Login Integration Test', () {
    testWidgets('login navigates to home', (tester) async {
      await openLogin(tester);
      await enterAccount(tester, phone: '09882202201', password: 'aa123345');
      await tapLogin(tester);

      expect(find.text('home'), findsOneWidget);
      verify(() => loginService.login(any())).called(1);
    });

    testWidgets('empty fields stay on login', (tester) async {
      await openLogin(tester);
      await tapLogin(tester);

      expect(find.text('Enter phone number'), findsOneWidget);
      expect(find.text('Nhập mật khẩu'), findsOneWidget);
      expect(find.text('home'), findsNothing);
      verifyNever(() => loginService.login(any()));
    });

    testWidgets('invalid phone stays on login', (tester) async {
      await openLogin(tester);
      await enterAccount(tester, phone: '123', password: 'aa123345');
      await tapLogin(tester);

      expect(find.text('SĐT không hợp lệ'), findsOneWidget);
      expect(find.text('home'), findsNothing);
      verifyNever(() => loginService.login(any()));
    });

    testWidgets('invalid password stays on login', (tester) async {
      await openLogin(tester);
      await enterAccount(tester, phone: '09882202201', password: '12345678');
      await tapLogin(tester);

      expect(find.text('Mật khẩu không hợp lệ'), findsOneWidget);
      expect(find.text('home'), findsNothing);
      verifyNever(() => loginService.login(any()));
    });
  });
}
