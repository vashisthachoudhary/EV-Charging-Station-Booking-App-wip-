import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/model/user_model.dart';
import 'package:ev_app/screens/Authentication/Home/home-page.dart';
import 'package:ev_app/screens/Authentication/login.dart';
import 'package:ev_app/screens/Authentication/register.dart';
import 'package:ev_app/utils/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/register/': (context) => const RegisterPage(),  // Define RegisterPage class
        '/login/': (context) => const LoginPage(),        // Define LoginPage class
        '/home': (context) => const HomePage(),          // Define HomePage class
      },
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // Listen to auth state changes and handle navigation accordingly
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        // User not signed in, redirect to register page
        _navigateToPage("/register/");
      } else {
        // User signed in, fetch user data from Firestore
        Util.UID = user.uid;
        try {
          final docRef = FirebaseFirestore.instance.collection("users").doc(Util.UID);
          final doc = await docRef.get();
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            Util.user = AppUser.fromMap(data);
            _navigateToPage("/home");
          } else {
            _navigateToPage("/login/");
          }
        } catch (e) {
          print("Error fetching user data: $e");
          _navigateToPage("/login/");
        }
      }
    });
  }

  // Function to handle page navigation with delay
  void _navigateToPage(String route) {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Splash Page",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
