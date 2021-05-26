import 'package:flutter/material.dart';

import './questions.dart';

void main() {
  runApp(TriviaMind());
}

class TriviaMind extends StatelessWidget {
  final GlobalKey<QuestionsState> _questionsState = GlobalKey<QuestionsState>();

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
            body: Questions(key: _questionsState)));
  }
}
