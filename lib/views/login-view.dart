import 'package:course/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    return Container(
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
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                print(e.runtimeType);
                print(e.code);
                if (e.code == 'invalid-credential') {
                  print('Invalid Credential');
                }
              }
            },
            child: const Text("login"),
          ),
        ],
      ),
    );
  }
}
