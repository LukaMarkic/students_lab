
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';


class SquaredButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
  final double widthRatio;
  final double paddingHorizontal;
  final double paddingVertical;
  final EdgeInsets margin;
  const SquaredButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = buttonColor,
    this.textColor = Colors.white,
    this.widthRatio = 0.9,
    this.paddingHorizontal = 20,
    this.paddingVertical = 20,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widthRatio,
      margin: margin,
      child: ElevatedButton(onPressed: press,
        child: Text(text, style: TextStyle(color: textColor),),
        style: ElevatedButton.styleFrom(
            primary: color,
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
            textStyle: TextStyle(
                color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }


}


