import 'package:flutter/material.dart';

import 'options.dart';
import 'custom_text.dart';

class Questions extends StatefulWidget {
  final quiz = [
    {
      'question':
          'Hello im question number one and im very very very very long question text lol dont be mad. ok?',
      'options': [
        'LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOONG',
        'LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOONG #2',
        'short'
      ],
      'correct': 1
    },
    {
      'question':
          'Hello im question number two and im STILL very very very very long question text',
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
  Set<int> _wrongAnswers = Set();

  // represent the 'check answers' button.
  // if true, the button has been clicked, therefore, show the results to the user and disable any button.
  bool _showResults = false;

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
    Set<int> wrongAnswers = Set();
    widget.quiz.asMap().entries.forEach((question) {
      int correctAnswer = question.value['correct'] as int;
      int userAnswer = answers[question.key] as int;

      if (correctAnswer != userAnswer) {
        wrongAnswers.add(question.key);
      }
    });
    setState(() {
      _showResults = true;
      _wrongAnswers = wrongAnswers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          // iterate over quiz and render a list of questions with theire options
          ...widget.quiz.asMap().entries.map((questionDetails) {
            return Column(
              children: [
                CustomText(
                  questionDetails.value['question'] as String,
                  align: 'left',
                  fontSize: 20,
                ),
                Options(questionDetails.value['options'] as List<String>,
                    questionDetails.key, updateAnswer, _showResults, _wrongAnswers),
                // render divider for every question but the last
                if (questionDetails.key != widget.quiz.length - 1)
                  const Divider(
                    color: Colors.black,
                    height: 2,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  )
              ],
            );
          }).toList(),
          ElevatedButton(
              onPressed: !_showResults ? checkAnswers : null,
              child: CustomText(
                !_showResults ? "Check your answers" : "Showing your results",
                fontSize: 18,
              ))
        ],
      ),
    );
  }
}
