import 'package:course/constants/routes.dart';
import 'package:course/services/auth/auth-exceptions.dart';
import 'package:course/services/auth/auth-service.dart';
import 'package:course/util/show-error-dialogue.dart';
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
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on weakPasswordAuthException {
                  await showErrorDialogue(context, "Password is too weak");
                } on emailAlreadyInUseAuthException {
                  await showErrorDialogue(context, "Email is already in use");
                } on invalidEmailAuthException {
                  await showErrorDialogue(context, "Invalid email");
                } on genericAuthException {
                  await showErrorDialogue(context, "Something went wrong");
                }
              },
              child: const Text("register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already registered? Login here!"),
            ),
          ],
        ),
      ),
    );
  }
}
