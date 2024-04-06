
import 'dart:developer';

void logd(Object? msg, [String tag = ""]) {
  var logMsg = "";
  if (tag != "") {
    logMsg = "$tag $msg";
  } else {
    logMsg = "$msg";
  }
  log(logMsg);
}

void loge(Object? msg, [String tag = ""]) {
  logd("[ERROR] $msg");
}
