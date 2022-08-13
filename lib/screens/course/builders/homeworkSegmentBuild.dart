

import 'package:flutter/material.dart';
import '../../../models.dart';
import '../../../services/database/courseService.dart';
import '../../../services/notificationService.dart';
import '../../../shared/methods/navigationMethods.dart';
import '../../../widgets/alertWindow.dart';
import '../../homework/homeworkScreen.dart';
import 'futureSegmentsBuild.dart';


class HomeworkBuild extends StatelessWidget{

  final Course course;
  final Segment segment;

  const HomeworkBuild({Key? key,
    required this.course,
    required this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<HomeworkSegmentModel>? models = <HomeworkSegmentModel>[];
    if(segment.homeworkSegmentModels != null){
      for (var model in segment.homeworkSegmentModels!) {
        models.add(HomeworkSegmentModel.fromJson(model));
      }
    }

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: models.length,
        itemBuilder: (_, index) {
          return models[index].isVisible ? ListTile(
            dense: true,
            textColor: Colors.black87,
            horizontalTitleGap: 4,
            leading: const Icon(Icons.assignment, color: Colors.blueGrey,),
            title: Text(models[index].title, style: TextStyle(fontSize: 16, height: 2, color: models[index].isVisible ? Colors.black54 : Colors.grey),
              softWrap: false,
              overflow: TextOverflow.fade,),

            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => FutureHomeworkBuild(homeworkID: models[index].homeworkID, isProvider: false,)
                ),
              );

            },
          ) : Container();
        }
    );
  }

}




class ProviderHomeworkBuild extends StatelessWidget{


  final Course course;
  final Segment segment;
  final bool isEditableState;

  const ProviderHomeworkBuild({Key? key,
    required this.course,
    required this.segment,
    this.isEditableState = false,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<HomeworkSegmentModel>? models = <HomeworkSegmentModel>[];
    if(segment.homeworkSegmentModels != null){
      for (var model in segment.homeworkSegmentModels!) {
        models.add(HomeworkSegmentModel.fromJson(model));
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
            leading: const Icon(Icons.assignment, color: Colors.blueGrey,),
            title: Text(models[index].title, style: TextStyle(fontSize: 16, height: 2, color: models[index].isVisible ? Colors.black54 : Colors.grey),
              softWrap: true,
              ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () async {
                  models[index].isVisible = !models[index].isVisible;
                  if(models[index].isVisible){
                    NotificationService().sendNotificationToEnrolledStudentsUsers('Domaća zadaća: ${models[index].title}', 'Objavljanja je domaća zadaća iz predmeta ${course.title}', [course.code]);
                  }
                  await CourseService().updateHomeworkModels(course.code, segment.code, models);

                  goToPage(context: context, page: FutureSegmentsBuild(course: course, ));
                },
                  icon: models[index].isVisible ? const Icon(Icons.visibility, color: Colors.green,) : const Icon(Icons.visibility_off, color: Colors.blueGrey,),
                  tooltip: !models[index].isVisible ? 'Učini vidljivog' : 'Sakrij',
                ),

                isEditableState ?  IconButton(onPressed: (){
                  showAlertWindow(context, 'Želite li izbrisati: ${models[index].title}', () async {
                    Navigator.of(context).pop();

                    //Remove from segment
                    await CourseService().removeHomeworkModelFromCourseSegment(course.code, segment.code, models[index]);

                    //Go to course page
                    goToPage(context: context, page: FutureSegmentsBuild(course: course, ));
                  },);
                },
                  icon: const Icon(Icons.highlight_remove, color: Colors.lightBlueAccent,),
                  tooltip: 'Ukloni zadaću',
                ) : Column(mainAxisSize: MainAxisSize.min,),
              ],),
            onTap: (){
              goToPage(context: context, page: FutureHomeworkBuild(homeworkID: models[index].homeworkID, isProvider: true,));
            },
          );
        }
    );
  }

}
