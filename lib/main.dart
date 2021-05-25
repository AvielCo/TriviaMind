import 'package:flutter/material.dart';

import './questions.dart';

void main() {
  runApp(TriviaMind());
}

class TriviaMind extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      appBar: AppBar(title: Text("Trivia Mind"),),
      body: Center(child: Questions(),))
      );
  }
}
