
import 'package:flutter/material.dart';
import '../../../error.dart';
import '../../../loading.dart';
import '../../../models.dart';
import '../../../services/database/courseService.dart';
import '../courseScreen/courseScreen.dart';


class FutureSegmentsBuild extends StatelessWidget{

  final Course course;

  const FutureSegmentsBuild({Key? key, required this.course,}) : super(key: key);

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
              return const CircularProgressIndicator();
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