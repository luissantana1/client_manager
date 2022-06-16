import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client_manager/imports/widgets/my_elevated_button.dart';
import 'package:client_manager/imports/widgets/my_alert_dialog.dart';

class LogOut extends StatelessWidget {
  const LogOut({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                children: [
                  const Text("Go back to login screen"),
                  MyElevatedButton(
                      hintText: "Log Out",
                      onPressed: () {
                        myAlertDialog(
                            context: context,
                            title: "Going back to login",
                            message:"Are you sure?",
                            onConfirmPress: () {
                              const FlutterSecureStorage().delete(key: "userStatus");
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed("/loginRoute");
                            }
                        );
                      }
                  )
                ]
            )
        )
    );
  }
}
