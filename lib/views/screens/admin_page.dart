import 'package:fayrbase_project/controllers/question_controller.dart';
import 'package:fayrbase_project/models/question.dart';
import 'package:fayrbase_project/views/widgets/custom_drawer.dart';
import 'package:fayrbase_project/views/widgets/question_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  QuestionController _questionController = QuestionController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin page"),
      ),
      body: StreamBuilder(
        stream: _questionController.list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Apida error bor"),
            );
          }

          final data = snapshot.data!.docs;

          return data.isEmpty
              ? const Center(
                  child: Text("malumot yoq"),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final quiz = Question.fromJson(data[index]);
                      return ListTile(
                        onLongPress: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => QuestionForm(
                                question: quiz,
                              ),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white),
                        ),
                        tileColor: Colors.blue.withOpacity(0.2),
                        title: Text(
                          quiz.question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            _questionController.delteQuestion(quiz.id);
                          },
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => QuestionForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
