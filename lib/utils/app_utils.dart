import 'package:changemaker_flutter_app/main.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      showCloseIcon: true,
    );
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
