
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models.dart';
import '../../../services/database/courseService.dart';
import '../../../widgets/alertWindow.dart';
import '../courseItem.dart';


class LinkBuild extends StatelessWidget{

  Segment segment;
  Course course;
  bool isEditableState;

  LinkBuild({
    required this.segment,
    required this.course,
    this.isEditableState = false,
  });

  @override
  Widget build(BuildContext context) {
    List<String> links = segment.linkURLs ?? <String>[];
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: links?.length ?? 0,
        itemBuilder: (_, index) {
          return ListTile(
            dense: true,
            textColor: Colors.black87,
            horizontalTitleGap: 4,
            leading: Icon(Icons.link_rounded, color: Colors.green,),
            title: Text(links[index], style: TextStyle(fontSize: 16, height: 2, color: Colors.lightBlue),
              softWrap: false,
              overflow: TextOverflow.ellipsis,),
            onTap: (){
              launch(links[index]);
            },
            trailing: isEditableState ? IconButton(onPressed: (){
              showAlertWindow(context, 'Želite li izbrisati: ' + links[index], () async {
                Navigator.of(context).pop();
                await CourseService().removeLinkFromCourseSegment(course.code, segment.code, links[index]);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => FutureSegmentsBuild(course: course)),
                      (Route<dynamic> route) => false,
                );
              },);
            },
              icon: Icon(Icons.highlight_remove, color: Colors.lightBlueAccent,),
              tooltip: 'Ukloni link',
            ) : Row(mainAxisSize: MainAxisSize.min,),
          );
        }
    );
  }

}