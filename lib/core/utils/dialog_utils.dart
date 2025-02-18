import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showAlertDialog(String alertMsg, Function onYes) async {
  var alertDialog = AlertDialog(
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("NO"),
      ),
      TextButton(
        onPressed: () {
          Get.back();
          onYes();
        },
        child: const Text("YES"),
      ),
    ],
    title: Text(alertMsg),
  );
  await Get.dialog(alertDialog);
}
