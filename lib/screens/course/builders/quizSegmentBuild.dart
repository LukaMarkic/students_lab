




import 'package:flutter/material.dart';
import 'package:students_lab/services/database/quizService.dart';
import 'package:students_lab/shared/methods/ungroupedSharedMethods.dart';
import '../../../models.dart';
import '../../../services/auth.dart';
import '../../../services/database/courseService.dart';
import '../../../services/database/gradeService.dart';
import '../../../services/notificationService.dart';
import '../../../shared/methods/navigationMethods.dart';
import '../../../widgets/alertWindow.dart';
import '../../quiz/quizPreview.dart';
import '../courseItem.dart';
import 'futureSegmentsBuild.dart';

class QuizBuild extends StatelessWidget{

  Segment segment;
  String courseCode;
  QuizBuild({
    required this.segment,
    required this.courseCode,
  });

  @override
  Widget build(BuildContext context) {
    List<QuizSegmentModel>? models = <QuizSegmentModel>[];
    if(segment.quizSegmentModels != null){
      segment.quizSegmentModels!.forEach((model) {
        models.add(QuizSegmentModel.fromJson(model));
      });
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
            leading: Icon(Icons.quiz_outlined, color: Colors.blueGrey,),
            title: Text(models[index].title, style: TextStyle(fontSize: 16, height: 2, color: Colors.black54),
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


  Course course;
  Segment segment;
  bool isEditableState;


  ProviderQuizBuild({

    required this.course,
    required this.segment,
    this.isEditableState = false,

  });

  @override
  Widget build(BuildContext context) {

    List<QuizSegmentModel>? models = <QuizSegmentModel>[];
    if(segment.quizSegmentModels != null){
      segment.quizSegmentModels!.forEach((model) {
        models.add(QuizSegmentModel.fromJson(model));
      });
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
            leading: Icon(Icons.quiz_outlined, color: Colors.blueGrey,),
            title: Text(models[index].title, style: TextStyle(fontSize: 16, height: 2, color: models[index].isVisible ? Colors.black54 : Colors.grey),
              softWrap: false,
              overflow: TextOverflow.fade,),
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
                  icon: models[index].isVisible ? Icon(Icons.visibility, color: Colors.green,) : Icon(Icons.visibility_off, color: Colors.blueGrey,),
                  tooltip: 'Učini vidljivog',
                ),

                isEditableState ?  IconButton(
                  onPressed: (){
                    QuizService quizService = QuizService();
                    showAlertWindow(context, 'Želite li izbrisati: ' + models[index].title, () async {
                      Navigator.of(context).pop();

                      //Remove model
                      await CourseService().removeQuizModelFromCourseSegment(course.code, segment.code, models[index]);

                      //Delete quiz with questions
                      await quizService.removeQuiz(models[index].quizID);

                      //Delete grades of all students
                      await quizService.deleteActivityMarkOfStudentsEnrolledInCourse(course.code, segment.code, models[index].quizID);

                      goToPage(context: context, page: FutureSegmentsBuild(course: course));
                    },
                  );
                },
                  icon: Icon(Icons.highlight_remove, color: Colors.lightBlueAccent,),
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

