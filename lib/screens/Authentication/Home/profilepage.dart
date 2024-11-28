import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/utils/util.dart';
import 'package:ev_app/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser user = AppUser.getAppUserEmptyObject();
  String userRole = "";

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    if (Util.UID != null && Util.UID.isNotEmpty) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(Util.UID)
            .get();

        if (userDoc.exists) {
          setState(() {
            user = AppUser.fromMap(userDoc.data() as Map<String, dynamic>);
            userRole = userDoc['role'] ?? "User"; // Default to "User" if role is not defined
          });
        } else {
          print("User document does not exist.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("Error: Util.UID is null or empty.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display User Name
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  "Name: ${user.name}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display User Email
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  "Email: ${user.email}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display User Role
            Row(
              children: [
                const Icon(Icons.security, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  "Role: ${userRole.isNotEmpty ? userRole : "User"}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}