import 'dart:core';

import 'package:flutter/widgets.dart';

extension DurationExt on num {
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  Duration get minutes => Duration(seconds: (this * Duration.secondsPerMinute).round());

  Duration get hours => Duration(minutes: (this * Duration.minutesPerHour).round());

  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());

  SizedBox get wsb => SizedBox(width: toDouble());
  SizedBox get hsb => SizedBox(height: toDouble());
}
