import 'dart:async';

import 'package:base_flutter_getx/features/settings/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'app.dart';
import 'core/utils/error_handler/exception_handler.dart';
import 'global_binding.dart';

void main() async => startApp();

// Start app
void startApp() {
  // Run app in a zooned guarded to catch global exceptions
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setup();
      runApp(const App());
  }, (error, stacktrace) {
    ExceptionHandler.handleAsyncError(error, stacktrace);
  });
}

Future<void> setup() async {
  // Setup error handler
  FlutterError.onError = ExceptionHandler.handleSyncError;
  // Setup error ui builder that builds ui to notify errors to users 
  ErrorWidget.builder = ExceptionHandler.errorWidgetBuilder;

  await GlobalBinding().dependencies();
}
