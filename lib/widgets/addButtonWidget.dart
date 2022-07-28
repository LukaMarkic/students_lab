
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart' as constant;


class AddButton extends StatelessWidget{
  String message;
  VoidCallback onPress;
  Color buttonColor;
  Color contentColor;
  AddButton({
    this.message = '',
    required this.onPress,
    this.buttonColor = constant.buttonColor,
    this.contentColor = Colors.white,
  });

@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: onPress,
    child:
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.add_outlined, color: contentColor,),
        ),
        Text(message, style: TextStyle(color: contentColor),),
      ],
    ),
    style: ElevatedButton.styleFrom(
        primary: buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        textStyle: TextStyle(
            color: contentColor, fontSize: 14, fontWeight: FontWeight.w500)),
  );
}

}