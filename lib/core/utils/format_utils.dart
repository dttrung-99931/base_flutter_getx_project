String formatHourMin(int durationInMinutes) {
  int hours = durationInMinutes ~/ 60;
  int minues = durationInMinutes % 60;
  if (hours > 0) {
    return '${hours}h$minues';
  } else {
    return '${minues}m';
  }
}

String formatMovingDistance(int totalMetters, remainingMetters) {
  String totalKms = (totalMetters / 1000).toStringAsFixed(1);
  String passedKms =
      ((totalMetters - remainingMetters) / 1000).toStringAsFixed(1);
  return '$passedKms / ${totalKms}km';
}
