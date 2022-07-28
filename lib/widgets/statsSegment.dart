
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;


Widget StatSegment( String title, String stats){
  return Container(
    height: 50,
    padding: EdgeInsets.symmetric(vertical:5),
    margin: EdgeInsets.only( bottom: 30),
    decoration: const BoxDecoration(
      color: Color(0xffF2F2F2),

      boxShadow: [
        BoxShadow(color: Colors.blue, spreadRadius: 1, offset: Offset(3, 3)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text( title,
          style: GoogleFonts.oswald(textStyle: new TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,),),
        ),
        Text(stats,
          style: GoogleFonts.oswald(textStyle: new TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,),),
        ),
      ],
    ),
  );
}