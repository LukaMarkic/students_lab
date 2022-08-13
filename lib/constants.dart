
import 'package:flutter/material.dart';
import 'package:students_lab/models.dart';



//User collections

const String studentCollection = 'studentUsers';
const String professorCollection = 'professorUsers';
const String adminCollection = 'adminUsers';




//Colors

const Color buttonColor = Color(0Xff65CBFF);
const Color backgroundWelcomeColor = Color(0XffF3F3F3);
const Color keyPrimaryColor = Color(0xffEDEDED);
const Color keyPrimaryLightColor = Color(0xffA5C18C);
const Color adminColorTheme = Color(0Xff26374f);
const Color fixedBottomBarColor = Color(0xffE3E3E3);
const Color unselectedBottomBarColor = Color(0xff484848);
const Color primaryThemeColor = Color(0Xffd0eaf5);
const Color primaryDividerColor = Color(0Xffc5c6c7);
const Color listColor = Color(0Xffeaecf1);
const Color stepperColor = Color(0Xff64fedb);
const Color profileColor = Color(0Xfff5f9fa);
const Color lightGreenColor = Color(0Xff90f09b);
const Color courseItemThemeColor = Color(0Xff6f95b3);
const Color directoryListColor = Color(0Xfff7fbfc);


//Enums

enum UserType {admin, student, professor}
enum ActivityType {homework, quiz}


//Segments

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
padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 5)),
);

ButtonStyle buttonStepperStyleBack = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(stepperColor.withOpacity(0.75)),
  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 5)),
);