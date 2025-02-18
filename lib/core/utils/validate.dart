import 'dart:math' as math;

import 'package:base_flutter_getx/core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Validate {
  static String? email(String? email, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && isNullOrEmpty(email)) {
      return null;
    }
    if (isNullOrEmpty(email)) {
      return 'messages.email_is_required'.tr;
    }
    if (!isValidEmail(email!)) {
      return 'messages.please_enter_valid_email'.tr;
    }
    return null;
  }

  static String? phone(String? phone, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && isNullOrEmpty(phone)) {
      return null;
    }
    // if (isNullOrEmpty(phone)) {
    //   return 'messages.enter_phone'.tr;
    // }
    // if (!isNumeric(phone ?? '0')) {
    //   return 'messages.only_enter_number_temp'.tr(args: ['common.phone_num'.tr]);
    // }
    if (!isValidPhone(phone!)) {
      return 'SĐT không hợp lệ';
    }
    return null;
  }

  static String? fax(String? fax, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && isNullOrEmpty(fax)) {
      return null;
    }
    if (!isNullOrEmpty(fax) && !isValidNumber(fax!)) {
      return 'messages.invalid_fax'.tr;
    }
    return null;
  }

  static String? pass(String? pass, {bool enableNullOrEmpty = false}) {
    // if (pass == Constatnts.presentPassword || (enableNullOrEmpty && isNullOrEmpty(pass))) {
    //   return null;
    // }

    if (isNullOrEmpty(pass)) {
      return 'Nhập mật khẩu'.tr;
    }

    if (!isValidPass(pass!)) {
      return 'Mật khẩu không hợp lệ'.tr;
    }

    return null;
  }

  static String? postalCode(String? postalCode) {
    if (isNullOrEmpty(postalCode) ||
        postalCode!.length != /* Constatnts.postalCodeLength */ 8) {
      return 'messages.is_required'.tr;
    }
    return null;
  }

  static String? number(
    String? number, {
    String fieldName = '',
    bool enableNullOrEmpty = false,
    String invalidMessage = 'messages.only_enter_number_temp',
    int? lengthRequired,
  }) {
    if (enableNullOrEmpty && isNullOrEmpty(number)) {
      return null;
    }

    if (isNullOrEmpty(number)) {
      return 'messages.is_required'.tr;
    }

    // if ((lengthRequired != null && number.toStringEmptyIfNull().length != lengthRequired) || !isNumeric(number!)) {
    //   return invalidMessage.tr(args: [fieldName.tr]);
    // }

    return null;
  }

  static String? confirmPass(
      {required String pass,
      required String confirmPass,
      required String fieldName}) {
    if (pass != confirmPass) {
      // return 'messages.comfirm_pass_not_match'.tr;
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isValidFax(String fax) {
    return RegExp(r'^\+?[0-9]{6,}$').hasMatch(fax);
  }

  static bool isValidNumber(String fax) {
    return RegExp(r'^[0-9]+$').hasMatch(fax);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,11}$)').hasMatch(phone);
  }

  static bool isValidPass(String pass) {
    return RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+){8,16}$')
        .hasMatch(pass);
  }

  static bool isNumeric(String text, {bool? allowDot = true}) {
    if (allowDot! && text.endsWith('.')) {
      return false;
    }
    try {
      double.parse(text);
    } on FormatException {
      return false;
    }
    return true;
  }

  static bool isUuid(String uuid) {
    return RegExp(
            r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')
        .hasMatch(uuid.toLowerCase());
  }

  static String? validateRequired(String? text, {required String fieldName}) {
    if (text == null || text.isEmpty) {
      return 'Nhập $fieldName'; // TODO
      // TODO: localization
      // return tr('messages.is_required', args: [fieldName.tr]);
    }
    return null;
  }

  static String? validateRequiredCondition(bool isValid,
      {required String fieldName}) {
    if (!isValid) {
      // TODO: localization
      // return tr('messages.is_required', args: [fieldName.tr]);
      return 'Nhập $fieldName'; // TODO
    }
    return null;
  }

  static TextInputFormatter get code39InputFormatter {
    return FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 -]'));
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    this.decimalrange,
    this.beforedecimalrange,
  }) : assert(decimalrange == null ||
            decimalrange > 0 ||
            beforedecimalrange == null ||
            beforedecimalrange > 0);

  final int? decimalrange;
  final int? beforedecimalrange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    TextSelection newselection = newValue.selection;
    String truncated = newValue.text;
    String value;
    if (newValue.text.contains(RegExp(r'[0-9$.]'))) {
      if (beforedecimalrange != null) {
        value = newValue.text;
        if (value.contains(".")) {
          if (value.split(".")[0].length > beforedecimalrange!) {
            truncated = oldValue.text;
            newselection = oldValue.selection;
          }
        } else {
          if (value.length > beforedecimalrange!) {
            truncated = oldValue.text;
            newselection = oldValue.selection;
          }
        }
      }
      if (decimalrange != null) {
        value = newValue.text;
        if (value.contains(".") &&
            value.substring(value.indexOf(".") + 1).length > decimalrange!) {
          truncated = oldValue.text;
          newselection = oldValue.selection;
        } else if (value == ".") {
          truncated = "0.";
          newselection = newValue.selection.copyWith(
            baseOffset: math.min(truncated.length, truncated.length + 1),
            extentOffset: math.min(truncated.length, truncated.length + 1),
          );
        }
        return TextEditingValue(
          text: truncated,
          selection: newselection,
          composing: TextRange.empty,
        );
      }
    }

    return newValue;
  }
}
