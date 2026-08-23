// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:base_flutter_getx/config/routes.dart';
import 'package:base_flutter_getx/core/base/base_get_widget.dart';
import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:base_flutter_getx/core/translation/app_translation.dart';
import 'package:base_flutter_getx/core/utils/error_handler/exception_handler.dart';
import 'package:base_flutter_getx/features/login/login_route.dart';
import 'package:base_flutter_getx/features/settings/controller.dart';
import 'package:base_flutter_getx/global_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'features/home/home_route.dart';

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
  await GetStorage.init();
  await GlobalBinding().dependencies();
  await Get.find<SettingController>().onInit();
}

class App extends BaseGetWidget<SettingController> {
  final String initialRoute;
  const App({
    super.key,
    this.initialRoute = Routes.login,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ScreenUtilInit(
        builder: (ctx, child) => ShadApp.custom(
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: ThemeMode.system,
          appBuilder: (context) {
            return GetMaterialApp(
              initialRoute: initialRoute,
              getPages: [
                homeRoute,
                loginRoute,
              ],
              defaultTransition: Transition.cupertino,
              transitionDuration: const Duration(milliseconds: 800),
              debugShowCheckedModeBanner: false,
              theme: Theme.of(context),
              translations: AppTranslation(),
              locale: controller.currentLocale,
              localizationsDelegates: const [
                GlobalShadLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              builder: (context, child) {
                return ShadAppBuilder(child: child!);
              },
            );
          },
        ),
      ),
    );
  }
}
