import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:base_flutter_getx/core/exceptions/no_internet.dart';
import 'package:base_flutter_getx/core/utils/utils.dart';

import 'error_report_service.dart';

class ExceptionHandler {
  static void handleAsyncError(Object exception, [StackTrace? stackTrace]) {
    logd('Handle Async Error');
    handleError(exception, stackTrace);
  }

  static void handleSyncError(FlutterErrorDetails details) {
    logd('Handle Sync Error');
    reportError(details.exception);
  }

  static void handleError(Object exception, [StackTrace? stackTrace]) {
    if (exception is NoInternetException) {
      logd('No internet exception');
    } else {
      logd('Unknown exception $exception');
    } 
    reportError(exception, stackTrace);
  }

  static void reportError(Object exception, [StackTrace? stackTrace]) {
    try {
      final errorReportService = Get.find<ErrorReportService>();
      errorReportService.reportError(exception.toString(), stackTrace.toString());
    } catch (e) {
      loge(e.toString());
    }
  }

  static Widget errorWidgetBuilder(FlutterErrorDetails details) {
    return const Text('Something went wrong.');
  }
}
