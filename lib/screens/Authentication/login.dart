import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

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
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final docRef = FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid);
        final doc = await docRef.get();

        if (doc.exists) {
          Navigator.of(context).pushReplacementNamed("/home/");
        } else {
          print("Document does not exist.");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          print('FirebaseAuthException: ${e.message}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    } else {
      print("Please enter both email and password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text('Login'),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelText: 'E-Mail',
                    hintText: 'youremail@gmail.com',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isEmailFocused
                          ? const Color.fromARGB(255, 58, 243, 33)
                          : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  style: const TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isPasswordFocused
                          ? const Color.fromARGB(255, 58, 243, 33)
                          : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onPressed: login,
                  child: const Text('SIGN IN'),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil("/register/",
                    (route) => false);
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
