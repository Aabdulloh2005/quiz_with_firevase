import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fayrbase_project/services/quiz_firestore.dart';
import 'package:flutter/material.dart';

class QuestionController extends ChangeNotifier {
  final _quizFirestore = QuizFirestore();

  Stream<QuerySnapshot> get list {
    return _quizFirestore.getQuestions();
  }

  void addQuestion(List<String> answers, int correct, String question) {
    _quizFirestore.addQuestion(answers, correct, question);
    notifyListeners();
  }

  void editQuestion(
      String id, List<String> answers, int correct, String question) {
    _quizFirestore.editQuestion(id, answers, correct, question);
  }

  void delteQuestion(String id) {
    _quizFirestore.delteQuestion(id);
  }
}
