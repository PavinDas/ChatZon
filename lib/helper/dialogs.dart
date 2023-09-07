import 'package:flutter/material.dart';

class Dialogs {

  //* Error message for network error while loging in

  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(msg),
        ),
        backgroundColor: Colors.deepPurple.withOpacity(.8),
        behavior: SnackBarBehavior.floating,
        elevation: 1,
      ),
    );
  }

  //* Circular loading animation
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: const CircularProgressIndicator(),);
      },
    );
  }
}
