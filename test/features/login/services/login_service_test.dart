import 'package:base_flutter_getx/core/base/base_model.dart';
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/features/login/dtos/login_request_dto.dart';
import 'package:base_flutter_getx/features/login/dtos/login_response_dto.dart';
import 'package:base_flutter_getx/features/login/models/login_response.dart';
import 'package:base_flutter_getx/features/login/services/login_service_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../../shared/base_test.dart';

///
/// Service test example (uncompleted)
///
/// This is uncompleted test example because it's hard to test
/// GetConnect. So skip testing service currently when implement new features
///
class MockHttpClient with Mock implements GetHttpClient {}

class TestLoginServiceImpl extends LoginServiceImpl {
  final GetHttpClient _httpClient;
  TestLoginServiceImpl(this._httpClient);
  @override
  GetHttpClient get httpClient => _httpClient;
}

void main() {
  late LoginServiceImpl loginService;
  late MockHttpClient httpClient;

  setUp(() {
    setUpTest();
    httpClient = MockHttpClient();
    loginService = TestLoginServiceImpl(httpClient);
  });

  group("Login Service", () {
    test("Login successfully when login API return success", () async {
      final request = LoginRequestDto(phone: '09882202201', password: '111');
      when(() => httpClient.post(
            '/v1/auth/login',
            body: request.toJson(),
            contentType: null,
            headers: null,
            query: null,
            decoder: any(named: 'decoder'),
            uploadProgress: null,
          )).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          body: ResponseWrapper.dataObject(
            responseJson: {
              'statusCode': 200,
              'success': true,
              'data': {'userID': 123, 'token': 'token_test'},
            },
            dataFromJson: LoginResponseDto.fromMap,
          ),
        ),
      );

      final Either<AppError, LoginResponse> result =
          await loginService.login(request);
      expect(result.isRight(), true);
      expect(result.fold((_) => null, (res) => res.token), 'token_test');
      expect(result.fold((_) => null, (res) => res.userID), 123);
    });
  });
}
