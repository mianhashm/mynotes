import 'package:course/constants/routes.dart';
import 'package:course/services/auth/auth-service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Container(
        child: Column(
          children: [
            Text(
              "We have sent you a verification email, please open it to verify your account",
            ),
            Text(
              "If you have not recieved an email yet, click the button below",
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text("Verify Email"),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}
