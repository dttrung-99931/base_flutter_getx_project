import 'package:base_flutter_getx/core/base/base_model.dart';
import 'package:base_flutter_getx/core/constants/constants.dart';
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/core/error/network_error.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../error/exceptions/no_internet.dart';

/// Base service class for handling API calls
abstract class ApiService extends GetConnect implements GetxService{
  ApiService() {
    // TODO: get from config
    baseUrl = 'https://localhost:5001';
    allowAutoSignedCert = true;
  }

  
  /// Http Get method
  ///
  /// throw [NoInternetException] if [requireNetwrok] = true (defualt = true)
  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    bool requireNetwrok = true,
  }) async {
    var response = await super.get(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );

    if (requireNetwrok && response.status.connectionError) {
      throw NoInternetException();
    }

    return response;
  }

  Future<Either<AppError, T>> handleResponse<T>({
    required Future<Response<ResponseWrapper<T>>> responseFuture,
    bool requireNetwrok = true,
    bool allowSuccessNullBody = false,
  }) async {
    Response<ResponseWrapper<T>> response = await responseFuture;
    if (requireNetwrok && response.status.connectionError) {
      return Left(NetworkError());
    }

    if (Constants.sucessfulStatusCodes.contains(response.statusCode) &&
        (allowSuccessNullBody || response.body?.data != null)) {
      return Right(response.body?.data as T);
    }
    return Left(
      ServerError(
        message: response.body?.message ?? 'Server error',
        statusCode: response.status.code ?? -1,
      ),
    );
  }
}
