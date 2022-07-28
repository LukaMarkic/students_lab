
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:students_lab/services/database/courseService.dart';
import '../constants.dart';
import '../models.dart';
import '../screens/authentification/adminLoginForm.dart';
import '../screens/frontpage.dart';
import '../screens/home.dart';
import '../screens/quiz/FormSteps/questionForm.dart';
import '../services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;


Future<void> CheckingAccountAuth(BuildContext context, String? uid, String message) async{

  if (uid != null) {
    UserType type = await getUserType(uid);
    if(type == UserType.admin) {
      await AuthService().signOut();
      Fluttertoast.showToast(
        msg: 'Pogrešni prozor!\nPokušajte ovdje.', fontSize: 14, backgroundColor: Colors.grey,);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminLoginForm()),
      );
      return;
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FrontPage()),
            (Route<dynamic> route) => false,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: message, fontSize: 12, backgroundColor: Colors.grey,);
  }

  if (AuthService().user != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FrontPage()),
    );
  } else {
    Fluttertoast.showToast(
      msg: message, fontSize: 12, backgroundColor: Colors.grey,);
  }
}


Future<UserType> getUserType(String? docId) async {
  try {
    var collectionRef = FirebaseFirestore.instance.collection('studentUsers');
    var doc = await collectionRef.doc(docId).get();
    if(doc.exists) {
      return UserType.student;
    } else{
      collectionRef = FirebaseFirestore.instance.collection('adminUsers');
      var doc = await collectionRef.doc(docId).get();
      if(doc.exists) {
        return UserType.admin;
      }else{
        return UserType.professor;
      }
    }
  } catch (e) {
    throw e;
  }
}





Future<bool> isEnrolledIn(String courseCode) async {
  try {


    var uid = AuthService().user!.uid;
    var codes = await CourseService().getStudentEnrolledCourseCodes(uid);

      return codes.contains(courseCode);


  } catch (e) {
    throw e;
  }
}


void ShowScaffoldMessage(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),),);
}

Future pickImage(ImageSource source) async{

  final image = await ImagePicker().pickImage(source: source, imageQuality: 60,);
  if(image == null) return;

  final imageTemporary = File(image.path);
  return imageTemporary;
  
}



Future<File?> getFile() async {
  File? file;
  late String filePath;

  final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.custom,
    allowedExtensions: ['docx', 'pdf', 'doc', 'XLSX'],);
  if(result == null){
    return null;
  }else{
    filePath = result.files.single.path!;
    file = File(filePath);
    return file;
  }
}





//Open downloaded file

Future openFileFromURL(String URL, String fileName) async{
  final file = await downloadFile(URL, fileName);
  if(file == null) return;
  OpenFile.open(file.path);
}

Future<File?> downloadFile(String url, String fileName) async{
  final appStorage = await getApplicationDocumentsDirectory();
  final file = File('${appStorage.path}/$fileName');



  final response = await Dio().get(url,
    options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout: 0,
    ),
  );



  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  await raf.close();

  return file;


}

void loadingDialog (BuildContext context, dynamic function) async {

  showDialog(

      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                // Some text
                Text('Učitavanje sadržaja', style: textStyleColorBlack,)
              ],
            ),
          ),
        );
      });

  await function;
  await Future.delayed(const Duration(microseconds: 200));


  Navigator.of(context).pop();
}






//Segments

bool ifDefaultSegment(String segmentCode){

  int i = 0;
  while( i != defaultSegments.length){
    if(defaultSegments[i].code == segmentCode) {
      return true;
    }
      i++;

  }
  return false;
}





//Number calculation

double roundToSecondDecimal(double value){

 return double.parse((value).toStringAsFixed(2));
}



//


String getNameFromFirestoreURL(String? name){
  if(name == null) return '';
  return name.split("/").last.split('%2F').first;
}




//Activity mark response

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


String getTimeDifference(DateTime firstDate, DateTime secondDate){
  var timeDifference = secondDate.difference(firstDate);
  int days = timeDifference.inDays;
  int hours = timeDifference.inHours - timeDifference.inDays * 24;
  int minutes = timeDifference.inMinutes - timeDifference.inHours * 60;
  int seconds = timeDifference.inSeconds - timeDifference.inMinutes * 60;
  return days.toString() + (days == 1 ? ' dan ' : ' dana ') + hours.toString() + (hours == 1 ? ' sat ' : hours <= 4 ? ' sata ' : ' sati ' ) +
      minutes.toString() + ' min ' + seconds.toString() + (seconds == 1 ? ' sekunda ' : seconds <= 4 ? ' sekunde ' : ' sekundi ' );
}



void signOut(BuildContext context){
  AuthService().signOut();
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen()));
}



sendNotification(String title, String message, String token) async {

  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };
  try{
    http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAADNa8Aww:APA91bHsWknGEF1vRFqVFzETQW1S-n_AG7tUdfEg3H6x0luL7uBtAxIcbI4P4rbHqG_R5p76zH-xhgGMtKDeX7KFfnM5kUhzrivuuEgCPO-SC9XTg5x6UAyPb4rIM3edAiJblhYaHruX'
    },
        body: jsonEncode(<String,dynamic>{
          'notification': <String,dynamic> {'title': title,'body': message},
          'priority': 'high',
          'data': data,
          'to': '$token'
        })
    );


    if(response.statusCode == 200){
      print("Sent");
    }else{
      print("Error");
    }

  }catch(e){
    print(e);
  }
}


String getNameFromURL(String URL){

  return URL.split(RegExp(r'(%2F)..*(%2F)'))[1].split("?alt")[0];
}

String getExtensionFromFirebaseURL(String URL){

  return p.extension(URL).split('?alt').first.substring(1,p.extension(URL).split('?alt').first.length);
}



const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

List<Question> getQuestionsFromQuestionForm(List<QuestionForm> formQuestions){
  var questions = <Question>[];
  for(var formQuestion in formQuestions){
    questions.add(formQuestion.question);
  }
  return questions;
}


//Provjera jesu li najmamnje dva odgovora
bool checkIfTwoQuestionAnswers(List<Question> questions){
  var allQuestionAnswerValid = true;
  questions.forEach((element) => allQuestionAnswerValid = (allQuestionAnswerValid && (element.answers.length >= 2)));
  return allQuestionAnswerValid;
}


//Navigation
void goToPage({context, page}){
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page
  ));
}

void goBack({context}){
  Navigator.of(context).pop();
}

void goToPageWithLastPop({context, page}){

  Navigator.of(context).pop();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => FrontPage()),
    ModalRoute.withName('/'),
  );
  Navigator.of(context).push(
      MaterialPageRoute(
      builder: (context) => page
    )
  );
}


void showScaffoldMessage({context, message}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)));
}