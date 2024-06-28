import 'package:fayrbase_project/views/screens/homepage.dart';
import 'package:fayrbase_project/views/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DrawerHeader(
            child: SizedBox(),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => QuestionForm(),
                ),
              );
            },
            child: const Text("Admin Page"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => Homepage(),
                ),
              );
            },
            child: const Text("Home"),
          ),
        ],
      ),
    );
  }
}
