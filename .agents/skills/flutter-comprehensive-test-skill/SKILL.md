---
name: flutter-comprehensive-test-skill
description: >
  Guides comprehensive Flutter feature tests for this GetX app: controller
  unit tests, service tests, widget tests, and device integration tests.
  Uses flutter-testing-skill for test style and the login feature as the
  example. Use when adding or fixing tests, when the user mentions unit test,
  widget test, integration test, test coverage, mocktail, or the login tests.
---

# Comprehensive Flutter tests

Read and follow [flutter-testing-skill](../flutter-testing-skill/SKILL.md) for how to write a test (finders, `pump` / `pumpAndSettle`, assertions). This skill says which layers a feature needs and which GetX and device rules that skill does not cover.

A new feature is covered when these exist, in `group` blocks, and they pass:

| Layer | Place | What it proves |
| --- | --- | --- |
| Controller | `test/features/<feature>/controllers/` | Success and failure with a mocked service |
| Service | `test/features/<feature>/services/` | HTTP success and error mapped to `Either` |
| Widget | `test/features/<feature>/screens/` | UI, validation, navigation with a mocked service |
| Integration | `integration_test/` | The same flows through `App` on a device |

Follow these examples. They are the pattern, not files from the host `test/` tree. Rename `package:app` and the login types to the feature under test. Assert the strings that screen actually shows.

- [Controller](examples/controller.md)
- [Service](examples/service.md)
- [Widget](examples/widget.md)
- [Integration](examples/integration.md)

Login inputs that pass validation: phone `09882202201`, password `aa123345`.

## mocktail and GetConnect

`when` only works on a `Mock`. `GetConnect.httpClient` is a getter with no setter, so stubbing it on a real service fails. Override the getter in a test subclass, as in the login service example.

Match the real `post` call, including named arguments that are null. `any(named: 'decoder')` means a decoder argument was passed. Because the stub replaces `post`, GetX never runs the decoder. Return an already decoded `Response` whose body is a `ResponseWrapper`.

Request DTOs have no `==`. Stub `login(any())` and call `registerFallbackValue` in `setUpAll`. A stub of one `LoginRequestDto` instance does not match the instance the controller builds.

`Get.put<LoginService>(mock)` before the route `lazyPut`. `lazyPut` does not replace an instance that is already registered.

## Widget test

Use the automated binding (`flutter test`, no device). Keep `ResponsiveBreakpoints` inside `GetMaterialApp.builder`. The login widget example is the tree to copy: `ShadApp.custom`, translations, locale `en_US`.

Do not mount the production login route. Its binding creates the real service and replaces the mock. Use a test `GetPage` whose page is `LoginScreen`, and `Get.put` the controller in `setUp`.

`GetMaterialApp` ignores the `initialRoute` you pass and opens `getPages.first`. `Routes.home` is `/`. `home: LoginScreen()` makes the current route `/`, so `Get.offNamed(Routes.home)` does not show the home screen. Register home and a separate login page, and start on login.

## Integration test

Run on an Android device or emulator:

```sh
flutter test -d <device> integration_test/<feature>_integration_test.dart
```

Web and macOS are not supported for these tests. The sandbox blocks Flutter engine files. Run the command with full permissions.

`integration_test` uses `LiveTestWidgetsFlutterBinding`. Set `framePolicy` to `fullyLive` before the tests. Do not pass a `duration` to `pumpWidget`. A duration delays the frame the test is waiting for, so the native splash stays on screen.

The harness calls `runApp` with "Test starting..." through `Timer.run` (`Duration.zero`). That callback sits on the event queue. `await tester.pump()` completes on a microtask, and microtasks run before timers, so `pumpWidget` can mount `App` while the timer is still queued. The timer then mounts "Test starting..." on top of `App`. Before `pumpWidget`, let the timer finish:

```dart
await tester.binding.delayed(Duration.zero);
await tester.pump();
```

`SettingController.onInit` calls `Get.updateLocale`, which calls `performReassemble`. That reassemble can finish a frame while the placeholder timer is still queued. If locale setup is required, do it, then the two lines above, then `pumpWidget`.

Pump `App(isResponsiveEnabled: false)`. `ResponsiveBreakpoints` queues a post-frame callback that reads `context` after the widget is disposed, and the exception aborts the frame. That callback runs because the tree was already replaced. It is not what keeps the splash up. Widget tests do not hit it.

`Get.snackbar` throws `No Overlay widget found` on this Flutter version. `Get.overlayContext` is the overlay's `_Theater` child, and `Overlay.of` does not see that overlay. A failed login goes through `BaseController.showSnackbar`, so an integration case that expects the error snackbar fails before the assertion. Cover API errors in the service test. Integration cases that never call the service (validation) are safe.

Assert the visible strings, whether the screen stays or navigates, and `verify` / `verifyNever` on the service. Group the cases.
