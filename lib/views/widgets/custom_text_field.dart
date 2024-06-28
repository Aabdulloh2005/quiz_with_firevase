import 'package:fayrbase_project/views/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fayrbase_project/models/question.dart';
import 'package:fayrbase_project/controllers/question_controller.dart';

class QuestionForm extends StatefulWidget {
  const QuestionForm({Key? key}) : super(key: key);

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final _correctAnswerController = TextEditingController();
  late QuestionController questionController;

  @override
  void initState() {
    super.initState();
    questionController = context.read<QuestionController>();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _correctAnswerController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAnswerField() {
    if (_answerControllers.length < 4) {
      setState(() {
        _answerControllers.add(TextEditingController());
      });
    }
  }

  void _removeAnswerField(int index) {
    if (_answerControllers.length > 2) {
      setState(() {
        _answerControllers.removeAt(index);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final question = _questionController.text;
      final answers =
          _answerControllers.map((controller) => controller.text).toList();
      final correct = int.tryParse(_correctAnswerController.text);

      if (correct != null && correct >= 0 && correct < answers.length) {
        final newQuestion = Question(
          id: '',
          question: question,
          answers: answers,
          correct: correct,
        );

        questionController.addQuestion(
          answers,
          correct,
          question,
        );

        _questionController.clear();
        _correctAnswerController.clear();
        for (var controller in _answerControllers) {
          controller.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid correct answer index')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              ..._answerControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration:
                            InputDecoration(labelText: 'Answer ${index + 1}'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an answer';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (_answerControllers.length > 2)
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _removeAnswerField(index),
                      ),
                  ],
                );
              }).toList(),
              TextFormField(
                controller: _correctAnswerController,
                decoration: const InputDecoration(
                    labelText: 'Correct Answer Index (0-based)'),
                validator: (value) {
                  final index = int.tryParse(value ?? '');
                  if (index == null ||
                      index < 0 ||
                      index >= _answerControllers.length) {
                    return 'Please enter a valid index';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addAnswerField,
                    child: const Text('Add Answer'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
