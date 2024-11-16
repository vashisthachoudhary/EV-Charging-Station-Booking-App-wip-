import 'package:ev_app/screens/Authentication/Forms/add_station.dart';
import 'package:ev_app/screens/Authentication/Home/home-page.dart';
import 'package:ev_app/screens/Authentication/Home/list_mystations.dart';
import 'package:ev_app/screens/Authentication/login.dart';
import 'package:ev_app/screens/Authentication/register.dart';
import 'package:ev_app/screens/Authentication/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase is already initialized
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
 
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      
      initialRoute: "/",
         routes: {
       "/": (context) => const Splash(),
         "/register/": (context) => const RegisterPage(),
         "/login/": (context) => const LoginPage(),
         "/home": (context) => const HomePage(),
         "/addevent": (context) => const AddStation(),
         "/liststations": (context) => const ListMyStations(), 
         
        
        
      //"/loginForm": (context) => const LoginPageForm(),
       
      },
   
      
    );
  }
}