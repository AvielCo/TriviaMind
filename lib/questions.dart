import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'options.dart';
import 'custom_text.dart';

class Questions extends StatefulWidget {
  Questions({required Key key}) : super(key: key);

  @override
  QuestionsState createState() => QuestionsState();
}

class QuestionsState extends State<Questions> {
  var _quiz = <Map<String, Object>>[];

  // will hold the answers of the user.
  // an entry will look like: questionIndex: answerIndex
  // using this answers Map later when click on check answers.
  Map<int, int> _answers = Map();

  // will hold the question index that the user chose the wrong answers.
  // if question index is not appear in this set, the user's answer is correct.
  Set<int> _wrongAnswers = Set();

  // represent the 'check answers' button.
  // if true, the button has been clicked, therefore, show the results to the user and disable any button.
  bool _showResults = false;

  bool _resetQuiz = false;

  Future<List<Map<String, Object>>> fetchQuizQustions() async {
    final response = await http
        .get(Uri.parse('https://opentdb.com/api.php?amount=10&type=multiple'));
    if (response.statusCode == 200) {
      Random random = new Random();
      var quiz = <Map<String, Object>>[];
      var decodedResults = jsonDecode(response.body)['results'];
      decodedResults.forEach((question) {
        String questionText = question['question'];
        String correctAnswer = question['correct_answer'];
        List options = question['incorrect_answers'];
        int randomCorrectAnswerIndex = random.nextInt(options.length);
        options.insert(randomCorrectAnswerIndex, correctAnswer);
        var newQuestion = {
          "question": questionText,
          "options": options,
          "correct": randomCorrectAnswerIndex
        };
        quiz.add(newQuestion);
      });
      return Future.value(quiz);
    } else {
      throw Exception('failed to load data.');
    }
  }

  void updateAnswer(int questionIndex, int answerIndex) {
    _answers.update(questionIndex, (value) => answerIndex,
        ifAbsent: () => answerIndex);
  }

  void checkAnswers() {
    int amountOfQuestions = _quiz.length;
    int amountOfUserAnswers = _answers.length;
    if (amountOfQuestions != amountOfUserAnswers) {
      return;
    }
    Set<int> wrongAnswers = Set();
    _quiz.asMap().entries.forEach((question) {
      int correctAnswer = question.value['correct'] as int;
      int userAnswer = _answers[question.key] as int;

      if (correctAnswer != userAnswer) {
        wrongAnswers.add(question.key);
      }
    });
    setState(() {
      _showResults = true;
      _wrongAnswers = wrongAnswers;
    });
  }

  void resetQuiz() {
    setState(() {
      _resetQuiz = true;
      _showResults = false;
      _wrongAnswers = Set();
      _answers = Map();
      fetchQuizQustions().then((value) => _quiz = value);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuizQustions().then((value) => {
          this.setState(() {
            _quiz = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _quiz.length,
        itemBuilder: (context, index) {
          return Column(children: [
            CustomText(
              _quiz[index]['question'] as String,
              align: 'left',
              fontSize: 20,
            ),
            Options(
              _quiz[index]['options'] as List,
              index,
              updateAnswer,
              _showResults,
              _wrongAnswers,
            ),
            // render divider for every question but the last
            if (index != _quiz.length - 1)
              const Divider(
                color: Colors.black,
                height: 2,
                thickness: 1,
                indent: 15,
                endIndent: 15,
              ),
            if (index == _quiz.length - 1)
              ElevatedButton(
                  onPressed: !_showResults ? checkAnswers : null,
                  child: CustomText(
                    !_showResults
                        ? "Check your answers"
                        : "Showing your results",
                    fontSize: 18,
                  ))
          ]);
          
        },
      ),
    );
  }
}
