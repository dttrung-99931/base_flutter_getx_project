import 'package:base_flutter_getx/core/base/api_service/base_api_service.dart';
import 'package:base_flutter_getx/core/base/base_model.dart';
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/dtos/login_response_dto.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:dartz/dartz.dart';

class LoginServiceImpl extends BaseApiService implements LoginService {
  @override
  Future<Either<AppError, LoginResponse>> login(LoginRequestDto param) async {
    final Either<AppError, LoginResponseDto> response = await handleResponse(
      responseFuture: post(
        '/v1/auth/login',
        param.toJson(),
        decoder: (data) => ResponseWrapper.dataObject(
          responseJson: data,
          dataFromJson: LoginResponseDto.fromMap,
        ),
      ),
    );

    return response.map((dto) => dto.toModel());
  }
}
