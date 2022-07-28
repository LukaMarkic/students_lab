
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_lab/constants.dart';


var appTheme = ThemeData(
  fontFamily: GoogleFonts.nunito().fontFamily,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.lightBlueAccent,
  ),
  scaffoldBackgroundColor: primaryThemeColor,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: Colors.lightBlueAccent,),
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyText1: TextStyle(fontSize: 18),
    bodyText2: TextStyle(fontSize: 16),
    button: TextStyle(
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    ),
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      color: Colors.grey,
    ),
  ),
  buttonTheme: const ButtonThemeData(),
);

var calendarTheme = ThemeData(

  brightness: Brightness.light,
  scaffoldBackgroundColor: primaryThemeColor,

  textTheme: const TextTheme(
    bodyText1: TextStyle(fontSize: 18, color: Colors.black38),
  ),
);
