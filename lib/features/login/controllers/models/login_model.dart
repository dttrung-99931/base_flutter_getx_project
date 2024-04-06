// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:base_flutter_getx/features/login/services/dtos/login_response.dart';

class LoginModel {
  final int userID;  
  final String token;  
  LoginModel({
    required this.userID,
    required this.token,
  });

  factory LoginModel.fromDto(LoginResponseDto dto){
    return LoginModel(userID: dto.userID, token: dto.token);
  }
}
