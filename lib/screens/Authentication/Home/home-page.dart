import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/Authentication/Forms/add_station.dart';
import 'package:ev_app/screens/Authentication/Home/discover_stations.dart';
import 'package:ev_app/screens/Authentication/Home/list_mystations.dart';
import 'package:ev_app/screens/Authentication/Home/profilepage.dart';
import 'package:ev_app/screens/Authentication/Home/viewBookings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int selectedIndex = 1;
  String userRole = ""; // Track user role
  List<Widget> widgets = []; // Initialize an empty list for widgets
  List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: Icon(Icons.add_location),
        label: "LOCATION"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.cable_outlined), label: "STATIONS"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.person), label: "PROFILE"),
  ];
  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userRole = userDoc.data()!['role'] ?? "user"; // Default to "user"
          // Set the appropriate widgets based on the user role
          widgets = userRole == "admin" 
            ? [
                const Text("LOCATION WITH MAP"), // 0
                const ListMyStations(), // Admin-specific
                // ListAllStations(userRole: userRole), // 2
                // const Text("PROFILE PAGE"), // 3
                const ProfilePage(),
              ]
            : [
                const Text("LOCATION WITH MAP"), // 0
                ListAllStations(userRole: userRole), // 1
                const ViewBookingsPage(), // 2
                // const Text("PROFILE PAGE"), // 2
                const ProfilePage(),
              ];
          if (userRole == "user") {
            navBarItems = [
                const BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.add_location),
                    label: "LOCATION"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.cable_outlined), label: "STATIONS"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.book), label: "BOOKINGS"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "PROFILE"),
                
              ];
        }});
      }
    }
  }


  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed("/login/");
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "VOLT VENTURE",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showLogOutDialog(context, logout);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: userRole.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading while fetching role
          : Center(child: widgets[selectedIndex]), // Display the correct widget based on role
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: navBarItems,
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 80, 189, 240),
        unselectedItemColor: Colors.white,
        onTap: onItemSelected,
      ),
    );
  }
}


Future<bool> showLogOutDialog(BuildContext context, Function logout) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                logout(context);
                Navigator.of(context).pop(true);
              },
              child: const Text("Log Out")),
        ],
      );
    },
  ).then((value) => value ?? false);
}
