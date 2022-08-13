
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/screens/administrator/adminFrontPage.dart';
import 'package:students_lab/services/database/profileService.dart';
import '../../widgets/buttons/roundedButton.dart';
import 'createProfessorsAccount.dart';



class AssignCourseToProfessor extends StatefulWidget {
  const  AssignCourseToProfessor({ Key? key }) : super(key: key);

  @override
  _AssignCourseToProfessor createState() => _AssignCourseToProfessor();
}

class _AssignCourseToProfessor extends State<AssignCourseToProfessor> with SingleTickerProviderStateMixin {

  List<String>? selectedCoursesCodes = <String>[];
  List<CourseSelectModel>? courseModels = <CourseSelectModel>[];
  final ProfileService _profileService = ProfileService();
  List<ProfessorSelectModel>? professorModels = <ProfessorSelectModel>[];
  List<String>? selectedProfessorID = <String>[];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: const Color(0Xff1163ba),
      appBar: AppBar(
        title: const Text(
          "Registracija",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),),
              SizedBox(height: size.height * 0.03),

              RoundedButton(
                text: "Odaberite predavača",
                press: () async {
                  if (professorModels!.isEmpty) {
                    professorModels = await getProfessorModels();
                  }
                  await showProfessorsList();
                },
              ),
              RoundedButton(
                text: "Dodajte kolegije",
                press: () async {
                  if (courseModels!.isEmpty) {
                     courseModels = await getCourseModels();
                  }
                  await showCoursesList();
                },
              ),
              RoundedButton(
                text: "Dodaj kolegije",
                press: () async {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                  selectedProfessorID?.forEach((professorID) {
                    selectedCoursesCodes?.forEach((courseCode) {
                      _profileService.assignCourse(professorID, courseCode);
                    });

                  });
                  Fluttertoast.showToast(
                    msg: 'Kolegiji dodjeljenji!', fontSize: 12, backgroundColor: Colors.grey,);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const AdminFrontPage(),
                    ),
                  );
                },
                color: Colors.lightGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future showProfessorsList() async {
    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title: const Text('Odabrite kolegije!'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: professorModels?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return ProfessorModelItem(
                                  professorModels![index].professor.name,
                                  '${professorModels![index].professor.birthDate
                                      .day}. ${professorModels![index].professor
                                      .birthDate
                                      .month}. ${professorModels![index]
                                      .professor.birthDate.year}.',
                                  professorModels![index].isSelected,
                                  index, setState
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Zatvori'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
       ),
    );
  }


    Widget ProfessorModelItem(String name, String birthDate, bool isSelected, int index, dynamic setState) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: const Icon(
            Icons.account_box,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
        subtitle: Text(birthDate),
        trailing: isSelected
            ? Icon(
          Icons.check_circle,
          color: Colors.green[700],
        )
            : const Icon(
          Icons.check_circle_outline,
          color: Colors.grey,
        ),
        onTap: () {
          setState(() {
            professorModels![index].isSelected = !professorModels![index].isSelected;
              if (professorModels![index].isSelected == true) {
                selectedProfessorID?.add(professorModels![index].professor.id);
              } else if (professorModels![index].isSelected == false) {
                selectedProfessorID?.removeWhere((element) => element == professorModels![index].professor.id);
              }
            }
          );
        },
      );
    }





  Future showCoursesList() async {

    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  title: const Text('Odabrite kolegije!'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.6,
                        width: MediaQuery.of(context).size.width*0.9,
                        child:  ListView.builder(
                            shrinkWrap: true,
                            itemCount: courseModels?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return CourseModelItem(
                                  courseModels![index].course.title,
                                  courseModels![index].course.code,
                                  courseModels![index].isSelected,
                                  index, setState
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Zatvori'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
        ),
    );
  }

  Widget CourseModelItem(String title, String code, bool isSelected,
      int index, dynamic setState) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[700],
        child: const Icon(
          Icons.school,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
      subtitle: Text(code),
      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: Colors.green[700],
      )
          : const Icon(
        Icons.check_circle_outline,
        color: Colors.grey,
      ),
      onTap: () {
        setState(() {
          courseModels![index].isSelected = !courseModels![index].isSelected;
          if (courseModels![index].isSelected == true) {
            selectedCoursesCodes?.add(courseModels![index].course.code);
          } else if (courseModels![index].isSelected == false) {
            selectedCoursesCodes
                ?.removeWhere((element) => element == courseModels![index].course.code);
          }
        }
        );
      },
    );
  }
}