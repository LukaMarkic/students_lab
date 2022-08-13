
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/courseService.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/widgets/inputs/roundedInput.dart';
import '../../constants.dart';
import '../../models.dart';
import '../../services/database/storageServices.dart';
import '../../shared/methods/fileMethods.dart';
import '../../shared/methods/ungroupedSharedMethods.dart';
import '../../widgets/buttons/addButtonWidget.dart';
import '../../widgets/alertWindow.dart';
import '../../widgets/uploadStatus.dart';
import '../homework/homeworkFormPage.dart';
import '../quiz/FormSteps/quizFormSteps.dart';
import 'builders/futureSegmentsBuild.dart';
import 'builders/homeworkSegmentBuild.dart';
import 'builders/linksSegmentBuild.dart';
import 'builders/quizSegmentBuild.dart';
import 'builders/segmentDocumentBuild.dart';
import 'package:path/path.dart' as p;



class SegmentItem extends StatefulWidget {
  final Segment segment;
  final Course course;
  const SegmentItem({ Key? key, required this.segment, required this.course}) : super(key: key);

  @override
  State<SegmentItem> createState() => _SegmentItemState();
}

class _SegmentItemState extends State<SegmentItem> {

  double? studentSegmentMark;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final studentSegmentMark = await GradeService().getSegmentMark(AuthService().user!.uid, widget.course.code, widget.segment.code);
    setState(() {this.studentSegmentMark = studentSegmentMark;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
        elevation: 5,
        color: listColor,
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.segment.title, style: const TextStyle(fontSize: 18, height: 1.5, fontWeight: FontWeight.bold, color: Colors.black87),
                    overflow: TextOverflow.fade,
                    softWrap: false,),
              widget.segment.title.isNotEmpty ? const Divider(
                color: primaryDividerColor,
                thickness: 1.5,
              ) : Row(),
              DocumentBuild(segment: widget.segment, course: widget.course, isEditableState: false),
              LinkBuild(segment: widget.segment, course: widget.course, isEditableState: false,),
              QuizBuild(segment: widget.segment,courseCode: widget.course.code,),
              HomeworkBuild(course: widget.course, segment: widget.segment),
              studentSegmentMark == null ? Container() : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Divider(height: 1.5, color: primaryDividerColor,),
                  Text('Uspješnost riješenosti:  ${roundToSecondDecimal(studentSegmentMark! * 100)} %', style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 11),)
                ],
              )

            ],
          ),),
        );
  }
}



class ProviderSegmentItem extends StatelessWidget {
  final Segment segment;
  final Course course;

  ProviderSegmentItem({ Key? key, required this.segment, required this.course,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: listColor,
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              segment.title,
              style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
              ),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            segment.title.isNotEmpty ? const Divider(
              color: primaryDividerColor,
              thickness: 1.5,
            ) : Row(),

            DocumentBuild(segment: segment, course: course, isEditableState: false),
            LinkBuild(segment: segment, course: course, isEditableState: false,),
            ProviderQuizBuild( course: course, isEditableState: false, segment: segment,),
            ProviderHomeworkBuild(course: course, segment: segment, isEditableState: false,),
          ],
        ),),
    );
  }
}






class EditableSegmentItem extends StatefulWidget {
  final Segment segment;
  final Course course;

  const EditableSegmentItem({ Key? key, required this.segment, required this.course}) : super(key: key);

  @override
  State<EditableSegmentItem> createState() => _EditableSegmentItemState();
}


class _EditableSegmentItemState extends State<EditableSegmentItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: listColor,
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.segment.title,
                  style: const TextStyle(
                      fontSize: 18, height: 1.5,
                      fontWeight: FontWeight.bold, color: Colors.black87
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                ifDefaultSegment(widget.segment.code) ? const Text('') : IconButton(onPressed: (){
                  showAlertWindow(context, 'Želite li izbrisati: ${widget.segment.title}',() async {

                    //Delete segment
                    Navigator.of(context).pop();
                    await CourseService().removeSegmentFromCourse(widget.course.code, widget.segment);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => FutureSegmentsBuild(course: widget.course)),
                          (Route<dynamic> route) => false,
                      );
                   },
                  );
                }, icon: const Icon(Icons.highlight_remove, color: Colors.black87), tooltip: 'Izbriši segment',),
              ],
            ),
            widget.segment.title.isNotEmpty ? const Divider(
              color: primaryDividerColor,
              thickness: 1.5,
            ) : Row(),
            DocumentBuild(segment: widget.segment, course: widget.course, isEditableState: true),
            LinkBuild(segment: widget.segment, course: widget.course, isEditableState: true,),
            ProviderQuizBuild( course: widget.course, isEditableState: true, segment: widget.segment,),
            ProviderHomeworkBuild(course: widget.course, segment: widget.segment, isEditableState: true,),
            const Divider(color: primaryDividerColor, thickness: 1.5,),
            AddButton(message: 'Dodaj sadržaj', onPress: (){
              showBottomMenu(context);
           }),
          ],
        ),
      ),
    );
  }

  void showBottomMenu(BuildContext context){

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.add_link ),
            title: const Text('Dodaj poveznicu'),
            onTap: () async {
              Navigator.pop(context);
              showLinkUploadForm();
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_copy ),
            title: const Text('Dodaj dokument'),
            onTap: () async {
              Navigator.pop(context);
             var file =  await getFile();
             await showFileSelectedUploadForm(file);
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Stvori kviz'),
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => QuizFormSteps(courseCode: widget.course.code, segmentCode: widget.segment.code,),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Stvori domaću zadaću'),
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeworkForm(courseCode: widget.course.code, segmentCode: widget.segment.code,),
                ),
              );
            },
          ),
        ],
      ),
    );
  }





  Future showFileSelectedUploadForm(File? file) async {
    String fileName = file?.path != null ? file!.path.split('/').last : '';
    UploadTask? task;
    final FirebaseStorageService firebaseStorageService = FirebaseStorageService();
    String? URL;

    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Ispunite podatke'),
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => FutureSegmentsBuild(course: widget.course),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel_presentation,size: 22,),
                        tooltip: 'Izađi',
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      task != null ? buildUploadStatus(task!, fileName) : Column(
                        children: [
                          Container(
                            child: file != null ?  Text(fileName,
                              softWrap: false,
                              overflow: TextOverflow.fade,) : const Text('Dokument nije odabran.') ,
                          ),
                          task == null && file != null ? RoundedInputField(
                            icon: Icons.edit,
                            hintText: "Unesite ime",
                            onChanged: (value) {
                              setState(
                                      () => fileName = value
                              );
                            },
                          ) : Container(),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                        ElevatedButton(
                         child: const Text('Odaberi ponovno'),
                         onPressed: () async {
                           file = await getFile();
                           setState(() {
                             fileName = file?.path != null ? file!.path.split('/').last : '';
                           });
                           setState(() {
                           });
                         },
                       ),
                       file != null ? ElevatedButton(
                         child: const Text('Prenesi'),
                         onPressed: () async {
                           if(file != null){
                             task = await firebaseStorageService.uploadFile(file!, 'files/courses/${widget.course.code}/segments/${widget.segment.code}/files/$fileName');
                             setState(() {
                             });
                             String? url;
                              if(task != null){
                                url = await (await task)?.ref.getDownloadURL();
                              }

                             URL = url.toString();

                             await CourseService().addDocumentToCourseSegment(widget.course.code, widget.segment.code, Document(name: fileName, URL: URL ?? '', extension: p.extension(file!.path)));

                             setState(() {
                             });
                                 Navigator.of(context).pop();
                             Navigator.of(context).push(
                               MaterialPageRoute(
                                 builder: (BuildContext context) => FutureSegmentsBuild(course: widget.course),
                               ),
                             );

                           }
                         },
                       ): Container(),
                     ],
                   ),
                  ],
                );}),
    );

  }




  Future showLinkUploadForm() async {
    String link = '';

    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Ispunite podatke'),
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => FutureSegmentsBuild(course: widget.course),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel_presentation,size: 22,),
                        tooltip: 'Izađi',
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                        RoundedInputField(
                            icon: Icons.link,
                            hintText: "Unesite poveznicu",
                            onChanged: (value) {
                              setState(
                                      () => link = value
                              );
                            },

                      ),
                    ],

                  ),
                  actions: <Widget>[

                        ElevatedButton(
                          child: const Text('Spremi'),
                          onPressed: () async {
                            CourseService().addLinkToCourseSegment(widget.course.code, widget.segment.code, link);
                            setState(() {
                            });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => FutureSegmentsBuild(course: widget.course),
                              ),
                            );
                          },
                        ),

                  ],
                );}),
    );
  }
}













