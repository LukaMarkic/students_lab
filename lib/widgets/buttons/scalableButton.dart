
import 'package:flutter/material.dart';
import '../../constants.dart';


class ScalableButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
  final double width;
  final double fontSize;
  const ScalableButton({Key? key,

    required this.text,
    required this.press,
    this.color = buttonColor,
    this.textColor = Colors.white,
    this.width = 100,
    this.fontSize = 16,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: width,
      child: ElevatedButton(onPressed: press,
        style: ElevatedButton.styleFrom(
            primary: color,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            textStyle: TextStyle(
                color: textColor, fontSize: fontSize, fontWeight: FontWeight.w500)),
        child: Text(text),
      ),);
  }
}