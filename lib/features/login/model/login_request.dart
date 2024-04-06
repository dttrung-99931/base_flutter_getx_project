import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginRequestModel {
  final String phone; 
  final String password; 
  LoginRequestModel({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'password': password,
    };
  }

  factory LoginRequestModel.fromMap(Map<String, dynamic> map) {
    return LoginRequestModel(
      phone: map['phone'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginRequestModel.fromJson(String source) => LoginRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
