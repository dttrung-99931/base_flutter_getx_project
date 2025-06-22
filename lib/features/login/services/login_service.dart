import 'package:base_flutter_getx/core/base/api_service/api_service.dart';
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:dartz/dartz.dart';

abstract class LoginService extends ApiService {
  Future<Either<AppError, LoginResponse>> login(LoginRequestDto param);
}
