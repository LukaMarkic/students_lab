
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/calendarService.dart';
import 'package:students_lab/services/database/courseService.dart';
import 'package:students_lab/services/database/homeworkService.dart';
import 'package:students_lab/widgets/buttons/roundedButton.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:students_lab/widgets/buttons/squaredButton.dart';
import '../../models.dart';
import '../../services/database/storageServices.dart';
import '../../shared/methods/fileMethods.dart';
import '../../shared/methods/navigationMethods.dart';
import '../../shared/methods/ungroupedSharedMethods.dart';
import '../../theme.dart';
import '../../widgets/backgroundImageWidget.dart';
import '../../widgets/inputs/roundedInput.dart';
import '../../widgets/containers/textFieldWrapper.dart';
import '../../widgets/uploadStatus.dart';
import '../course/courseScreen/courseScreen.dart';



class HomeworkForm extends StatefulWidget {

  String courseCode, segmentCode;
  HomeworkForm({
    required this.courseCode,
    required this.segmentCode,
  });
  @override
  _HomeworkFormState createState() => _HomeworkFormState();
}

class _HomeworkFormState extends State<HomeworkForm> {

  final DateTime now = DateTime.now();
  late String title;
  late String description;
  late DateTime deadline = DateTime.now().add(Duration(seconds: 1));
  DateTime defaultTime = DateTime.now();
  late String? URL = null;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Theme(
        data: calendarTheme,
        child: Builder(builder: (context) {
          return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black54,
          ),
          title: Text('Obrazac domaće zadaće'),
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,

        ),
        body: BackgroundImageWidget(imagePath: 'assets/images/homework-background.jpg',
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
              children: [
                SizedBox(height: 5,),
                RoundedInputField(
                  validatorMessage: 'Potrebno unijet naziv',
                  borderRadius: 5,
                  icon: Icons.title,
                  hintText: "Unesite naziv domaće zadaće",
                  onChanged: (value) {
                    setState(
                            () => title = value
                    );
                  },
                ),
                SizedBox(height: 5,),
                RoundedInputField(
                  validatorMessage: 'Potrebno unijeti opis',
                  borderRadius: 5,
                  color: Colors.white,
                  icon: Icons.description,
                  hintText: "Unesite opis zadaće",
                  onChanged: (value) {
                    setState(
                            () => description = value
                    );
                  },
                ),
                SizedBox(height: 5,),
                Container(
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text('Unesite rok predaje', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 16),),),
                      TextFieldWrapper(
                        borderRadius: 5,
                        margin: EdgeInsets.zero,
                        color: keyPrimaryColor,
                        child: DefaultTextStyle.merge(
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          child: DateTimePicker(
                            autocorrect: true,
                            locale: Locale('hr'),
                            style: TextStyle(color: Colors.black54,),
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            initialValue: now.toString(),
                            firstDate: now.add(Duration(minutes: 1)),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event, color: buttonColor,),
                            dateLabelText: 'Datum',
                            timeLabelText: "Vrijeme",
                            onChanged: (val) => deadline = DateTime.parse(val),
                            validator: (val) => (val != null && ( DateTime.parse(val).isBefore(now) || val == now.toString)) ? 'Neodgovarajući\ndatum' : null,
                            onSaved: (val) => deadline = DateTime.parse(val!),
                          ),
                        ),
                      ),
                    ],
                  ),),

                SizedBox(height: 15,),
                SquaredButton(text: 'Dodaj dokument',
                  widthRatio: 0.8,
                  press: () async {
                    var file = await getFile();
                    await showFileSelectedUploadForm(file);
                 },
                ),
                SizedBox(height: size.height*0.2,),
                RoundedButton(text: 'Stvori zadaću',
                  color: Colors.lightGreenAccent.withOpacity(0.8),
                  press: () async {
                  if(_formKey.currentState!.validate()){
                    Homework homework = Homework(courseCode: widget.courseCode, title: title, description: description,
                        deadline: deadline, documentURL: URL, segmentCode: widget.segmentCode);

                    var homeworkID = await HomeworkService().addHomework(homework);

                    if (homeworkID != null) {

                      //Add to segment
                      HomeworkSegmentModel homeworkModel = HomeworkSegmentModel(title: homework.title, homeworkID: homework.id,);
                      CourseService().addHomeworkModelToCourseSegment(widget.courseCode, widget.segmentCode, homeworkModel);

                      //Add event to professor and all enrolledStudents
                      Event event = Event(title: title, description: description, day: deadline, courseCode: widget.courseCode);
                      CalendarService().addEventToUser('professorUsers', AuthService().user!.uid, event);
                      CalendarService().setEventToAllEnrolledStudents(widget.courseCode, event);

                      //Go to course page
                      var segments = await CourseService().getCourseSegments(event.courseCode!);
                      var course = await CourseService().getCourseData(event.courseCode!);
                      goToPageWithLastPop(context: context, page: CourseScreen(course: course, segments: segments,));
                    }

                  }

                },
                ),

                SizedBox(
                  height: 60,
                ),
              ],
            ),
            ),
          ),
        ),
      );
    }
    )
    );
  }


  Future showFileSelectedUploadForm(File? file) async {
    String fileName = file?.path != null ? file!
        .path
        .split('/')
        .last : '';
    UploadTask? task;
    final FirebaseStorageService firebaseStorageService = FirebaseStorageService();


    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Ispunite podatke'),
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.cancel_presentation, size: 22,),
                        tooltip: 'Izađi',
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      task != null ? buildUploadStatus(task!, fileName) : Container(child:
                      Column(
                        children: [
                          Container(
                            child: file != null ? Text(fileName,
                              softWrap: false,
                              overflow: TextOverflow.fade,) : Text(
                                'Dokument nije odabran.'),
                          ),
                          task == null && file != null ? RoundedInputField(
                            hintText: "Unesite ime",
                            onChanged: (value) {
                              setState(
                                      () => fileName = value
                              );
                            },
                          ) : Container(),
                        ],
                      ),
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
                              fileName = file?.path != null ? file!
                                  .path
                                  .split('/')
                                  .last : '';
                            });
                            setState(() {});
                          },
                        ),
                        file != null ? ElevatedButton(
                          child: const Text('Prenesi'),
                          onPressed: () async {
                            if (file != null) {
                              task = await firebaseStorageService.uploadFile(
                                  file!, 'files/courses/${widget.courseCode}/segments/${widget.segmentCode}/files/homework/$fileName');
                              setState(() {});

                              var url = await (await task)?.ref
                                  .getDownloadURL();
                              URL = url.toString();

                              setState(() {});
                              Navigator.of(context).pop();
                            }
                          },
                        ) : Container(),
                      ],
                    ),
                  ],
                );
              }),
    );
  }
}
