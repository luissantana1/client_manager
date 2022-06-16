import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> myAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirmPress,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(message),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Confirm"),
              style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(20),
              textStyle: const TextStyle(fontSize: 20),
          ),
            onPressed: () => onConfirmPress()
          ),
          TextButton(
            child: const Text("Cancel"),
              style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(20),
              textStyle: const TextStyle(fontSize: 20),
          ),
            onPressed: () => Navigator.of(context).pop()
          )
        ],
      );
    },
  );
}
