import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final emptyConditions = ['', 0, []];
bool isNullOrEmpty(dynamic obj) {
  return obj == null || emptyConditions.contains(obj);
}

void removeCurrentFocus() async {
  FocusManager.instance.primaryFocus?.unfocus();
}

Future delay(Duration duration) async {
  await Future.delayed(duration);
}

bool isNumeric(String str) {
  try {
    double.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}

Future delayMilis(int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}

Color? hexToColor(String? code) {
  if (code == null) return null;
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

void doOnBuildUICompleted(void Function() action) {
  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    action();
  });
}

// void doIfLoggedIn(void Function() action) {
// }

bool isSubtype<S, T>() => <S>[] is List<T>;
