import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


Widget AboutSegment(BuildContext context, String title, String description){
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.only(top: 18.0),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Text(title,
          style: GoogleFonts.oswald(textStyle: const TextStyle(
            fontSize: 34.0,
            color: Colors.white,),
          ),
        ),
      ),
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: Colors.blue),
        child: Text(
          description,
          style: GoogleFonts.oswald(textStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,),
          ),
        ),
      ),
    ],
  );
}