

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

/// contains all snackbar templates
class AppSnackbar {
  static void showMessage(String msg) {
    final context = Get.context;
    if (context == null) return;

    final snackBar = SnackBar(
      content: Text(msg),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showNotification({
    required String title,
    required String message,
    Widget? icon,
  }) {
    Get.snackbar(
      title,
      message,
      icon: icon,
      backgroundColor: Colors.white,
    );
  }
}
