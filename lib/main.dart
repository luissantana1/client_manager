import 'package:flutter/material.dart';
import 'package:client_manager/imports/routes/all_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Avoid an exception caused by an async main

  Widget initialRoute = await const FlutterSecureStorage().read(key: "userStatus") != "logged"
      ? const LoginRoute() : const UserHomeRoute();

  MaterialApp myApp = MaterialApp(
      routes: {
        "/": (context) => initialRoute, //dynamic root route
        "/loginRoute": (context) => const LoginRoute(),
        "/signUpRoute": (context) => const SignUpRoute(),
        "/userHomeRoute": (context) => const UserHomeRoute(),
      }
  );
  runApp(myApp);
}
