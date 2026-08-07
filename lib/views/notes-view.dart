import 'package:course/constants/routes.dart';
import 'package:course/enums/menu-actions.dart';
import 'package:course/services/auth/auth-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuActions>(
            onSelected: (value) async {
              switch (value) {
                case MenuActions.logout:
                  final shouldlogout = await showlogoutDialogue(context);
                  if (shouldlogout == true) {
                    await AuthService.firebase().logOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(value: MenuActions.logout, child: Text("logout")),
              ];
            },
          ),
        ],
      ),
    );
  }
}

Future<bool?> showlogoutDialogue(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("logout"),
          ),
        ],
      );
    },
  );
}
