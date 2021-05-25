import 'package:flutter/material.dart';

import './custom_text.dart';

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
              title: CustomText(
                option.value,
                fontSize: 18,
              ),
              leading: Radio(
                  value: option.key,
                  groupValue: groupValue,
                  onChanged: (optionSelected) { 
                    //fired when choosing different answer.
                    setState(() {
                      groupValue = optionSelected as int;
                    });
                    widget.updateAnswers(
                        widget.questionIndex, optionSelected as int);
                  }));
        }).toList()
      ],
    );
  }
}
