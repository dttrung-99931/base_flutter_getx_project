import 'package:flutter/material.dart';

class Collections {
  static const users = "users";
  static const teams = "teams";
  static const tasks = "tasks";
  static const actions = "actions";
  static const notifications = "notifications";
}

class Fields {
  static const email = "email";
  static const teamIDs = "teamIDs";
  static const userIDs = "userIDs";
  static const pendingUserIDs = "pendingUserIDs";
  static const id = "id";
  static const notifications = "notifications";
  static const date = "date";
  static const isSeen = "isSeen";
  static const status = "status";
  static const fcmToken = "fcmToken";
  static const type = "type";
  static const referenceID = "referenceID";
  static const name = "name";
}

enum TaskStatus {
  Todo,
  Doing,
  Finish,
}

extension TaskStatusExtension on TaskStatus {
  String stringValue() {
    return this.toString().replaceFirst('TaskStatus.', '');
  }
}

const kPrimarySwatch = Colors.teal;
final kAppTheme = ThemeData(
  primarySwatch: kPrimarySwatch,
  scaffoldBackgroundColor: Colors.grey[300],
  iconTheme: IconThemeData(color: kPrimarySwatch),
  appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
  fontFamily: 'Urbanist',
);
const double kDefaultPadding = 8;
const kPageSize = 10;
