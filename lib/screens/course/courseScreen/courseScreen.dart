
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/screens/course/courseScreen/providerCourseScreen.dart';
import 'package:students_lab/screens/frontPages/frontpage.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/widgets/alertWindow.dart';
import 'package:students_lab/widgets/containers/dividerWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../error.dart';
import '../../../../loading.dart';
import '../../../../models.dart';
import 'package:students_lab/services/database/profileService.dart';
import '../../../shared/methods/ungroupedSharedMethods.dart';
import '../../../constants.dart';
import '../../../shared/methods/activityMarkResponseMethods.dart';
import '../../../shared/methods/profileUserMethods.dart';
import 'studentCourseScreen.dart';
import 'dart:async';


class CourseScreen extends StatelessWidget {
  
  final Course course;
  List<Segment>? segments;
  CourseScreen({Key? key,required this.course, this.segments});


  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
        future: getUserType(AuthService().user?.uid.toString()),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          }
          else {
            if (snapshot.data == UserType.student){
              return StudentCourseScreen(course: course, segments: segments,);
            } else{
              return ProviderCourseScreen(course: course, segments: segments,);
            }
          }
        }
    );

  }
}




//Theme

Widget CourseCoverTheme(Course course, Size size, double? courseGrade,List<ProfileProfessor> assignedProfessors, context){

  return Hero(
    tag: course,
    child:
   Column(children: [
     Stack(
       children: [
         course.imgURL != null ? Image.network(course.imgURL!, fit: BoxFit.cover, height: size.height*0.15, width: size.width,
           loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
             if (loadingProgress == null) {return child;}
             return Stack(children: [Container(decoration: BoxDecoration(color: Color(course.color),),),],);
           },
         ) :
         Container(width: size.width, height: size.height*0.15, decoration: BoxDecoration(color: Color(course.color),),),

         Positioned.fill(
           child: Align(
             alignment: Alignment.bottomCenter,
             child: Container(
               width: size.width,
               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
               decoration: const BoxDecoration(
                 color: primaryThemeColor,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                 boxShadow: [
                   BoxShadow(color: primaryThemeColor, spreadRadius: 1, offset: Offset(0, 1),),
                 ],
               ),
               child: Text(course.title, style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold,),
                 textAlign: TextAlign.center,
               ),
             ),
           ),
         ),

       ],
     ),
     ExpansionTile(
       textColor: Colors.black,
       backgroundColor: listColor,
       title: Text('Detalji kolegija...', style: TextStyle(fontSize: 17),),
       children: <Widget>[
           Container(
             padding: EdgeInsets.symmetric(horizontal: 18),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(height: 5,),
                 courseGrade != null ? Row(children: [
                   const Text('Uspješnost: ', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15)),
                   Text('${roundToSecondDecimal(courseGrade * 100)}%', style: TextStyle(color: getResultColor(courseGrade), fontSize: 14),),
                 ],) : Container(),
                 SizedBox(height: 5,),
                 Row(children: [
                   const Text('Semestar: ', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15)),
                   Text('${course.semester}.', style: TextStyle(color: Colors.black38, fontSize: 14),),
                 ],),
                 SizedBox(height: 5,),
                 Row(children: [
                   const Text('ECTS: ', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15)),
                   Text('${course.ECTS}', style: TextStyle(color: Colors.black38, fontSize: 14.5),),
                 ],),
                 DividerWrapper(margin: EdgeInsets.only(top: 2, bottom: 5),),
                 Text('Pregled predavača', textAlign: TextAlign.start, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),),

                 ListView.builder(
                     physics: const NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                     itemCount: assignedProfessors.length,
                     itemBuilder: (_, index) {
                       return ListTile(
                         leading: Icon(Icons.account_circle_outlined, color: Colors.blueGrey, size: 36,),
                         title: Text('${assignedProfessors[index].name} ${assignedProfessors[index].surname}', style: TextStyle(color: Colors.black54, fontSize: 15.5)),
                         subtitle:
                               Tooltip(
                                 message: 'Pošalji elektronsku poštu.',
                                 child:
                                 InkWell(
                                   onTap:  ()  {
                                     final url = 'mailto:${assignedProfessors[index].email}';
                                     launch(url);
                                   },
                                   child: Text(assignedProfessors[index].email,
                                     style:  const TextStyle(
                                         fontSize: 14.0, color: Colors.black38,),
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ),
                               ),
                       );
                     }
                 ),
               ],
             ),
           ),
       ],
     ),
   ],),
  );
}






//Icons


Future<ElevatedButton> FutureElevatedButtonLabelEnrolment(BuildContext context, String courseCode) {
  ProfileService profileService = ProfileService();
  String uid = AuthService().user!.uid;

  return isEnrolledIn(courseCode).then((isEnrolled) {
    if (isEnrolled) {
      return ElevatedButton.icon(onPressed: (){
        showAlertWindow(context, 'Želite li napustiti kolegij?', () async {
          await profileService.leaveCourse(uid, courseCode);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FrontPage()),
                (Route<dynamic> route) => false,
          );
        });
      }, icon: Icon(Icons.remove), label: const Text('Napusti'),
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 12),
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      );
    } else {
      return ElevatedButton.icon(onPressed: (){
        showAlertWindow(context, 'Želite li se upisati na kolegij?', () async {
          await profileService.enrollInCourse(uid, courseCode);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FrontPage()),
                (Route<dynamic> route) => false,
            );
          }
        );
      }, icon: Icon(Icons.add), label: const Text('Upiši se',),
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 12),
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      );
    }
  });
}













