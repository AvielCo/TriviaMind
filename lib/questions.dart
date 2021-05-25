import 'package:flutter/material.dart';

import 'options.dart';

class Questions extends StatefulWidget {
  final quiz = [
    {
      'question': 'Question 1',
      'options': ['option #1', 'option #2', 'option #3'],
      'correct': 1
    },
    {
      'question': 'Question 2',
      'options': ['option #1', 'option #2', 'option #3', 'option #4'],
      'correct': 0
    },
    {
      'question': 'Question 3',
      'options': ['option #1', 'option #2', 'option #3'],
      'correct': 2
    },
    {
      'question': 'Question 4',
      'options': [
        'option #1',
        'option #2',
        'option #3',
        'option #4',
        'option #5'
      ],
      'correct': 1
    },
  ];
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  // will hold the answers of the user.
  // an entry will look like: questionIndex: answerIndex
  // using this answers Map later when click on check answers.
  Map<int, int> answers = Map();

  // will hold the question index that the user chose the wrong answers.
  // if question index is not appear in this set, the user's answer is correct.
  Set<int> wrongAnswers = Set();

  void updateAnswer(int questionIndex, int answerIndex) {
    answers.update(questionIndex, (value) => answerIndex,
        ifAbsent: () => answerIndex);
  }

  void checkAnswers() {
    int amountOfQuestions = widget.quiz.length;
    int amountOfUserAnswers = answers.length;
    if (amountOfQuestions != amountOfUserAnswers) {
      return;
    }

    widget.quiz.asMap().entries.forEach((question) {
      int correctAnswer = question.value['correct'] as int;
      int userAnswer = answers[question.key] as int;

      if (correctAnswer != userAnswer) {
        wrongAnswers.add(question.key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ...widget.quiz.asMap().entries.map((questionDetails) {
        return Column(
          children: [
            Text(questionDetails.value['question'] as String),
            Options(questionDetails.value['options'] as List<String>,
                questionDetails.key, updateAnswer)
          ],
        );
      }).toList(),
      ElevatedButton(onPressed: checkAnswers, child: Text("Check answers"))
    ]);
  }
}
