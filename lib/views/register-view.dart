import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text("Register")),
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
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text("Already registered? Login here!"),
            ),
          ],
        ),
      ),
    );
  }
}
