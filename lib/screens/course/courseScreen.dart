
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/screens/course/segmentItem.dart';
import 'package:students_lab/screens/frontpage.dart';
import 'package:students_lab/services/auth.dart';
import '../../error.dart';
import '../../loading.dart';
import '../../models.dart';
import 'package:students_lab/services/database/profileService.dart';
import '../../services/database/courseService.dart';
import '../../shared/sharedMethods.dart';
import '../../widgets/roundedInput.dart';
import '../../widgets/scalableButton.dart';
import 'courseItem.dart';
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







class StudentCourseScreen extends StatefulWidget {
  final Course course;
  List<Segment>? segments;
  StudentCourseScreen({Key? key,required this.course, this.segments}) : super(key: key);

  @override
  State<StudentCourseScreen> createState() => _StudentCourseScreenState();
}

class _StudentCourseScreenState extends State<StudentCourseScreen> {

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.course.color).withOpacity(0.9),
        actions: [
         FutureBuilder<ElevatedButton>(future: FutureElevatedButtonLabelEnrolment(context, widget.course.code), builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container();}
            else{
              return snapshot.data ?? Container();
            }
          }),

        ],
      ),
      body: SingleChildScrollView(child:
          Column(
              children: [
               courseCoverTheme(widget.course, size),
               SizedBox(height: size.height*0.05,),
               ClientSegmentBuild(segments: widget.segments, course: widget.course,),
           ],
          ),
      ),
    );
  }

}







class ProviderCourseScreen extends StatefulWidget {
  final Course course;
  List<Segment>? segments;

  ProviderCourseScreen({Key? key,required this.course, this.segments,}) : super(key: key);

  @override
  State<ProviderCourseScreen> createState() => _ProviderCourseScreenState();
}

class _ProviderCourseScreenState extends State<ProviderCourseScreen> {

  bool _isEditableState = false;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.arrow_back_outlined), onPressed: () { goToPage(context: context, page: FrontPage()); },
        ),
        backgroundColor: Color(widget.course.color).withOpacity(0.9),
        actions: [
          EditIcon(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          courseCoverTheme(widget.course, size),
          SizedBox(height: size.height*0.05,),
          _isEditableState ?

          ScalableButton(text: 'Dodaj segment', press: (){
            addCourseSegmentForm(widget.course);
          }, color: Color(widget.course.color), width: size.width*0.95,): Container(),
          ProvidersSegmentBuild(segments: widget.segments, course: widget.course, isEditableState: _isEditableState,),
        ]
        ),
      ),
    );
  }


  Widget EditIcon() {

    return IconButton(onPressed: (){
      setState(() {
        _isEditableState = !_isEditableState;
      });

    }, icon: _isEditableState ? Icon(Icons.cancel) : Icon(Icons.edit),
        tooltip: _isEditableState ? 'Izađi' : 'Uredi',
    );

  }





  Future addCourseSegmentForm(Course course) async {

    String? segmentName;
    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Dodajte novi segment!'),
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
                      RoundedInputField(
                        icon: Icons.segment,
                        hintText: "Unesite naziv segmenta",
                        onChanged: (value) {
                          setState(
                                  () => segmentName = value
                          );
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                        ElevatedButton(
                            child: const Text('Dodaj'),
                            onPressed: () async {
                              if(segmentName == null){
                                Fluttertoast.showToast(
                                  msg: 'Unesite naziv segmenta', fontSize: 12, backgroundColor: Colors.grey,);
                              }
                              else{
                                Navigator.of(context).pop();
                                Segment segment = Segment(title: segmentName ?? 'Segment',);
                                await CourseService().addSegmentToCourse(course.code, segment);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => FutureSegmentsBuild(course: course)),
                                      (Route<dynamic> route) => false,
                                );

                              }
                            }
                        ),

                  ],
                );}),
    );

  }


}







class ClientSegmentBuild extends StatelessWidget{
  List<Segment>? segments;
  final Course course;
  List<Quiz>? quizzes;
  ClientSegmentBuild({Key? key, this.segments, required this.course, this.quizzes});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: segments?.length ?? 0,
                  itemBuilder: (_, index) {
                    return SegmentItem(segment: segments![index], course: course,);
                  }
              );
  }
}


class ProvidersSegmentBuild extends StatelessWidget{
  List<Segment>? segments;
  final Course course;
  bool isEditableState;
  ProvidersSegmentBuild({Key? key, this.segments, required this.course, this.isEditableState = false});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: segments?.length ?? 0,
        itemBuilder: (_, index) {
          return isEditableState ? EditableSegmentItem(segment: segments![index], course: course, ) : ProviderSegmentItem(segment: segments![index], course: course);
        }
    );
  }
}





Widget courseCoverTheme(dynamic course, Size size){
  return Hero(
    tag: course,
    child:
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
  );
}






//Icons


Future<ElevatedButton> FutureElevatedButtonLabelEnrolment(BuildContext context, String courseCode) {
  ProfileService profileService = ProfileService();
  String uid = AuthService().user!.uid;

  return isEnrolledIn(courseCode).then((isEnrolled) {
    if (isEnrolled) {
      return ElevatedButton.icon(onPressed: () async {
        await profileService.leaveCourse(uid, courseCode);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FrontPage()),
              (Route<dynamic> route) => false,
        );
      }, icon: Icon(Icons.remove), label: const Text('Napusti'),
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 12),
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      );
    } else {
      return ElevatedButton.icon(onPressed: () async {
        await profileService.enrollInCourse(uid, courseCode);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FrontPage()),
              (Route<dynamic> route) => false,
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













