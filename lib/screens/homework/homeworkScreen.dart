

import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/screens/homework/submittedHomeworks.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/services/database/homeworkService.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/widgets/alertWindow.dart';
import 'package:students_lab/widgets/roundedButton.dart';
import 'package:students_lab/widgets/roundedInput.dart';
import '../../constants.dart';
import '../../error.dart';
import '../../loading.dart';
import '../../models.dart';
import 'package:intl/intl.dart';
import '../../services/database/storageServices.dart';
import '../../shared/sharedMethods.dart';
import '../../widgets/uploadStatus.dart';


class FutureHomeworkBuild extends StatelessWidget{

  String homeworkID;
  bool isProvider;
  ActivityMark? activityMark;
  FutureHomeworkBuild({required this.homeworkID, required this.isProvider, this.activityMark});



  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: HomeworkService().getHomeworkData(homeworkID),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          }
          else {
            if(snapshot.data == null){
              return CircularProgressIndicator();
            }
            else{
              Homework homework = snapshot.data;
              return isProvider ? HomeworkPreviewPage(homework: homework) :
                FutureBuilder(
                future: HomeworkService().isSubmitted(AuthService().user!.uid, homeworkID),
                builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
                } else if (snapshot.hasError) {
                return const Center(
                child: ErrorMessage(),
                );
                }
                else {
                  var isSubmitted = snapshot.data;
                  if(isSubmitted){
                   return FutureSubmittedHomework(homework: homework);
                  }
                  return HomeworkClientPage(homework: homework, isSubmitted: isSubmitted,);
                }
                }
    );
                 }
            }
          }
    );
  }

}



class HomeworkPreviewPage extends StatelessWidget {
  Homework homework;
  final DateFormat formatter = DateFormat('dd.MM.yyyy.');

  HomeworkPreviewPage({Key? key, required this.homework,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

      ),
      body: Container(
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
            color: Colors.black.withOpacity(0.7),
            child:

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(homework.title, style: TextStyle(color: Colors.white70, fontSize: 38, fontWeight: FontWeight.bold), ),
                const SizedBox(height: 10,),
                const Divider(height: 1,color: primaryDividerColor,),
                const SizedBox(height: 20,),
                Expanded( child: Column( children: [Text(homework.description, style: TextStyle(color: Colors.white, fontSize: 18),),
                  homework.documentURL != null ? ListTile(

                  textColor: Colors.white,
                  horizontalTitleGap: 4,
                  leading: const Icon(Icons.assignment, color: Colors.white70, size: 22,),
                  title: Text('Domaća zadaća ', style: TextStyle(fontSize: 16, height: 2),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,),
                  onTap: (){
                    loadingDialog(context, openFileFromURL(homework!.documentURL!, homework!.documentURL!.split(RegExp(r'(%2F)..*(%2F)'))[1].split("?alt")[0]))
                    ;
                  },
                ) : Container(),]),),
                Text('Krajnji rok predaje: ${formatter.format(homework.deadline!.toLocal()).toString()}', style: TextStyle(color: Colors.grey[100]),),
                const SizedBox(height: 5,),
                const SizedBox(height: 10,),
                RoundedButton(text: 'Pregled predanih zadaća', press: () async {
                  var submittedHomework = await HomeworkService().getSubmittedHomeworks(homework.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubmittedHomeworkPage(submittedHomeworks: submittedHomework, homework: homework,)),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class FutureSubmittedHomework extends StatelessWidget {

  Homework homework;

  FutureSubmittedHomework({required this.homework,});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GradeService().getActivityMark(
            AuthService().user!.uid, homework.courseCode, homework.segmentCode,
            homework.id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          }
          else {
            double? grade = snapshot.data;
            return FutureBuilder(
                future: HomeworkService().getUserSubmittedHomeworks(homework.id, AuthService().user!.uid),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingScreen();
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: ErrorMessage(),
                    );
                  }
                  else {
                    var submittedHomework = snapshot.data;
                    return   HomeworkClientPage( homework: homework, isSubmitted: true, grade: grade, submittedHomework: submittedHomework, );
                  }
                }
            );

          }
        }
    );
  }
}

class HomeworkClientPage extends StatefulWidget {
  Homework homework;
  bool isSubmitted;
  double? grade;
  SubmittedHomework? submittedHomework;
  HomeworkClientPage({Key? key, required this.homework, required this.isSubmitted, this.grade, this.submittedHomework})
      : super(key: key);

  @override
  State<HomeworkClientPage> createState() => _HomeworkClientPageState();
}

class _HomeworkClientPageState extends State<HomeworkClientPage> {
  final DateFormat formatter = DateFormat('dd.MM.yyyy. u kk:mm');

  String? _feedback;
  UploadTask? task;
  String? documentURL;
  String fileName = '';
  String studentID = AuthService().user!.uid;



  
  
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
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            padding: EdgeInsets.symmetric(vertical: 25,horizontal: 10),
            color: Colors.black.withOpacity(0.8),
          child:
    SingleChildScrollView(
      child: Column(
              children: [
                Text(widget.homework.title, style: TextStyle(color: Colors.white70, fontSize: 38, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                const SizedBox(height: 10,),
                const Divider(height: 1,color: primaryDividerColor,),
                const SizedBox(height: 20,),
                Text(widget.homework.description, style: TextStyle(color: Colors.white, fontSize: 18),),
                const SizedBox(height: 10,),
                const Divider(height: 0.5,color: primaryDividerColor,),
                widget.homework.documentURL != null ? ListTile(
                  textColor: Colors.white,
                  horizontalTitleGap: 4,
                  leading: const Icon(Icons.assignment, color: Colors.white70, size: 22,),
                  title: const Text('Domaća zadaća', style: TextStyle(fontSize: 16, height: 2),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,),
                  onTap: (){
                    loadingDialog(context, openFileFromURL(widget.homework!.documentURL!, widget.homework!.documentURL!.split(RegExp(r'(%2F)..*(%2F)'))[1].split("?alt")[0]));
                  },
                ) : Container(),
                
                
                const SizedBox(height: 20,),
                widget.isSubmitted ? Container(child:
                Column(children: [
                  Text('Zadaća predana', style: TextStyle(color: Colors.lightGreen, fontSize: 22),),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10,),
                    color: Colors.white.withOpacity(0.1),
                  child: widget.grade != null ? Text('${getResultTitle(widget.grade!)} Riješeno s uspijehom od: ${roundToSecondDecimal(widget.grade! * 100)} %', style: TextStyle(color: getResultColor(widget.grade!), fontSize: 14),) :
                  Text('Nije ocijenjeno', style: TextStyle(color: Colors.white, fontSize: 14),),),
                  widget.submittedHomework != null ?
                  ListTile(
                    dense: true,
                    textColor: Colors.black87,
                    horizontalTitleGap: 4,
                    leading: Image.asset('assets/images/${getExtensionFromFirebaseURL(widget.submittedHomework!.documentURL!)}-logo.png', height: 28),
                    title: Text('Vaša predana zadaća', style: const TextStyle(color: Colors.white, fontSize: 16, height: 2),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,),
                    onTap: (){
                      if(widget.submittedHomework?.documentURL != null) {
                        loadingDialog(context, openFileFromURL(widget.submittedHomework!.documentURL!, getNameFromURL(widget.submittedHomework!.documentURL!)));
                      }
                      },
                  ) : Container(),
                ],),
                ) : DateTime.now().isAfter(widget.homework.deadline) ? Container(child: Text('Žao nam je.\nRok za predaju zadaće (${formatter.format(widget.homework.deadline!.toLocal()).toString() + ' sati'}) je istekao.'),) :
                
                Column(
                  children: [
                    RoundedInputField(hintText: 'Unesite povratnu informaciju',
                      icon: Icons.feedback,
                      onChanged: (value) {
                        setState(
                                () => _feedback = value
                        );
                      },),

                    RoundedButton(text: 'Dodaj dokument', press: ()async{
                      final result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                      );
                      if(result == null){
                        ShowScaffoldMessage(context, 'Dokument nije odabran');
                        return;
                      }else{

                        var filePath = result.files.single.path!;
                        fileName = result.files.single.name;
                        String directoryPath = 'files/homeworks/${widget.homework.id}/submittedHomework/${studentID}';
                        var file = File(filePath);
                        task = await FirebaseStorageService().uploadFile(file!, "${directoryPath}/homework_${fileName}");
                        setState(() {});
                        var fileUrl = await (await task)?.ref.getDownloadURL();
                        documentURL = fileUrl.toString();
                        setState(() {});
                      }
                    },),
                    task != null ? buildUploadStatus(task!, fileName)  : Container(),
                    const SizedBox(height: 30,),
                    Text('Krajnji rok predaje:', style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold, fontSize: 20),),
                    Text('${formatter.format(widget.homework.deadline!.toLocal()).toString() + ' sati'}', style: TextStyle(color: Colors.red[400],
                        fontWeight: FontWeight.bold, fontSize: 20),),
                    const SizedBox(height: 5,),
                    const SizedBox(height: 10,),
                    RoundedButton(text: 'Predaj zadaću', press: () async {
                      var studentFullName = await ProfileService().getUserFullName('studentUsers', AuthService().user!.uid);
                      showAlertWindow(context, 'Želite li predati zadaću', (){
                        SubmittedHomework submittedHomework = SubmittedHomework(studentID: studentID, homeworkID: widget.homework.id, feedback: _feedback, documentURL: documentURL, timeOfSubmit: DateTime.now(), studentFullName: studentFullName ?? 'Unnamed student');
                        HomeworkService().submitHomework(submittedHomework);
                        Fluttertoast.showToast(
                          msg: 'Zadaća predana.', fontSize: 14, backgroundColor: Colors.lightGreenAccent,);
                      });
                    }),
                  ],
                ),

              ],
            ),),),),);
          }),
    );
  }
}