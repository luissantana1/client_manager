import 'package:flutter/material.dart';
import 'package:client_manager/imports/routes/edit_client_route.dart';
import 'package:client_manager/imports/widgets/all_widgets.dart';
import 'package:client_manager/imports/helpers/web_services.dart';
import 'package:client_manager/imports/helpers/form_field_validator.dart';

class SearchClients extends StatefulWidget {
  const SearchClients ({Key? key,}) : super(key: key);

  @override
  _SearchClientsState createState() => _SearchClientsState();
}

class _SearchClientsState extends State<SearchClients> {
  TextEditingController searchEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<dynamic> futureClient = getAllClients();
  bool onConfirmPressError = false;

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
        Expanded(
              child: FutureBuilder(
              future: futureClient,
              builder: (BuildContext context, AsyncSnapshot snapshot) { 
                if (snapshot.hasError
                  || onConfirmPressError == true
                  || snapshot.connectionState == ConnectionState.none) {
                    return const Center( 
                      child: Text('Server error',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                       )
                      )
                    );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                    )
                  );
                }
                else if (snapshot.data == false)  {
                  return const Center(
                    child: Text("Client not found",
                      style: TextStyle(
                        fontSize: 25,
                      )
                    )
                 );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(5),
                  itemCount: snapshot.data.list.length,
                    itemBuilder: (context, index) {
                      String firstName = snapshot.data.list[index].firstName;
                      String lastName = snapshot.data.list[index].lastName;
                      String email = snapshot.data.list[index].email;
                      List<String> addressList = []; 

                      for(var value in snapshot.data.list[index].addressList) { 
                        addressList.add(value['address']);
                      }

                      return Card(
                          child: Column(
                            children: [
                              Row(
                              children: [
                                Expanded(
                                child: ListTile(
                                  leading: const Icon(
                                      Icons.person_search,
                                      size: 35,
                                  ),
                                  title: Text('$firstName $lastName'),
                                  subtitle: Text(email)
                                )
                              ),
                              GestureDetector( //edit client
                                child: const Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Icon(
                                    Icons.edit_note,
                                    size: 35,
                                )
                              ),
                              onTap: () {
                                List<int> addressIDList = []; 

                                for(var value in snapshot.data.list[index].addressList) { 
                                  addressIDList.add(value['id']);
                                }

                               Navigator.of(context).push(
                                 MaterialPageRoute(
                                   settings: const RouteSettings(name: '/editClientRoute'),
                                   builder: (context) => EditClientRoute(
                                     firstName: firstName,
                                     lastName: lastName,
                                     email: email,
                                     addressIDList: addressIDList, 
                                     addressList: addressList
                                   ),
                                 ),
                               );
                              }
                            ),
                            GestureDetector( //edit client
                              child: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                    Icons.delete_rounded,
                                    size: 35,
                                )
                              ),
                              onTap: () async {
                                return myAlertDialog(
                                    context: context,
                                    title: "Deleting client!",
                                    message: "Are you sure?",
                                    onConfirmPress: () async {
                                      try {
                                        var response = await deleteClient(
                                          email: snapshot.data.list[index].email
                                        );
                                        if (response == true) {
                                          futureClient = getAllClients();
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        }
                                      } catch(e) {
                                        setState(() => onConfirmPressError = true);
                                        Navigator.of(context).pop();
                                      }
                                    }
                                );
                              }
                            ),//delete
                            ]),
                              Row(
                                children:  [
                                  Expanded(
                                      child: DataTable(
                                          columns: const [
                                            DataColumn(
                                                label: Center( 
                                                    child: Text("Adress list")
                                              )
                                            )
                                          ],
                                          rows: addressList.map( (value) => 
                                            DataRow( cells: [
                                              DataCell(
                                                  Text(value)
                                              )
                                            ])
                                          ).toList()
                                      )
                                  )
                                ]
                              )
                          ])
                        );
                });
              }
            )
          ),
          MyForm(
            formKey: formKey,
            children: [
              MyFormField(
                  hintText: "Filter clients by email",
                  controller: searchEditingController,
                  validator: (value) {
                    return emailValidator(email: value?.trim());
                  }
              ),
              MyElevatedButton(
                  hintText: "Search",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      futureClient = filterClient(
                        email: searchEditingController.value.text
                      );
                      setState(() {} );

                    } else {
                      futureClient = getAllClients();
                      setState(() {});
                    }
                  }
              )
            ]
        )
    ]);
  } 
}
