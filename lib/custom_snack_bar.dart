import 'package:flutter/material.dart';
import 'package:ichat/app_colors.dart';

class CustomSnackBar{
  void showCustomSnackBar(String text, BuildContext context){
    var snackBar = SnackBar(content: Text(text),backgroundColor: AppColors.middleShadeNavyBlue,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


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
