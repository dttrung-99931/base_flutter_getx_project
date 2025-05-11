import 'package:base_flutter_getx/core/base/api_service/api_service.dart';
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/features/login/services/dtos/login_request.dart';
import 'package:base_flutter_getx/features/login/services/dtos/login_response.dart';
import 'package:dartz/dartz.dart';

class LoginService extends ApiService {
  Future<Either<AppError, LoginResponseDto>> login(
      LoginRequestDto param) async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(LoginResponseDto(userID: 1, token: 'token-example'));

    // TODO: call login api
    // return handleResponse(
    //   responseFuture: post(
    //     '/v1/Users/login',
    //     param.toJson(),
    //     decoder: (data) => ResponseWrapper.dataObject(
    //       responseJson: data,
    //       dataFromJson: LoginResponseDto.fromMap,
    //     ),
    //   ),
    // );
  }
}
