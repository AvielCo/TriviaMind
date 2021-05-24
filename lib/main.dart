import 'package:flutter/material.dart';

void main() {
  runApp(TrivialMind());
}

class TrivialMind extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Trivia Mind"),
      ),
    ));
  }
}
