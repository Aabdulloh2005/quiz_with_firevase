import 'package:fayrbase_project/controllers/question_controller.dart';
import 'package:fayrbase_project/firebase_options.dart';
import 'package:fayrbase_project/providers/select_index.dart';
import 'package:fayrbase_project/services/auth_firestore_service.dart';
import 'package:fayrbase_project/views/screens/homepage.dart';
import 'package:fayrbase_project/views/screens/log_in_screen.dart';
import 'package:fayrbase_project/views/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuestionController()),
        ChangeNotifierProvider(create: (_) => SelectedAnswerProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              scaffoldBackgroundColor: const Color(0xff7F80DB),
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data;

                return data == null ? LogInScreen() : Homepage();
              },
            ));
      },
    );
  }
}
