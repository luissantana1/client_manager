import 'package:http/http.dart' as http;
import 'dart:convert';

//String url = Your server ip here example: "http://xxx.xxx.xxx.xxx:xxx"

class Client{
  String firstName;
  String lastName;
  String email;
  List addressList;

  Client({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.addressList
  });
 
  factory Client.fromJson(Map<String, dynamic> decodedJson) {
    return Client(
      firstName: decodedJson['first_name'],
      lastName: decodedJson['last_name'],
      email: decodedJson['email'],
      addressList: [ ...decodedJson['address_list']],
    );
  }
}

class ClientList {
  List<Client> list;

  ClientList({
    required this.list
  });

  factory ClientList.fromJson(List<dynamic> decodedJson) {
    List<Client> clients = decodedJson.map( (client) => 
      Client.fromJson(client) ).toList();

    return ClientList(
      list: [...clients] 
    );
  }
}

Future<dynamic> filterClient({required String email}) async {
  final response = await http.post(
    Uri.parse("$url/filter_client"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'email': email}),
  );
  if (response.statusCode == 404) {
    return false;
  } else if (response.statusCode == 200) {
    return ClientList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception;
  }
}

Future<dynamic>getAllClients() async {
    final response = await http.get(
      Uri.parse("$url/get_all_clients")
    );
    if ( response.statusCode == 200 ) {
      return ClientList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception;
    }
}

Future<dynamic> addClient({
  required String firstName,
  required String lastName,
  required String email,
  required List<String> addressList
}) async {
  try {
   final response = await http.post(
     Uri.parse("$url/add_client"),
     headers: <String, String>{
       'Content-Type': 'application/json; charset=UTF-8',
     },
     body: jsonEncode({
       'firstName': firstName,
       'lastName': lastName,
       'email': email,
       'addressList': addressList,
     }),
   );
   if (response.statusCode == 404) {
     return false;
   } else if (response.statusCode == 200) {
     return true;
   } 
  } catch(e) {
    return null;
  }
}

Future<dynamic> editClient({
  required String firstName,
  required String lastName,
  required String email,
  required List<String> addressList
}) async {
  try {
   final response = await http.post(
     Uri.parse("$url/edit_client"),
     headers: <String, String>{
       'Content-Type': 'application/json; charset=UTF-8',
     },
     body: jsonEncode({
       'firstName': firstName,
       'lastName': lastName,
       'email': lastName,
       'addressList': addressList,
     }),
   );
   if (response.statusCode == 404) {
     return false;
   } else if (response.statusCode == 200) {
     return true;
   } 
  } catch(e) {
    return null;
  }
}

Future<dynamic> deleteClient({required String email}) async {
  final response = await http.post(
    Uri.parse("$url/delete_client"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'email': email}),
  );
  if (response.statusCode == 404) {
    return false;
  } else if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception;
  }
}

Future<dynamic> deleteAddress({required int id}) async {
  final response = await http.post(
    Uri.parse("$url/delete_address"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'id': id}),
  );
  if (response.statusCode == 404) {
    return false;
  } else if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception;
  }
}

Future<dynamic> handleUser({
  required String email,
  required String password,
  required String path
}) async {
  try {
    final response = await http.post(
      Uri.parse(url + path),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password
      }),
    );
    if (response.statusCode == 404) {
      return false;
    } else if ( response.statusCode == 200 ) {
      return true;
    }
  } catch(e) {
    return null;
  }
}
