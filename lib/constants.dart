
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/models.dart';


const Color buttonColor = Color(0Xff65CBFF);
const Color backgroundWelcomeColor = Color(0XffF3F3F3);
const Color keyPrimaryColor = Color(0xffEDEDED);
const Color keyPrimaryLightColor = Color(0xffA5C18C);
const Color adminColorTheme = Color(0Xff26374f);
const Color primaryThemeColor = Color(0Xffd0eaf5);
const Color primaryDividerColor = Color(0Xffc5c6c7);
const Color listColor = Color(0Xffeaecf1);
const Color stepperColor = Color(0Xff64fedb);



enum UserType {admin, student, professor}

Segment osnovno = Segment(title: '', code: '0_OBAV');
Segment predavanja = Segment(title: 'Predavanja', code: '1_PRE');
Segment AV = Segment(title: 'Auditorne vježbe', code: '2_AV');
Segment LV = Segment(title: 'Laboratorijske vježbe', code: '3_LV');
Segment dodatno = Segment(title: 'Dodatni sadržaj', code: '~OSTALO');

List<Segment> defaultSegments = <Segment>[osnovno, predavanja, AV, LV, dodatno];



//TextStyles

const TextStyle textStyleColorBlack = TextStyle(color: Colors.black);


//ButtonStyles

ButtonStyle buttonStepperStyleContinue = ButtonStyle(
backgroundColor: MaterialStateProperty.all<Color>(stepperColor),
padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 5)),
);

ButtonStyle buttonStepperStyleBack = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(stepperColor.withOpacity(0.75)),
  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 5)),
);