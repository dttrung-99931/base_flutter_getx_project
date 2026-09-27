# Integration test

Runs on an Android device or emulator:

```sh
flutter test -d <device> integration_test/<feature>_integration_test.dart
```

Web and desktop are not valid targets for `integration_test`.

`integration_test` uses `LiveTestWidgetsFlutterBinding`.

- Set `framePolicy` to `fullyLive`. The default policy can skip the frame, and the native splash stays up.
- Do not pass `duration` to `pumpWidget`. That delays the frame the test is waiting for.
- The harness attaches "Test starting..." with `Timer.run` (`Duration.zero`). That callback is on the event queue. `await pump()` resumes as a microtask, and microtasks run before timers, so `pumpWidget` can mount `App` while the timer is still queued. The timer then puts "Test starting..." back on top. Call `delayed(Duration.zero)` and `pump()` first so the timer finishes, then `pumpWidget` is the last root.
- `Get.updateLocale` calls `performReassemble`. If setup does that, run it, then the two wait lines, then `pumpWidget`.
- Disable the responsive breakpoint widget on this test if its post-frame callback reads `context` after dispose. Widget tests do not need that flag.
- `Get.put` the mock service before the route `lazyPut`. `lazyPut` does not replace an existing instance.
- Cover API error bodies in the service test. `Get.snackbar` can throw `No Overlay widget found` on current Flutter, so an integration case that expects the error snackbar fails before the assertion. Validation cases that never call the service are safe.

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

// Host types. App is the widget the real entry point runs.
import 'package:app/app.dart';
import 'package:app/features/login/login_request.dart';
import 'package:app/features/login/login_response.dart';
import 'package:app/features/login/login_service.dart';

class MockLoginService with Mock implements LoginService {}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  late MockLoginService loginService;

  setUpAll(() {
    registerFallbackValue(LoginRequest(phone: '', password: ''));
  });

  setUp(() {
    loginService = MockLoginService();
    when(() => loginService.login(any())).thenAnswer(
      (_) async => Right(LoginResponse(userID: 123, token: 'token')),
    );
    // Before App builds. The login route's lazyPut keeps this instance.
    Get.put<LoginService>(loginService);
  });

  tearDown(Get.reset);

  Future<void> openLogin(WidgetTester tester) async {
    // Let the "Test starting..." timer attach before App replaces it.
    await tester.binding.delayed(Duration.zero);
    await tester.pump();

    await tester.pumpWidget(const App(isResponsiveEnabled: false));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
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

  group('Login', () {
    testWidgets('navigates to home', (tester) async {
      await openLogin(tester);
      await enterAccount(tester, phone: '09882202201', password: 'aa123345');
      await tapLogin(tester);

      expect(find.text('Home'), findsOneWidget);
      verify(() => loginService.login(any())).called(1);
    });

    testWidgets('empty fields stay on the screen and do not call login',
        (tester) async {
      await openLogin(tester);
      await tapLogin(tester);

      expect(find.text('Enter phone number'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
      verifyNever(() => loginService.login(any()));
    });

    testWidgets('invalid phone stays on the screen', (tester) async {
      await openLogin(tester);
      await enterAccount(tester, phone: '123', password: 'aa123345');
      await tapLogin(tester);

      expect(find.text('Invalid phone'), findsOneWidget);
      verifyNever(() => loginService.login(any()));
    });

    testWidgets('invalid password stays on the screen', (tester) async {
      await openLogin(tester);
      await enterAccount(tester, phone: '09882202201', password: '12345678');
      await tapLogin(tester);

      expect(find.text('Invalid password'), findsOneWidget);
      verifyNever(() => loginService.login(any()));
    });
  });
}
```
