import 'package:flutter/material.dart';
import '../constants.dart';

class DoesntHaveAccountWidget extends StatelessWidget {
  final VoidCallback press;
  const DoesntHaveAccountWidget({
    Key? key,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Nemate račun? ",
          style: TextStyle(color: keyPrimaryColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
           "Stvorite račun",
            style: TextStyle(
              color: keyPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}