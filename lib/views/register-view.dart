import 'package:course/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("register")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                    ),
                  ),
                  //Register Button
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                        if (e.code == 'weak-password') {
                          print("password is too weak");
                        } else if (e.code == 'email-already-in-use') {
                          print("email is already in use");
                        }
                      }
                    },
                    child: const Text("register"),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
