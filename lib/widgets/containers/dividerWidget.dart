

import 'package:flutter/material.dart';

import '../../constants.dart';

class DividerWrapper extends StatelessWidget{

  Color dividerColor;
  EdgeInsets padding;
  EdgeInsets margin;
  double height;
  double? thickness;

  DividerWrapper({
    this.dividerColor = primaryDividerColor,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.height = 2.5,
    this.thickness
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Divider(height: height, color: dividerColor, thickness: thickness,),
    );
  }


}