import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? align; // string like: 'left' or 'right'
  final String text; // the text to be displayed
  final MaterialColor? color; // the color of the text; one of: Colors.<color>
  final double? fontSize; // text size
  CustomText(this.text, {this.align, this.color, this.fontSize});

  Alignment? checkAlign() {
    if (align == null) {
      return null;
    }
    return align == 'right' ? Alignment.centerRight : Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: checkAlign(),
      child: Text(text, style: TextStyle(color: color, fontSize: fontSize)),
    );
  }
}
