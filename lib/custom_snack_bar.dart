import 'package:flutter/material.dart';

void showCustomSnackBar(String message, String title) {
  SnackBar(content: Text(message),


  );
  // Get.snackbar(
  //
  //     title,
  //     message,
  //     animationDuration: Duration(seconds: 1),
  //     titleText: Text(title),
  //     messageText: Text(
  //       message,
  //     ),
  //     duration: Duration(seconds: 2));
}