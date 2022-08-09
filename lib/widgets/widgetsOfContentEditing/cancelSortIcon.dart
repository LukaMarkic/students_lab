
import 'package:flutter/material.dart';


class CancelSortIcon extends StatelessWidget{
  const CancelSortIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: const [
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