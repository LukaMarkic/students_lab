
import 'package:flutter/material.dart';
import '../../../models.dart';
import '../../../services/auth.dart';
import '../../../services/database/courseService.dart';
import '../../../services/database/gradeService.dart';
import '../../../services/notificationService.dart';
import '../../../shared/methods/navigationMethods.dart';
import '../../../widgets/alertWindow.dart';
import '../../quiz/quizPreview.dart';
import 'futureSegmentsBuild.dart';

class QuizBuild extends StatelessWidget{

  final Segment segment;
  final String courseCode;

  const QuizBuild({Key? key,
    required this.segment,
    required this.courseCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<QuizSegmentModel>? models = <QuizSegmentModel>[];
    if(segment.quizSegmentModels != null){
      for (var model in segment.quizSegmentModels!) {
        models.add(QuizSegmentModel.fromJson(model));
      }
    }

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: models.length,
        itemBuilder: (_, index) {
          return  models[index].isVisible ? ListTile(
            dense: true,
            textColor: Colors.black87,
            horizontalTitleGap: 4,
            leading: const Icon(Icons.quiz_outlined, color: Colors.blueGrey,),
            title: Text(models[index].title, style: const TextStyle(fontSize: 16, height: 2, color: Colors.black54),
              softWrap: false,
              overflow: TextOverflow.fade,),
            onTap: () async {
              var activityMark = await GradeService().checkIsQuizFinishedAnReturnResults(AuthService().user!.uid, courseCode, segment.code, models[index].quizID);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FutureQuizBuild(quizID: models[index].quizID, isProvider: false, activityMark: activityMark,)),
              );
            },
          ) : Row(mainAxisSize: MainAxisSize.min,);
        }
    );
  }

}


class ProviderQuizBuild extends StatelessWidget{


  final Course course;
  final Segment segment;
  final bool isEditableState;


  const ProviderQuizBuild({Key? key,

    required this.course,
    required this.segment,
    this.isEditableState = false,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<QuizSegmentModel>? models = <QuizSegmentModel>[];
    if(segment.quizSegmentModels != null){
      for (var model in segment.quizSegmentModels!) {
        models.add(QuizSegmentModel.fromJson(model));
      }
    }

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: models.length,
        itemBuilder: (_, index) {
          return ListTile(
            dense: true,
            textColor: Colors.black87,
            horizontalTitleGap: 4,
            leading: const Icon(Icons.quiz_outlined, color: Colors.blueGrey,),
            title: Text(models[index].title, style: TextStyle(fontSize: 16, height: 2, color: models[index].isVisible ? Colors.black54 : Colors.grey),
              softWrap: true,
              ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () async {
                  models[index].isVisible = !models[index].isVisible;
                  if(models[index].isVisible){
                    NotificationService().sendNotificationToEnrolledStudentsUsers('Provjera: ${models[index].title}', 'Objavljanja je provjera iz predmeta ${course.title}', [course.code]);
                  }
                  await CourseService().updateQuizModels(course.code, segment.code, models);
                  goToPage(context: context, page: FutureSegmentsBuild(course: course,));
                },
                  icon: models[index].isVisible ? const Icon(Icons.visibility, color: Colors.green,) : const Icon(Icons.visibility_off, color: Colors.blueGrey,),
                  tooltip: 'Učini vidljivog',
                ),

                isEditableState ?  IconButton(
                  onPressed: (){
                    showAlertWindow(context, 'Želite li izbrisati: ${models[index].title}', () async {
                      Navigator.of(context).pop();

                      //Remove model
                      await CourseService().removeQuizModelFromCourseSegment(course.code, segment.code, models[index]);

                      goToPage(context: context, page: FutureSegmentsBuild(course: course));
                    },
                  );
                },
                  icon: const Icon(Icons.highlight_remove, color: Colors.lightBlueAccent,),
                  tooltip: 'Ukloni kviz',
                ) : Column(mainAxisSize: MainAxisSize.min,),
              ],),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => FutureQuizBuild(quizID: models[index].quizID, isProvider: true,)
                ),
              );

            },
          );
        }
    );
  }

}

