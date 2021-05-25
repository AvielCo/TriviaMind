import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  final List<String> options;
  final int questionIndex;
  final void Function(int, int) updateAnswers;
  Options(this.options, this.questionIndex, this.updateAnswers);
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  int groupValue = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.options.asMap().entries.map((option) {
          return ListTile(
              title: Text(option.value),
              leading: Radio(
                  value: option.key,
                  groupValue: groupValue,
                  onChanged: (optionSelected) {
                    setState(() {
                      groupValue = optionSelected as int;
                    });
                    widget.updateAnswers(
                        widget.questionIndex, optionSelected as int);
                    print(
                        "Question #${widget.questionIndex}, Selected: $optionSelected");
                  }));
        }).toList()
      ],
    );
  }
}
