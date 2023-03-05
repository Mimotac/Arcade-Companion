import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class CustomSnackbar {
  static void showErrorSnackBar(
      GlobalKey<ScaffoldMessengerState> globalScaffoldKey) {
    globalScaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(
        "errorSnackBar".i18n(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showSnackBar(
      GlobalKey<ScaffoldMessengerState> globalScaffoldKey, String text,
      {SnackBarAction? action}) {
    globalScaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(
        text,
      ),
      action: action,
      behavior: SnackBarBehavior.floating,
    ));
  }
}
