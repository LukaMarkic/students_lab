
import 'package:flutter/material.dart';


class CancleSortIcon extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [
          Icon(Icons.sort),
          Positioned(
            bottom: 0,
            right: 4,
            child: Icon(Icons.cancel_outlined, size: 11,),
          ),
        ],
      );
  }


}