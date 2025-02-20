import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginResponseDto {
  final int userID;
  final String token;
  LoginResponseDto({
    required this.userID,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'token': token,
    };
  }

  factory LoginResponseDto.fromMap(Map<String, dynamic> map) {
    return LoginResponseDto(
      userID: map['userID'] as int,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseDto.fromJson(String source) => LoginResponseDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
