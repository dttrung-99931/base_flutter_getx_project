import 'package:base_flutter_getx/core/base/api_service.dart';
import 'package:base_flutter_getx/core/base/base_model.dart';
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/features/login/model/login_request.dart';
import 'package:base_flutter_getx/features/login/model/login_response.dart';
import 'package:dartz/dartz.dart';

class LoginService extends ApiService {
  Future<Either<AppError, LoginResponseModel>> login(
      LoginRequestModel param) async {
    return handleResponse(
      responseFuture: post(
        '/v1/Users/login',
        param.toJson(),
        decoder: (data) => ResponseWrapper.fromMap(
          data,
          LoginResponseModel.fromMap,
        ),
      ),
    );
  }
}
