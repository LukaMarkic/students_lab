
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:students_lab/widgets/containers/roundedContainer.dart';

class SelectGroupingParameter extends StatelessWidget{

  String groupParameter;
  final ValueChanged changeGrouping;
  final List<String> groupParameters;
  final Color backgroundColor;
  final Color textColor;

  SelectGroupingParameter({
    this.groupParameter = '',
    required this.changeGrouping,
    this.groupParameters = const [],
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DropdownButton<String>(
        underline: Container(),
        iconEnabledColor: Colors.black,
        dropdownColor: Colors.white,
        alignment: AlignmentDirectional.center,
        value: groupParameter,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        onChanged: changeGrouping,
        items: groupParameters
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}