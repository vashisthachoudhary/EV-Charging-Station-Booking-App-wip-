import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isNameFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
    _nameFocusNode.addListener(() {
      setState(() {
        _isNameFocused = _nameFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user details to Firestore
        await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          // add more fields if necessary
        });
  if (!mounted) return; 
        Navigator.of(context).pushReplacementNamed("/home/");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print("Please fill all the fields.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:const Center(child: Text('Register')),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  style:const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelText: 'Name',
                    border:const OutlineInputBorder(),
                    prefixIcon:const Icon(Icons.person),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color:  Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isNameFocused ? const Color.fromARGB(255, 58, 243, 33) : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  style:const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelText: 'E-Mail',
                    hintText: 'youremail@gmail.com',
                    border:const OutlineInputBorder(),
                    prefixIcon:const Icon(Icons.email),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color:  Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isEmailFocused ? const Color.fromARGB(255, 58, 243, 33) : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  style:const TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelText: 'Password',
                    border:const OutlineInputBorder(),
                    prefixIcon:const Icon(Icons.lock),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color:  Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isPasswordFocused ? const Color.fromARGB(255, 58, 243, 33) : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    padding:const  EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle:const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  child:const Text('SIGN UP'),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil("/login/",
                    (route) => false);
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
