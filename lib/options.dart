import 'package:flutter/material.dart';

import './custom_text.dart';

class Options extends StatefulWidget {
  final List options;
  final int questionIndex;
  final void Function(int, int) updateAnswers;
  final bool disableRadioButton;
  final Set<int> wrongAnswers;

  Options(this.options, this.questionIndex, this.updateAnswers,
      this.disableRadioButton, this.wrongAnswers);
  @override
  OptionsState createState() => OptionsState();
}

class OptionsState extends State<Options> with AutomaticKeepAliveClientMixin {
  int _selectedOption = -1;

  void handleChange(selectedOption) {
    //fired when choosing different answer.
    setState(() {
      _selectedOption = selectedOption as int;
    });
    widget.updateAnswers(widget.questionIndex, selectedOption as int);
  }

  Color? handleBackgroundColor(selectedOptionKey) {
    bool disableRadioButtons = widget.disableRadioButton;
    if (!disableRadioButtons || selectedOptionKey != _selectedOption) {
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
    super.build(context);
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
                groupValue: _selectedOption,
                onChanged: !widget.disableRadioButton ? handleChange : null),
            tileColor: handleBackgroundColor(option.key),
          );
        }).toList()
      ],
    );
  }

  bool get wantKeepAlive => true;
}
