
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../error.dart';
import '../../../loading.dart';
import '../../../models.dart';
import '../../../services/database/courseService.dart';
import '../courseScreen/courseScreen.dart';



class FutureSegmentsBuild extends StatelessWidget{
  Course course;

  FutureSegmentsBuild({required this.course,});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: CourseService().getCourseSegments(course.code),
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
              List<Segment>? segments = snapshot.data;
              return CourseScreen(course: course, segments: segments,);
            }
          }
        }
    );
  }

}