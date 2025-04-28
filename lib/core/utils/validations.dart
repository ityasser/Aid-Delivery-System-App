import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:aid_registry_flutter_app/core/utils/extension.dart';

import '../app.dart';

mixin Validations {

  String? validateMobile(String? value) {
    //String pattern = r'(^(((\+)|(00))?(([0-9]{1,3}))|(0))([0-9]{9})$)';
    String pattern = r'(^(((\+)|(00))?(([0-9]{1,3}))|(0)|)([0-9]{9})$)';

    // (\\+|00)
    RegExp regExp = new RegExp(pattern);
    if (value?.isEmpty??true) {
      return App.getString().requireMobile;
    } else if (!regExp.hasMatch(value??"")) {
      return App.getString().validMobile;
    }
    return null;
  }

  static bool validateMobile2(String value) {
    String pattern = r'(^(((\+)|(00))?(([0-9]{1,3}))|(0))([0-9]{9})$)';

    // (\\+|00)
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  String? validateEmpty(String? value,{String?message}) {
    if (value?.isEmpty??true) {
      return (message??App.getString().pleaseTypeHere).toTitleCase();
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+")
        .hasMatch(value??"");
    if (value?.isEmpty??true) {
      return App.getString().requiredEmail.toTitleCase();
    } else if (!emailValid) {
      return App.getString().validEmail.toTitleCase();
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return App.getString().requiredPassword.toTitleCase();
    } else if (value.length < 8) {
      return App.getString().validPassword.toTitleCase();
    }

    return null;
  }

  String? validateConfirmPassword(String value, passController) {
    if (value != passController) {
      return App.getString().password_not_match.toTitleCase();
    } else if (value.isEmpty) {
      return App.getString().confirm_password.toTitleCase();
    }
    return null;
  }
}
