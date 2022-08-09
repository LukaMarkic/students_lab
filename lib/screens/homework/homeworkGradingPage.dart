
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/database/homeworkService.dart';
import 'package:students_lab/widgets/buttons/roundedButton.dart';
import 'package:students_lab/widgets/inputs/roundedDoubleInput.dart';
import '../../shared/methods/fileMethods.dart';
import '../../shared/methods/stringManipulationMethods.dart';
import '../../shared/methods/ungroupedSharedMethods.dart';
import 'package:intl/intl.dart';


class HomeworkGradingPage extends StatefulWidget {

  SubmittedHomework submittedHomework;
  ProfileStudent student;
  Homework homework;
  double? grade;
  HomeworkGradingPage({Key? key, required this.submittedHomework, required this.student, this.grade, required this.homework})
      : super(key: key);

  @override
  State<HomeworkGradingPage> createState() => _HomeworkGradingPageState();
}

class _HomeworkGradingPageState extends State<HomeworkGradingPage> {
  final DateFormat formatter = DateFormat('dd.MM.yyyy. u kk:mm');

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

      ),body: LayoutBuilder(builder: (context, constraints) {

      return
        Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/homework-background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child:
          BackdropFilter(

            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25,horizontal: 10),
              color: Colors.black.withOpacity(0.8),
              child:
              SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(height: 20,),
                    Card(
                      color: listColor,
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child:
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_circle_outlined, color: Color(0Xff0286bf),
                                  size: 28,),
                                const SizedBox(width: 10),
                                Text(widget.student.name + ' ' + widget.student.surname, style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),),
                              ],
                            ),

                            Row(
                              children: [
                                Icon(
                                  Icons.today, color: Color(0Xff0286bf),
                                  size: 28,),
                                const SizedBox(width: 10),
                                Text('${widget.student.birthDate.day}.${widget.student.birthDate.month}.${widget.student.birthDate.year}.', style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),),
                              ],
                            ),

                          ],
                        ),
                        ),
                    ),
                    const SizedBox(height: 20,),
                    Card(
                      color: listColor,
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Predna zadaća', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                            const Divider(height: 1,color: primaryDividerColor,),
                            const SizedBox(height: 15,),
                            Text('Komentar: ', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                            Container(
                              width: constraints.maxWidth,
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              padding: EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: Colors.black12,),
                                  top: BorderSide(width: 0.5, color: Colors.black12,),
                                ),
                              ),
                              child: Text('${widget.submittedHomework.feedback}', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: (){
                                  if(widget.submittedHomework.documentURL != null){
                                    loadingDialog(context,openFileFromURL(  widget.submittedHomework.documentURL!, widget.submittedHomework.documentURL!.split(RegExp(r'(%2F)..*(%2F)'))[1].split("?alt")[0]));
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: 'Dokument nije moguće pronaći.');
                                  }
                                }, child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Preuzmi predani dokument  ', style: TextStyle(color: Colors.black54), softWrap: false, overflow: TextOverflow.ellipsis,),
                                    Icon(Icons.arrow_circle_down, color: Colors.black,),
                                  ],
                                ))

                              ],
                            ),
                            Text('Ranije predano: ${getTimeDifference(widget.submittedHomework.timeOfSubmit!, widget.homework.deadline)}', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Ocijena: ', style: TextStyle(color: Colors.black54),),
                                widget.submittedHomework.graded && widget.grade != null ? Text('${roundToSecondDecimal(widget.grade! * 100)} %', style: TextStyle(color:Colors.black, fontWeight: FontWeight.w800),) : Text('Nije ocijenjeno', style: TextStyle(color: Colors.redAccent),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    widget.submittedHomework.graded ? RoundedButton(text: 'Promijeni ocijenu', press: (){
                      showGradeAlertWindow();
                    }) : RoundedButton(text: 'Ocijeni zadaću', press: (){
                        showGradeAlertWindow();
                    }),
                  ],
                ),
          ),
        ),
      ),
      );
    }
    ),
    );
  }

  Future showGradeAlertWindow() async {

    double? maxScore;
    double? achievedScore;

    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Ispunite podatke'),
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).pop();

                        },
                        icon: Icon(Icons.cancel_presentation,size: 22,),
                        tooltip: 'Izađi',
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[


                      Column(
                        children: [
                          RoundedDoubleInputField(
                            icon: Icons.emoji_events,
                            hintText: 'Unesite maksimalnu ocijenu',
                              onChanged: (value) {
                                setState(
                                        () => maxScore = double.parse(value)
                                );
                              },),
                          RoundedDoubleInputField(hintText: 'Unesite ocijenu',
                            icon: Icons.emoji_events_outlined,
                            onChanged: (value) {
                              setState(
                                      () => achievedScore = double.parse(value)
                              );
                            },),

                        ],
                      ),
                      ((achievedScore ?? 0) <= (maxScore ?? 100)) ? Container(child: (maxScore != null && achievedScore != null) ? Text('${roundToSecondDecimal(achievedScore!/maxScore! * 100)} %') : Text(''),) : Text('Ocjena ne može premašiti maksimalnu vrijednost.'),
                      ((achievedScore ?? 0) < 0 || (maxScore ?? 100) < 0) ? Text('Unesite pozitivne vrijednosti') : Text(''),
                    ],


                  ),
                  actions: <Widget>[

                    (maxScore != null && achievedScore != null) ? ElevatedButton(
                          child: const Text('Ocijeni'),
                          onPressed: () async {
                            if((achievedScore!/maxScore! >= 0) && (achievedScore! <= maxScore!)){
                              ActivityMark activityMark = ActivityMark(activityID: widget.submittedHomework.homeworkID, segmentID: widget.homework.segmentCode, maxScore: maxScore ?? 100, achievedScore: achievedScore ?? 0);
                              HomeworkService().gradeHomework(widget.submittedHomework.studentID,  widget.homework.courseCode, activityMark);
                              widget.submittedHomework.graded = true;
                              widget.grade = achievedScore!/maxScore!;
                              Navigator.of(context).pop();
                            }else{
                              Fluttertoast.showToast(msg: 'Pogrešan unos!');
                            }
                          },
                        ) : Container(),
                      ],
                );
              }
              ),
    );

  }
}