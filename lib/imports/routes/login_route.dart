import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client_manager/imports/widgets/all_widgets.dart';
import 'package:client_manager/imports/helpers/web_services.dart';
import 'package:client_manager/imports/helpers/form_field_validator.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute ({Key? key}) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
      return Scaffold(
              appBar: AppBar( title: const Text("Login") ),
              body: MyForm(
                  formKey: formKey,
                  children: [
                    MyFormField( //email input
                        controller: emailEditingController,
                        hintText: "Email",
                        validator: (value) {
                          return emailValidator(email: value?.trim());
                        },
                    ),
                    MyFormField( //password input
                        controller: passwordEditingController,
                        hintText: "Passsword",
                        obscureText: true,//optional parameter
                        validator: (value) {
                          return passwordValidator(password: value?.trim());
                        }
                    ),
                    Container( //errorMessage
                        child: errorMessage != ''
                          ? Text(errorMessage, 
                              style: const TextStyle(
                                  color: Colors.red, 
                                  fontSize: 20)) 
                          : null
                    ),
                    MyElevatedButton(
                        hintText: "Login",
                        onPressed: () async {
                          if ( formKey.currentState!.validate() ){
                            var response = await handleUser(
                                email: emailEditingController.value.text,
                                password: passwordEditingController.value.text,
                                path: '/login'
                            );
                            if ( response == null ) {
                              setState( () => errorMessage = "Server error");

                            } else if ( response == false ) {
                              setState( () => errorMessage = "User not found");

                            } else if ( response == true ){
                              const FlutterSecureStorage().write(
                                key: "userStatus", 
                                value: "logged"
                              );
                              Navigator.of(context).pushReplacementNamed('/userHomeRoute');
                            }
                        } 
                      }//onPressed
                    ),
                    Container( //text
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text("New user?",
                        style: TextStyle(fontSize: 20)
                    )),
                    MyElevatedButton(
                        hintText: "Sign up",
                        color: Colors.blueGrey,
                        onPressed: () {
                          Navigator.of(context).pushNamed("/signUpRoute");
                        }
                    ),
                  ]
              )
            );
          }
}
