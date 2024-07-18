import 'package:flutter/material.dart';

class SnackbarApi {
  final Duration? duration;

  SnackbarApi({this.duration});

  void snackbar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: duration ?? const Duration(milliseconds: 750),
    ));
  }

  void snackbarWithAction(
      {required BuildContext context,
      required String text,
      required String label,
      required void Function() onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 20,
      shape: const Border(top: BorderSide(color: Colors.black, width: 2)),
      content: Text(text),
      action: SnackBarAction(label: label, onPressed: onPressed),
      duration: duration ?? const Duration(milliseconds: 750),
    ));
  }
}
