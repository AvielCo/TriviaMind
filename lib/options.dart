import 'package:flutter/material.dart';

import './custom_text.dart';

class Options extends StatefulWidget {
  final List<String> options;
  final int questionIndex;
  final void Function(int, int) updateAnswers;
  final bool disableRadioButton;
  final Set<int> wrongAnswers;
  Options(this.options, this.questionIndex, this.updateAnswers,
      this.disableRadioButton, this.wrongAnswers);
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  int groupValue = -1;

  void handleChange(selectedOption) {
    //fired when choosing different answer.
    setState(() {
      groupValue = selectedOption as int;
    });
    widget.updateAnswers(widget.questionIndex, selectedOption as int);
  }

  Color? handleBackgroundColor(optionKey) {
    bool disableRadioButtons = widget.disableRadioButton;
    if (!disableRadioButtons || optionKey != groupValue) {
      return null;
    }
    Set<int> wrongAnswers = widget.wrongAnswers;
    int questionIndex = widget.questionIndex;
    if (disableRadioButtons && wrongAnswers.contains(questionIndex)) {
      return Color(0xFFF04824);
    } else {
      return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.options.asMap().entries.map((option) {
          return ListTile(
              title: CustomText(
                option.value,
                fontSize: 18,
              ),
              leading: Radio(
                  value: option.key,
                  groupValue: groupValue,
                  onChanged: !widget.disableRadioButton ? handleChange : null),
              tileColor: handleBackgroundColor(option.key),);
        }).toList()
      ],
    );
  }
}
