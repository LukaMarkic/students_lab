
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../error.dart';
import '../../loading.dart';
import '../../models.dart';
import '../../services/database/courseService.dart';
import 'courseScreen.dart';


class CourseItem extends StatelessWidget {
  final Course course;
  const CourseItem({ Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: course,
      child: Card(
        elevation: 5,
        color: Color(0Xff6f95b3),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => FutureSegmentsBuild(course: course),
              ),
            );

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(
                  child:
                  course.imgURL == null ? Container(decoration: BoxDecoration(color: Color(course.color),),) :
                  Image.network(course.imgURL!, fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Stack(children: [
                        Container(decoration: BoxDecoration(color: Color(course.color),),),
                      ],
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    course.title,
                    style: const TextStyle(
                      height: 1.25,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      );
  }
}



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




