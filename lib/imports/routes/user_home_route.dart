import 'package:flutter/material.dart';
import 'package:client_manager/imports/widgets/search_clients.dart';
import 'package:client_manager/imports/widgets/add_client.dart';
import 'package:client_manager/imports/widgets/log_out.dart';

class UserHomeRoute extends StatefulWidget {
  const UserHomeRoute ({Key? key}) : super(key: key);

  @override
  _UserHomeRouteState createState() => _UserHomeRouteState();
}

class _UserHomeRouteState extends State<UserHomeRoute> {
  int selectedIndex = 0;
  List<dynamic> widgetOptions = [];

  @override void initState() {
    super.initState();

    widgetOptions = [
      const SearchClients(),
      const AddClient(),
      const LogOut() 
    ];
  }

  void onItemTapped( int index ) {
    setState( () => selectedIndex = index );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User home")
        ),
        body: Center(
            child: widgetOptions.elementAt(selectedIndex)
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search client",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: "Add client",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app),
                  label: "Log out",
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: onItemTapped,
        )
      );
  }
}
