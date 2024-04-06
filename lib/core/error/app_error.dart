// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppError {
  final String? message;
  AppError({
    required this.message,
  });
}

class ServerError extends AppError {
  final int statusCode;
  ServerError({
    required super.message,
    required this.statusCode,
  });
}
