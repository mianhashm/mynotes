import 'package:course/constants/routes.dart';
import 'package:course/services/auth/auth-exceptions.dart';
import 'package:course/services/auth/auth-service.dart';
import 'package:course/util/show-error-dialogue.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

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
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter Your Email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Enter Your Password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text.trim();
              final password = _password.text;

              try {
                final userCredential = await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //if user is verified
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  //if user is not verified
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                }
                devtools.log(userCredential.toString());
              } on userNotFoundAuthException {
                await showErrorDialogue(
                  context,
                  "User not found. Please check your email and try again.",
                );
              } on wrongPasswordAuthException {
                await showErrorDialogue(
                  context,
                  "Incorrect password. Please try again.",
                );
              } on invalidEmailAuthException {
                await showErrorDialogue(
                  context,
                  "Invalid email format. Please check your email and try again.",
                );
              } on genericAuthException {
                await showErrorDialogue(
                  context,
                  "An error occurred during login. Please try again later.",
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Not registered? Register here!"),
          ),
        ],
      ),
    );
  }
}
