
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';


class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  const TextFieldContainer({
    Key? key,
    required this.child,
    this.color = keyPrimaryColor,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.borderRadius = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}