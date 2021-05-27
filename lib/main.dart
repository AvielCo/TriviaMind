import 'package:flutter/material.dart';

import 'quiz.dart';

void main() {
  runApp(TriviaMind());
}

class TriviaMind extends StatelessWidget {
  final GlobalKey<QuizState> _questionsState = GlobalKey<QuizState>();

  void handleResetEvent() {
    _questionsState.currentState?.resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Trivia Mind"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.change_circle),
                  tooltip: "Restart quiz",
                  onPressed: handleResetEvent,
                )
              ],
            ),
            body: Quiz(key: _questionsState)));
  }
}
