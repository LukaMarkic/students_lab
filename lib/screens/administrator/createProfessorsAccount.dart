
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/services/notificationService.dart';
import 'package:students_lab/widgets/roundedDate.dart';
import '../../services/auth.dart';
import '../../services/database/courseService.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/roundedInput.dart';
import '../../widgets/roundedPassword.dart';
import 'package:intl/intl.dart';




class ProfessorSignupForm extends StatefulWidget {
  const  ProfessorSignupForm({ Key? key }) : super(key: key);
  @override
  _ProfessorSignupForm createState() => _ProfessorSignupForm();
}

class _ProfessorSignupForm extends State< ProfessorSignupForm> with SingleTickerProviderStateMixin {
  String name = '';
  String surname = '';
  String email = '';
  String password = '';
  String? imgURL;
  DateTime defaultTime = DateTime.utc(2000, 1, 1);
  late DateTime selectedDate = defaultTime;
  final DateFormat formatter = DateFormat('dd.MM.yyyy.');
  List<String>? selectedCoursesCodes = <String>[];
  List<CourseSelectModel>? courseModels = <CourseSelectModel>[];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Color(0Xff1163ba),
      appBar: AppBar(
        title: Text(
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
              RoundedInputField(
                hintText: "Unesite ime predavača",
                icon: Icons.account_box_outlined,
                onChanged: (value) {
                  setState(
                          () => name = value
                  );
                },
              ),
              RoundedInputField(
                hintText: "Unesite prezime predavača",
                icon: Icons.account_box_rounded,
                onChanged: (value) {
                  setState(
                          () => surname = value
                  );
                },
              ),
              RoundedDateField(
                press: () {
                  showDatePicker(
                    context: context,
                    initialDate: defaultTime,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((date) {
                    setState(() {
                      selectedDate = date!;
                    });
                  });
                },
                selectedDate: selectedDate != defaultTime
                    ? formatter.format(selectedDate.toLocal()).toString().split(
                    ' ')[0]
                    : 'Unesite datum rođenja',
              ),


              RoundedInputField(
                hintText: "Unesite email",
                onChanged: (value) {
                  setState(
                          () => email = value
                  );
                },
              ),
              RoundedHiddenField(
                hintText: "Unesite zaporku",
                onChanged: (value) {
                  setState(
                          () => password = value
                  );
                },
              ),

              RoundedButton(
                text: "Dodajte kolegije",
                press: () async {

                  if(courseModels!.isEmpty) {
                    courseModels = await getCourseModels();
                  }
                  await showCoursesList();

                },
              ),


              RoundedButton(
                text: "Stvori račun predavača",
                press: () async {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  var token = await NotificationService().getNotificationToken();
                  ProfileProfessor professor = ProfileProfessor(
                    name: name.trim(),
                    surname: surname.trim(),
                    birthDate: selectedDate,
                    assignedCoursesCodes: selectedCoursesCodes,
                    token: token,
                  );
                  await AuthService().SignUpWithEmailPassword(
                      professor, 'professorUsers', email.trim(),
                      password.trim()).then((value) => {if(value == null) Fluttertoast.showToast(
                      msg: 'Email adresa je već iskorištena, pokušajete ponovno!', fontSize: 12, backgroundColor: Colors.grey,)});
                  },
                color: Colors.lightGreen,
              ),

            ],
          ),
        ),
      ),


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
                  Container(
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
          );}),
    );
  }

  Widget CourseModelItem(String title, String code, bool isSelected,
      int index, dynamic setState) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[700],
        child: Icon(
          Icons.school,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
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
          : Icon(
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



Future<List<CourseSelectModel>> getCourseModels() async {

  List<CourseSelectModel> courseModels = <CourseSelectModel>[];
  List<Course> courses = await CourseService().getCourses();
  courses.forEach((course) {courseModels.add(CourseSelectModel(course: course, isSelected: false)); });

  return courseModels;

}



class CourseSelectModel{

  late Course course;
  bool isSelected;


  CourseSelectModel(
      {
        required this.course,
        this.isSelected = false,
      }
      );
}



Future<List<ProfessorSelectModel>> getProfessorModels() async {

  List<ProfessorSelectModel> professorModels = <ProfessorSelectModel>[];
  List<ProfileProfessor> professors = await ProfileService().getProfileProfessors();
  professors.forEach((professor) {professorModels.add(ProfessorSelectModel(professor: professor, isSelected: false)); });

  return professorModels;

}

class ProfessorSelectModel{

  late ProfileProfessor professor;
  bool isSelected;

ProfessorSelectModel(
    {
      required this.professor,
      this.isSelected = false,
    }
    );
}




