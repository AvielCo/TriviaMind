import 'package:flutter/material.dart';

import 'options.dart';

class Questions extends StatefulWidget {
  final quiz = [
    {
      'question': 'Question 1',
      'options': ['a', 'b', 'c'],
      'correct': 1
    },
    {
      'question': 'Question 2',
      'options': ['a', 'b', 'c', 'd', 'e', 'z'],
      'correct': 0
    },
    {
      'question': 'Question 3',
      'options': ['a', 'b', 'c', 'e'],
      'correct': 2
    },
    {
      'question': 'Question 4',
      'options': ['a', 'b', 'c', 'd'],
      'correct': 1
    },
  ];
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  Map<int, int> answers = {
    // {questionId: userAnswer}
  };

  void updateAnswer(int questionIndex, int answerIndex) {
    answers.update(questionIndex, (value) => answerIndex, ifAbsent: () => answerIndex);
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
      ElevatedButton(onPressed: null, child: Text("Check answers"))
    ]);
  }
}
