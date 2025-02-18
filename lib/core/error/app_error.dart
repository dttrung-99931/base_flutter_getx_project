// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:base_flutter_getx/core/utils/log.dart';

class AppError {
  final String message;
  final Object? exception;
  AppError({
    required this.message,
    this.exception,
  });

  void log() {
    loge('  Error');
    loge('    $runtimeType $message');

    // Log calling method
    List<String> stackTraces =
        (getStackTrace() ?? StackTrace.current).toString().split('\n');
    loge('    ${stackTraces[0]}');
    loge('    ${stackTraces[1]}');
  }

  StackTrace? getStackTrace() {
    try {
      return (exception as dynamic)?.stackTrace;
    } catch (e) {
      return null;
    }
  }
}

class UnexpectedAppError extends AppError {
  UnexpectedAppError({
    required super.message,
    super.exception,
  });
}

class ServerError extends AppError {
  final int statusCode;
  ServerError({
    required super.message,
    required this.statusCode,
    super.exception,
  });
}

class FormValidateError extends AppError {
  FormValidateError({required super.message});
}
