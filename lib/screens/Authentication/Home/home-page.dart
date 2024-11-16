import 'package:ev_app/screens/Authentication/Forms/add_station.dart';
import 'package:ev_app/screens/Authentication/Home/discover_stations.dart';
import 'package:ev_app/screens/Authentication/Home/list_mystations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> widgets = [
    const Text("LOCATION WITH MAP"), // 0
   // const Text("ALL EV STATIONS"), // 1
    //const AddStation(),
    const ListMyStations(),
    const ListAllStations(),

    //const Text("MY EV STATIONS"), // 2
    const Text("PROFILE PAGE"), // 3
  ];

  final List<BottomNavigationBarItem> navBaritems = [
    const BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: Icon(Icons.add_location),
        label: "LOCATION"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.home), label: "HOME"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.cable_outlined), label: "STATIONS"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
  ];

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Ensure that the context is still valid and widget is mounted before navigation
      if (mounted) {
        // We are using the context right here after awaiting async operation
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed("/login/");
        }
      }
    } catch (e) {
      print("Error during sign out: $e");
    }
  }


  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 195, 247),
      appBar: AppBar(
        title: const Text(
          "VOLT VENTURE",
          style: TextStyle(
            color: Color.fromARGB(255, 80, 189, 240),
            fontSize: 16,
            backgroundColor: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showLogOutDialog(context,logout);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(child: widgets[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: navBaritems,
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 80, 189, 240),
        unselectedItemColor: Colors.white,
        onTap: onItemSelected,
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context,Function logout) {
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title:const Text("Sign out"),
        content: const Text("Are you sure you want to sign out"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text("Cancel")),
          TextButton(onPressed: (){
            logout(context);
            Navigator.of(context).pop(true);
          }, child: const Text("Log Out")),
        ],
      );
    }
  ).then((value) => value ?? false);
}