# Service test

Test the real service implementation. Do not `when(() => service.httpClient)`. `GetConnect.httpClient` is a getter, and `when` only works on a `Mock`.

Override the getter in a test subclass, then stub `post` with the same named arguments the service passes. `any(named: 'decoder')` matches a decoder that was passed. It does not mean the name is optional.

The stub replaces `post`, so GetX never runs the decoder. Return a `Response` whose body is already the decoded wrapper.

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

// Host types.
import 'package:app/core/app_error.dart';
import 'package:app/core/response_wrapper.dart';
import 'package:app/features/login/login_request.dart';
import 'package:app/features/login/login_response.dart';
import 'package:app/features/login/login_response_dto.dart';
import 'package:app/features/login/login_service_impl.dart';

class MockHttpClient with Mock implements GetHttpClient {}

// LoginServiceImpl.httpClient has no setter. This subclass is the stub point.
class TestLoginServiceImpl extends LoginServiceImpl {
  TestLoginServiceImpl(this._httpClient);

  final GetHttpClient _httpClient;

  @override
  GetHttpClient get httpClient => _httpClient;
}

void main() {
  late LoginServiceImpl loginService;
  late MockHttpClient httpClient;

  setUpAll(() {
    // post<T> takes a decoder. Register a fallback so any(named: 'decoder') works.
    registerFallbackValue(
      (dynamic _) => ResponseWrapper<LoginResponseDto>.empty(),
    );
  });

  setUp(() {
    httpClient = MockHttpClient();
    loginService = TestLoginServiceImpl(httpClient);
  });

  void stubPost(Response<ResponseWrapper<LoginResponseDto>> response) {
    final request = LoginRequest(phone: '09882202201', password: '111');
    when(
      () => httpClient.post<ResponseWrapper<LoginResponseDto>>(
        '/v1/auth/login', // The path login() actually posts to.
        body: request.toJson(),
        contentType: null,
        headers: null,
        query: null,
        decoder: any(named: 'decoder'),
        uploadProgress: null,
      ),
    ).thenAnswer((_) async => response);
  }

  group('Login service', () {
    final request = LoginRequest(phone: '09882202201', password: '111');

    test('returns Right when the API status is success', () async {
      stubPost(
        Response(
          statusCode: 200,
          body: ResponseWrapper.data(
            data: LoginResponseDto(userID: 123, token: 'token_test'),
          ),
        ),
      );

      final Either<AppError, LoginResponse> result =
          await loginService.login(request);

      expect(result.isRight(), true);
      expect(result.fold((_) => null, (res) => res.token), 'token_test');
    });

    test('returns ServerError when the API status is an error', () async {
      stubPost(const Response(statusCode: 400, body: null));

      final Either<AppError, LoginResponse> result =
          await loginService.login(request);

      expect(result.isLeft(), true);
      expect(result.fold((error) => error, (_) => null), isA<ServerError>());
    });
  });
}
```
