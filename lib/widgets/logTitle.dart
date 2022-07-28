
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


Widget LogTitle(String title){
  return Container(
    margin: new EdgeInsets.symmetric(vertical: 25.0),
    padding: EdgeInsets.all(12.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        Text( title,
          style: GoogleFonts.oswald(textStyle: const TextStyle( fontSize: 42.0, color: Colors.black,),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}