
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import '../../models.dart';
import '../../shared/methods/navigationMethods.dart';
import 'builders/futureSegmentsBuild.dart';



class CourseItem extends StatelessWidget {
  final Course course;
  const CourseItem({ Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: course,
      child: Card(
        elevation: 5,
        color: courseItemThemeColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            goToPage(context: context, page: FutureSegmentsBuild(course: course));
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
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle( height: 1.25, fontWeight: FontWeight.bold, color: Colors.white ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        ' ECTS: ${course.ECTS}',
                        style: const TextStyle( height: 0.75, fontWeight: FontWeight.w500, color: Colors.white ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ],
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










