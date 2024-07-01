import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fayrbase_project/models/question.dart';
import 'package:fayrbase_project/controllers/question_controller.dart';

class QuestionForm extends StatefulWidget {
  Question? question;
  QuestionForm({this.question, super.key});

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final List<TextEditingController> _answerControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final _correctAnswerController = TextEditingController();
  QuestionController questionController = QuestionController();

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _textController.text = widget.question!.question;
      for (int i = 0; i < widget.question!.answers.length; i++) {
        _answerControllers[i].text = widget.question!.answers[i];
      }
      _correctAnswerController.text = widget.question!.correct.toString();
    }
    questionController = context.read<QuestionController>();
  }

  @override
  void dispose() {
    _textController.dispose();
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
      final question = _textController.text;
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

        if (widget.question != null) {
          questionController.editQuestion(
              widget.question!.id, answers, correct, question);
        } else {
          questionController.addQuestion(
            answers,
            correct,
            question,
          );
        }

        _textController.clear();
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
                controller: _textController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  labelText: 'Question',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              ..._answerControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                              labelText: 'Answer ${index + 1}',
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an answer';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    if (_answerControllers.length > 2)
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _removeAnswerField(index),
                      ),
                  ],
                );
              }),
              TextFormField(
                controller: _correctAnswerController,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
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
              const SizedBox(
                height: 15,
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
    );
  }
}
