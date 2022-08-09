
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget{

  Color backgroundColor;
  EdgeInsets margin;
  EdgeInsets padding;
  double radius;
  Widget? child;
  double? width;
  Color borderColor;
  double borderWidth;
  Alignment? alignment;

  RoundedContainer({
    this.backgroundColor = Colors.white,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric( horizontal: 10, vertical: 15),
    this.radius = 10,
    this.child,
    this.width,
    this.borderColor = Colors.black,
    this.borderWidth = 0,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width ?? MediaQuery.of(context).size.width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(color: borderColor, spreadRadius: borderWidth),
        ],
      ),
      child: child,
    );


  }


}