import 'package:flutter/material.dart';

import './custom_text.dart';
/// this class represend options array of a single question.
class Options extends StatefulWidget {
  final List options; // list of options of a question.
  final int questionIndex; // the question index inside _quiz array.
  final void Function(int, int) updateAnswers; // function inside Quiz widget that updates the answer of the user.
  final bool disableRadioButton; // boolean indicator, true for disabling radio button (usually when showing the answers)
  final Set<int> wrongAnswers; // set of wrong answers with the questions indexes.

  Options(this.options, this.questionIndex, this.updateAnswers,
      this.disableRadioButton, this.wrongAnswers);

  @override
  OptionsState createState() => OptionsState();
}

class OptionsState extends State<Options> with AutomaticKeepAliveClientMixin {
  int _selectedOption = -1; // user selected option, initially equal to -1 for no selection.

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
      // if the answers are not revealed
      // OR
      // the current option index is not the selected option which means, do not highlight it.
      return null;
    }
    Set<int> wrongAnswers = widget.wrongAnswers;
    int questionIndex = widget.questionIndex;
    if (disableRadioButtons && wrongAnswers.contains(questionIndex)) {
      // if radio buttons are off and user is incorrect
      return Color(0xFFF04824);
    }
    // if the user has chosen the correct answer.
    return Colors.lightGreen;
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
            // will highligh in green if the user has chosen the correct answer, else red.
            tileColor: handleBackgroundColor(option.key), 
          );
        }).toList()
      ],
    );
  }

  bool get wantKeepAlive => true;
}
