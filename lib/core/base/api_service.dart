import 'package:get/get.dart';
import '../exceptions/no_internet.dart';

/// Base service class for handling API calls   
abstract class ApiService extends GetConnect {
  
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
}
