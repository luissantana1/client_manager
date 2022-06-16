import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:client_manager/imports/widgets/my_elevated_button.dart';
import 'package:client_manager/imports/widgets/my_alert_dialog.dart';
import 'package:client_manager/imports/helpers/web_services.dart';

class EditClientRoute extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final List<int> addressIDList;
  final List<String> addressList;

  const EditClientRoute({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.addressIDList,
    required this.addressList
  }) : super(key: key);

  @override
  _EditClientRouteState createState() => _EditClientRouteState();
}

class _EditClientRouteState extends State<EditClientRoute> {
  final firstNameEditigController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> addressControllerList = [];
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    firstNameEditigController.text = widget.firstName;
    lastNameEditingController.text = widget.lastName;

    for(var addressText in widget.addressList) { 
      final controller = TextEditingController();
      controller.text = addressText;
      addressControllerList.add(controller);
    }

    return Scaffold(
        appBar: AppBar( title: const Text("Edit client") ),
        body: Padding(
            padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView( 
                    child: Form(
                      key: formKey,
                      child: Card(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(
                              child: Icon(
                                  Icons.person,
                                  size: 50,
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                bottom: 5,
                              ),
                                child: TextFormField(
                                        controller: firstNameEditigController,
                                        validator: (value) {
                                          value!.trim();
                                          if ( value == '' ) {
                                            return "First name field can't be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            labelText: "First name",
                                        )
                                    )
                                ),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                bottom: 5,
                              ),
                              child: TextFormField(
                                  controller: lastNameEditingController,
                                  validator: (value) {
                                    value!.trim();
                                    if (value == "") { 
                                      return "Last name field can't be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Last name"
                                  )
                              )
                          ),
                          ListView.builder(
                            shrinkWrap: true, // Use  children total size                
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: 5,
                            ),
                            itemCount: widget.addressList.length,
                            itemBuilder: (context, index) {
                              int addressIndex = index + 1;
                              return Column(
                                children: [
                                  addressControllerList.length == 1 ?
                                   Container()
                                   : IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 25,
                                      onPressed: () {
                                        myAlertDialog(
                                          context: context,
                                          title: "Removing address",
                                          message: "Are you sure?",
                                          onConfirmPress: () async {
                                            try {
                                              var response = await deleteAddress(id: widget.addressIDList[index].toInt());
                                              if ( response == false ) {
                                                setState( () => errorMessage == "SERVER ERROR"); 

                                              } else if (response == true ) {
                                                setState( () {
                                                  widget.addressList.removeAt(index);
                                                  addressControllerList.removeAt(index);
                                                });
                                              } 
                                              Navigator.of(context).pop();
                                            } catch(e) {
                                              setState(() => errorMessage = "SERVER ERROR");
                                            }
                                          } 
                                        ); 
                                      }
                                    ),
                                  TextFormField(
                                        controller: addressControllerList[index],
                                        validator: (value) {
                                          value!.trim();
                                          if (value == '') {
                                            return "Address field can't be empty";
                                          } else {
                                            return null; 
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Address $addressIndex",
                                        ),
                                  ),
                              ]);
                            }
                          ),
                        ]
                    )
                )
              ) 
            ),
            errorMessage != ''
              ? Text(errorMessage,
                  style: const TextStyle(
                    fontSize: 20,
                      color: Colors.red,
                     ))
                 : Container(),
             MyElevatedButton(
                 hintText: "Edit client",
                 onPressed: () async {
                   List<String> addressTextList = [];

                   for(var controller in addressControllerList) { 
                     addressTextList.add(controller.value.text.trim());
                   }
                   
                   if (widget.firstName == firstNameEditigController.value.text.trim()
                       && widget.lastName == lastNameEditingController.value.text.trim()
                       && listEquals(widget.addressList, addressTextList) 
                   ) {
                     setState(() => errorMessage = "No values where changed ");
                     
                   } else if ( formKey.currentState!.validate() ) {
                     var response = await editClient(
                         firstName: firstNameEditigController.value.text,
                         lastName: lastNameEditingController.value.text,
                         email: widget.email,
                         addressList: addressTextList
                     );
                   }
                 } 
             )
          ])
        )
      )
    );
  } 
}
