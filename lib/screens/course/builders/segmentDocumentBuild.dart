
import 'package:flutter/material.dart';
import 'package:students_lab/services/database/storageServices.dart';
import '../../../models.dart';
import '../../../services/database/courseService.dart';
import '../../../shared/methods/fileMethods.dart';
import '../../../shared/methods/navigationMethods.dart';
import '../../../widgets/alertWindow.dart';
import 'futureSegmentsBuild.dart';

class DocumentBuild extends StatelessWidget{

  final Segment segment;
  final Course course;
  final bool isEditableState;

  const DocumentBuild({Key? key,
    required this.segment,
    required this.course,
    this.isEditableState = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Document> documents = segment.documents.map((d) => Document.fromJson(d)).toList();
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: documents.length,
        itemBuilder: (_, index) {
          return ListTile(
            dense: true,
            textColor: Colors.black87,
            horizontalTitleGap: 4,
            leading: Image.asset('assets/images/${documents[index].extension.substring(1,documents[index].extension.length)}-logo.png', height: 28),
            title: Text(documents[index].name, style: const TextStyle(fontSize: 16, height: 2),
              softWrap: true,
              ),
            onTap: (){
              loadingDialog(context, openFileFromURL(documents[index].URL, documents[index].name + documents[index].extension));
            },

            //Delete button part
            trailing: isEditableState ? IconButton(
              onPressed: (){
                showAlertWindow(context, 'Želite li izbrisati: ${documents[index].name}', () async {
                  Navigator.of(context).pop();
                  await CourseService().removeDocumentFromCourseSegment(course.code, segment.code, documents[index]);

                  //remove from Firestore
                  FirebaseStorageService().deleteFileWithURL(documents[index].URL);
                  goToPage(context: context, page: FutureSegmentsBuild(course: course));
                  },
                );
              },
              icon: const Icon(Icons.highlight_remove, color: Colors.lightBlueAccent,),
              tooltip: 'Ukloni dokument',
            ) : Row(mainAxisSize: MainAxisSize.min,),
            //

          );
        }
    );
  }
}
