
import 'package:flutter/material.dart';

String getResultTitle(double value){
  String result = "";
  if(value < 0.4){
    result = "Možete bolje!";
  }else if(value < 0.6){
    result = "Uspješno riješeno!";
  }else if(value < 0.75){
    result = "Jako dobro!";
  }
  else if(value < 0.9){
    result = "Vrlo dobro!";
  }
  else{
    result = "Čestitamo!";
  }
  return result;
}

Color getResultColor(double value){
  Color color = Colors.white;
  if(value < 0.4){
    color = Colors.red;
  } else if(value < 0.6){
    color = Colors.lightBlueAccent;
  } else if(value < 0.75){
    color = Colors.blueAccent;
  }
  else if(value < 0.9){
    color = Colors.lightGreenAccent;
  }
  else{
    color = Colors.green;
  }
  return color;
}
