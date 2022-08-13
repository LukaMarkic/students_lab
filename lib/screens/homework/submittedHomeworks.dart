
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/screens/homework/homeworkGradingPage.dart';
import 'package:students_lab/services/database/profileService.dart';
import '../../services/database/gradeService.dart';
import '../../shared/methods/fileMethods.dart';



class SubmittedHomeworkPage extends StatelessWidget {

  List<SubmittedHomework>? submittedHomeworks;
  Homework homework;
  SubmittedHomeworkPage({Key? key, required this.submittedHomeworks, required this.homework})
      : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

      ),body: LayoutBuilder(builder: (context, constraints) {

      return
        Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/homework-background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child:
          BackdropFilter(

            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 10),
              color: Colors.black.withOpacity(0.8),
              child:
              SingleChildScrollView(
                child: Column(
                  children: [
                const Text('Predne zadaće', style: TextStyle(color: Colors.white70, fontSize: 38, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    const Divider(height: 1,color: primaryDividerColor,),
                    const SizedBox(height: 20,),

                ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: submittedHomeworks?.length ?? 0,
                  itemBuilder: (_, index) {
                    return  Card(
                      color: listColor,
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ListTile(
                        dense: false,
                        textColor: Colors.black87,
                        horizontalTitleGap: 4,
                        title: Text(submittedHomeworks![index].studentFullName, style: const TextStyle(fontSize: 20, height: 2, color: Colors.black),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,),
                        subtitle: submittedHomeworks![index].graded ? const Text('Ocijenjeno', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13),) : const Text('Nije ocijenjeno', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 13),),
                        onTap: () async {
                          var student = await ProfileService().getProfileDataStudent(submittedHomeworks![index].studentID);
                          var grade = await GradeService().getActivityMark(submittedHomeworks![index].studentID, homework.courseCode, homework.segmentCode, submittedHomeworks![index].homeworkID);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeworkGradingPage(submittedHomework: submittedHomeworks![index], student: student, grade: grade, homework: homework,)),
                          );
                        },
                        trailing: IconButton(icon: const Icon(Icons.arrow_circle_down, color: Colors.black,), onPressed: () {
                          if(submittedHomeworks![index].documentURL != null){
                            loadingDialog(context, openFileFromURL(  submittedHomeworks![index].documentURL!, getNameFromURL(submittedHomeworks![index].documentURL!)));
                          }
                          else{
                            Fluttertoast.showToast(msg: 'Dokument nije moguće pronaći.');
                          }
                        },),
                      ),
                    ),);
                  }
              ),
                      ],
                    ),

                ),),),);
    }),
    );
  }


}