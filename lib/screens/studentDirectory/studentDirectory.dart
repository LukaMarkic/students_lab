
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_lab/screens/profile.dart';
import 'package:students_lab/shared/methods/ungroupedSharedMethods.dart';
import 'package:students_lab/widgets/containers/dividerWidget.dart';
import 'package:students_lab/widgets/profilePhoto.dart';
import '../../constants.dart';
import '../../error.dart';
import '../../loading.dart';
import '../../models.dart';
import '../../shared/methods/stringManipulationMethods.dart';
import '../../theme.dart';


class FutureStudentDirectoryPage extends StatefulWidget{

  ProfileStudent student;
  List<String> professorCourseCodes;
  FutureStudentDirectoryPage({Key? key,
    required this.student,
    this.professorCourseCodes = const [],
  }) : super(key: key);

  @override
  State<FutureStudentDirectoryPage> createState() => _FutureStudentDirectoryPageState();
}

class _FutureStudentDirectoryPageState extends State<FutureStudentDirectoryPage> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCourseStudentDirectoryModels(getCourseDirectoryCodes(widget.student.enrolledCoursesCodes, widget.professorCourseCodes), widget.student.id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          }
          else {
            List<CourseStudentDirectoryModel> courseStudentModels = snapshot.data;
            return StudentDirectoryPage(student: widget.student, courseStudentModels: courseStudentModels,);
          }
        }
    );
  }
}






class StudentDirectoryPage extends StatefulWidget{

  ProfileStudent student;
  List<CourseStudentDirectoryModel> courseStudentModels = [];
  StudentDirectoryPage({Key? key, required this.student, this.courseStudentModels = const []});

  @override
  State<StudentDirectoryPage> createState() => _StudentDirectoryPageState();
}

class _StudentDirectoryPageState extends State<StudentDirectoryPage> {


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: calendarTheme,
      child: Builder(builder: (context) {
        return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: profileColor,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const SizedBox(width: 5,),
                              ProfilePhotoOval(imageURL: widget.student.imgURL, width: 80, height: 80,),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: ProfileNameInfo(profileUser: widget.student, email: widget.student.email,),),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Divider(height: 5, color: primaryDividerColor,),),
                        Container(
                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                          child: IntrinsicHeight(child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.today, color: Color(0Xff0286bf),
                                size: 28,),
                              const SizedBox(width: 10),
                              Text(getTimeFormat(widget.student.birthDate),
                                style: GoogleFonts.oswald( textStyle: const TextStyle(
                                  fontSize: 18.0, color: Colors.black54,),
                                ),
                              ),
                              const VerticalDivider(
                                color: primaryDividerColor, width: 20, thickness: 1.5,
                              ),
                              const Icon(
                                Icons.keyboard_alt_outlined, color: Color(0Xff0286bf),
                                size: 28,),
                              const SizedBox(width: 10),
                              Text('***********${getHiddenCode(widget.student.id)}',
                                style: GoogleFonts.oswald(
                                  textStyle: const TextStyle(
                                    fontSize: 18.0, color: Colors.black54,),
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.courseStudentModels.length,
                      itemBuilder: (_, indexOne) {
                        return Card(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.courseStudentModels[indexOne].title, style: const TextStyle( fontSize: 16,
                                        fontWeight: FontWeight.bold, color: Colors.black87),),
                                    Text( '${roundToSecondDecimal(widget.courseStudentModels[indexOne].courseGrade ?? 0.0)*100} %',style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              DividerWrapper(padding: const EdgeInsets.symmetric(horizontal: 10),),
                              const SizedBox(height: 5,),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: widget.courseStudentModels[indexOne].segmentModels.length,
                                  itemBuilder: (_, indexTwo) {
                                    return
                                      ExpansionPanelList(
                                        animationDuration: const Duration(milliseconds: 800),
                                        children: [
                                          ExpansionPanel(
                                            headerBuilder: (context, isExpanded) {
                                              return ListTile(
                                                title: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        ConstrainedBox(
                                                          constraints: const BoxConstraints(
                                                            maxWidth: 140.0,
                                                          ),
                                                          child: Text(widget.courseStudentModels[indexOne].segmentModels[indexTwo].title, style: const TextStyle(color: Colors.black87), softWrap: true,),
                                                        ),
                                                        Text('${roundToSecondDecimal(widget.courseStudentModels[indexOne].segmentModels[indexTwo].segmentMark ?? 0.0)*100}%',style: const TextStyle(color: Colors.black54, fontSize: 12), ),
                                                      ],
                                                    ),
                                                    DividerWrapper(padding: const EdgeInsets.only(top: 5,),),
                                                  ],
                                                ),
                                              );
                                            },
                                            body: Container(
                                              padding: const EdgeInsets.only(top: 12, bottom: 10),
                                              child: ListView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels.length,
                                                  itemBuilder: (_, indexThree) {
                                                    return Card(
                                                      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                                                      child: ListTile(
                                                        dense: true,
                                                        leading: Icon(widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].activityType == ActivityType.homework ? Icons.assessment : Icons.quiz_outlined, size: 24),
                                                        title: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                ConstrainedBox(
                                                                  constraints: const BoxConstraints(
                                                                    maxWidth: 140.0,
                                                                  ),
                                                                  child: Text(widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].title, style: const TextStyle(color: Colors.black87), softWrap: true,),
                                                                ),


                                                                widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].activityType == ActivityType.homework ?
                                                                  widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].isSubmitted ?
                                                                   widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].mark != null ?
                                                                    Text('${ roundToSecondDecimal(widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].mark ?? 0.0)*100}%', style: const TextStyle(color: Colors.black54), softWrap: true,)
                                                                    : const Text('Nije ocjenjeno', style: TextStyle(color: Colors.lightBlue),) : const Text('Nije predano', style: TextStyle(color: Colors.red),) :
                                                                widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].isSubmitted ?
                                                                Text('${ roundToSecondDecimal(widget.courseStudentModels[indexOne].segmentModels[indexTwo].activityModels[indexThree].mark ?? 0.0)*100}%', style: const TextStyle(color: Colors.black54))
                                                                     :
                                                                const Text('Nije odrađeno', style: TextStyle(color: Colors.red)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ), );
                                                  }),),
                                            isExpanded: widget.courseStudentModels[indexOne].segmentModels[indexTwo].isExtended,
                                            canTapOnHeader: true,
                                          ),
                                        ],
                                        dividerColor: Colors.black,
                                        expansionCallback: (panelIndex, isExpanded) {
                                          widget.courseStudentModels[indexOne].segmentModels[indexTwo].isExtended = !widget.courseStudentModels[indexOne].segmentModels[indexTwo].isExtended;
                                          setState(() {
                                          });
                                        },
                                      );
                                  }
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                  const SizedBox(height: 30,),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}




List<String> getCourseDirectoryCodes(List<String> studentCourseCodes, List<String> professorCourseCodes){

  List<String> courseCodes = studentCourseCodes.where((element) => professorCourseCodes.contains(element)).toList();
  return courseCodes;
}
