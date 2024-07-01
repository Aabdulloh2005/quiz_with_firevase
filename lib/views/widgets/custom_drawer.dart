import 'package:fayrbase_project/services/auth_firestore_service.dart';
import 'package:fayrbase_project/views/screens/admin_page.dart';
import 'package:fayrbase_project/views/screens/homepage.dart';
import 'package:fayrbase_project/views/widgets/question_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff7F80DB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/images/face.gif",
              height: 120,
              width: 120,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => AdminPage(),
                ),
              );
            },
            child: const Text(
              "Admin Page",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => Homepage(),
                ),
              );
            },
            child: const Text(
              "Home",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              AuthFirestoreService().signOut();
            },
            child: const Text(
              "Sign out",
              style: TextStyle(
                color: Colors.red,
                fontSize: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
