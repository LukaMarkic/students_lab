
import 'package:flutter/material.dart';


Widget SectorTitle(String title){
  return  Container(
    margin: new EdgeInsets.symmetric(vertical: 5.0),
    child: Text(title,
      style: new TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    ),
  );
}