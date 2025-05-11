import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginRequestDto {
  final String phone; 
  final String password; 
  LoginRequestDto({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'password': password,
    };
  }

  factory LoginRequestDto.fromMap(Map<String, dynamic> map) {
    return LoginRequestDto(
      phone: map['phone'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginRequestDto.fromJson(String source) => LoginRequestDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
