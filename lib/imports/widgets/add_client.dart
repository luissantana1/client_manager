import 'package:flutter/material.dart';
import 'package:client_manager/imports/widgets/all_widgets.dart';
import 'package:client_manager/imports/helpers/form_field_validator.dart';
import 'package:client_manager/imports/helpers/web_services.dart';

class AddClient extends StatefulWidget {
  const AddClient({Key? key,}) : super(key: key);

  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final firstNameEditigController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final addressEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> addressList = [];
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
      return MyForm(
        formKey: formKey,
        children: [
          MyFormField(
              controller: firstNameEditigController, 
              hintText: "First name",
              validator: (value) {
                value?.trim();
                if (value == '') {
                  return "First name field can't be empty";
                }
                return null;
              }
          ),
          MyFormField(
              controller: lastNameEditingController, 
              hintText: "Last name",
              validator: (value) {
                value?.trim();
                if (value == '') {
                  return "Last name field can't be empty";
                } 
                return null;
              }
          ),
          MyFormField(
              controller: emailEditingController, 
              hintText: "Email",
              validator: (value) { 
                value?.trim();
                return emailValidator(email: value);
              }
          ),
          MyFormField(
              controller: addressEditingController, 
              hintText: "Address",
              validator: (value) { 
                value?.trim();
                if (value == '') {
                  return "Address field can't be empty";
                }
                return null;
              }
          ),
          Container(
              child: errorMessage != ''
                ? Text(errorMessage,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20))
                : null
          ),
          MyElevatedButton(
              hintText: "add another address",
              onPressed: () {
                setState(() {
                  if ( addressEditingController.text.isEmpty ) {
                    formKey.currentState!.validate();
                  } else {
                    setState(() {
                      addressList.add(addressEditingController.value.text.trim());
                    });
                    addressEditingController.clear();
                  }
                });
              }
          ),
          MyElevatedButton(
              hintText: "add client", 
              onPressed: () async {
                if ( formKey.currentState!.validate() ) {
                  if ( addressList.isEmpty ) {
                    addressList.add(addressEditingController.value.text.trim());
                  }
                  var response = await addClient(
                    firstName: firstNameEditigController.value.text.trim(),
                    lastName: lastNameEditingController.value.text.trim(),
                    email: emailEditingController.value.text.trim(),
                    addressList: addressList,
                  );
                  if (response == null) {
                    setState(() => errorMessage = "SERVER ERROR");

                  } else if (response == false) {
                    setState(() => errorMessage = "User or address already exists");
                    
                  } else if (response == true){
                    myAlertDialog(
                      context: context,
                      title: "New client created!",
                      message: "Add another client?",
                      onConfirmPress: () {
                        firstNameEditigController.clear();
                        lastNameEditingController.clear();
                        emailEditingController.clear();
                        addressEditingController.clear();
                        addressList.clear();
                        Navigator.of(context).pop();
                      }
                    );
                  } //else 
                } //form key validate
              } //onPressed
          )
        ]
      );
  } 
}
