import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'options.dart';
import 'custom_text.dart';
import './helpers.dart';

class Quiz extends StatefulWidget {
  Quiz({required Key key}) : super(key: key);

  @override
  QuizState createState() => QuizState();
}

class QuizState extends State<Quiz> {
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

  Future<List<Map<String, Object>>> fetchQuizQustions() async {
    //get response from API.
    //response will have body that contains the questions.
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&type=multiple&encode=url3986'));
    if (response.statusCode == 200) {
      //init random to generate a random number between 0 - quiz.length
      //to push the correct answer to the options list.
      Random random = new Random();

      //init quiz that will hold the temporary list of questions.
      var quiz = <Map<String, Object>>[];

      //decodedResults will decode the body of the response and get the
      //quiz as list of Objects.
      var decodedResults = jsonDecode(response.body)['results'];
      print(decodedResults);
      decodedResults.forEach((question) {
        /// for each question in quiz,
        /// [randomCorrectAnswerIndex] - random index to insert [correctAnswer]
        /// [questionText] - holds the question text
        /// [correctAnswer] - holds the string correct answer
        /// [options] - at first, list of incorrect answers, after, insert [correctAnswer] in [randomCorrectAnswerIndex] index.
        /// after all these steps, insert everything into [newQuestion]
        /// and appending [newQuestion] into [_quiz]
        String questionDifficulty = decodeUTF8String(question['difficulty']);
        String questionCategory = decodeUTF8String(question['category']);
        String questionText = decodeUTF8String(question['question']);
        String correctAnswer = decodeUTF8String(question['correct_answer']);
        List options = [];
        question['incorrect_answers']
            .forEach((e) => options.add(decodeUTF8String(e)));
        int randomCorrectAnswerIndex = random.nextInt(options.length);
        options.insert(randomCorrectAnswerIndex, correctAnswer);
        var newQuestion = {
          'category': questionCategory,
          'difficulty':questionDifficulty,
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
      _quiz = <Map<String, Object>>[];
      _showResults = false;
      _wrongAnswers = Set();
      _answers = Map();
      fetchQuizQustions().then((value) => setState(() {
            _quiz = value;
          }));
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
      padding: const EdgeInsets.all(15.0),
      child: _quiz.isNotEmpty // render the list of questions if the quiz is not empty.
          ? ListView.builder(
              itemCount: _quiz.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  CustomText(
                    "[${_quiz[index]['category'] as String}, ${_quiz[index]['difficulty'] as String}]",
                    align: 'left',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
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
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: const Divider(
                          color: Colors.black,
                          height: 2,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        )),
                  /// for the last question, render a button.
                  /// on click, the button will check which answers are correct,
                  /// and which are doesn't.
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
            )
          : Center(child: CircularProgressIndicator()), // if quiz is empty, render a spinning progress indicator.
    );
  }
}
