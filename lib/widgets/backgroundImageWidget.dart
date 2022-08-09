
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BackgroundImageWidget extends StatelessWidget{

  Widget child;
  final String imagePath;
  final Color color;
  final double colorOpacity;
  final EdgeInsets padding;

  BackgroundImageWidget({
    required this.child,
    required this.imagePath,
    this.color = Colors.black,
    this.colorOpacity = 0.8,
    this.padding = const EdgeInsets.only(left: 8, right: 8),
  });


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
            padding: padding,
            color: color.withOpacity(colorOpacity),
            child: child,
            )
          ),
        );
      }
    );
  }
}