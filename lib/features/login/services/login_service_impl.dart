
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/dtos/login_response_dto.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:dartz/dartz.dart';

class LoginServiceImpl extends LoginService {
  @override
  Future<Either<AppError, LoginResponse>> login(
      LoginRequestDto param) async {
    await Future.delayed(const Duration(seconds: 1));
    final dto = LoginResponseDto(userID: 1, token: 'token-example');
    return Right(dto.toModel());

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
