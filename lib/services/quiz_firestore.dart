import 'package:cloud_firestore/cloud_firestore.dart';

class QuizFirestore {
  final _quizCollection = FirebaseFirestore.instance.collection("quizes");

  Stream<QuerySnapshot> getQuestions() async* {
    yield* _quizCollection.snapshots();
  }

  void addQuestion(List<String> answers, int correct, String question) {
    _quizCollection
        .add({"answers": answers, "question": question, "correct": correct});
  }

  void editQuestion(
      String id, List<String> answers, int correct, String question) {
    _quizCollection.doc(id).update({
      "answers": answers,
      "question": question,
      "correct": correct,
    });
  }

  void delteQuestion(String id) {
    _quizCollection.doc(id).delete();
  }
}
