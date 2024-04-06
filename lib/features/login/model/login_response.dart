import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginResponseModel {
  final int userID;
  final String token;
  LoginResponseModel({
    required this.userID,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'token': token,
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      userID: map['userID'] as int,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) => LoginResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
