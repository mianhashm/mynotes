import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //CONTROLLERS
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  //INIT BRUV
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  //DISPOSE TS
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Container(
        child: Column(
          children: [
            //email
            TextField(
              controller: _email,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Enter Your Email'),
            ),
            //Password
            TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(hintText: 'Enter Your Password'),
            ),
            //Register Button
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                  devtools.log(userCredential.toString());
                } on FirebaseAuthException catch (e) {
                  devtools.log(e.runtimeType.toString());
                  devtools.log(e.code);
                  if (e.code == 'invalid-credential') {
                    devtools.log('Invalid Credential');
                  }
                }
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/notes', (route) => false);
              },
              child: const Text("login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/register', (route) => false);
              },
              child: const Text("Not registered? Register here!"),
            ),
          ],
        ),
      ),
    );
  }
}
