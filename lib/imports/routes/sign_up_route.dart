import 'package:flutter/material.dart';
import 'package:client_manager/imports/widgets/all_widgets.dart';
import 'package:client_manager/imports/helpers/form_field_validator.dart';
import 'package:client_manager/imports/helpers/web_services.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({Key? key}) : super(key: key);

  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
      return Scaffold(
              appBar: AppBar( title: const Text("Sign Up") ),
              body: MyForm( 
                      formKey: formKey,
                      children: [
                        MyFormField( //email input
                            controller: emailEditingController,
                            hintText: "Email",
                            validator: (value) { //require null safety to trim
                              return emailValidator( email: value?.trim() ); 
                            },
                        ),
                        MyFormField( //password input
                            controller: passwordEditingController,
                            hintText: "Passsword",
                            obscureText: true,//optional parameter 
                            validator: (value) {
                              value?.trim();
                              return passwordValidator(password: value?.trim());
                            }
                        ),
                        MyFormField(//confirm password
                            controller: confirmPasswordEditingController,
                            hintText: "Confirm password",
                            obscureText: true,
                            validator: (value) {
                              value?.trim();
                              return confirmPasswordValidator(
                                  password: passwordEditingController.text,
                                  confirmPassword: value?.trim());
                            }
                        ),
                        Container( //Error message
                            child: errorMessage != ''
                              ? Text(errorMessage, 
                                  style: const TextStyle(
                                      color: Colors.red, 
                                      fontSize: 20)) 
                              : null
                        ),
                        MyElevatedButton(
                            hintText: "Sign up",
                            onPressed: () async {
                              if ( formKey.currentState!.validate() ){
                                var response = await handleUser(
                                    email: emailEditingController.value.text,
                                    password: passwordEditingController.value.text,
                                    path: '/sign_up'
                                );

                                if ( response == null ) {
                                  setState( () => errorMessage = "Server error" );

                                } else if ( response == false ) {
                                  setState( () => errorMessage = "User already exists!" );

                                } else if ( response == true ) {
                                  return myAlertDialog(
                                      context: context,
                                      title: "New user created!",
                                      message: "Please go back to login",
                                      onConfirmPress: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacementNamed("/loginRoute");
                                      }
                                  );
                                }
                              } //if validate form state
                            }//onPressed
                        ),
                  ]
              ) 
            );
          }
  }
