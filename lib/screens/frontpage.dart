import 'dart:async';
import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/screens/drawers/profileDrawer.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/services/notificationService.dart';
import 'package:students_lab/shared/sharedMethods.dart';
import 'package:students_lab/widgets/SortWidget.dart';
import 'package:students_lab/widgets/cancelSortIcon.dart';
import '../error.dart';
import '../loading.dart';
import '../models.dart';
import '../services/database/courseService.dart';
import '../shared/bottomBar.dart';
import '../widgets/searchWidget.dart';
import 'administrator/adminFrontPage.dart';
import 'course/courseItem.dart';

class FrontPage extends StatelessWidget {

  FrontPage({Key? key,});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserType(AuthService().user?.uid.toString()),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          } else {
            if (snapshot.data == UserType.student){
              return StudentFrontPage();
            }
            else if(snapshot.data == UserType.admin) {
              return AdminFrontPage();
            }else{
              return FutureProfessor();
            }
          }
        }
        );
  }
}




class StudentFrontPage extends StatefulWidget {

  StudentFrontPage({Key? key,
  }) : super(key: key);

  @override
  State<StudentFrontPage> createState() => _StudentFrontPageState();
}

class _StudentFrontPageState extends State<StudentFrontPage> with SingleTickerProviderStateMixin {

  late TabController _controller;
  String? fullName;
  bool isSearchShown = false;
  bool isSortShown = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    init();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      NotificationService.display(event);
    });
  }

  Future init() async {
    final fullName = await ProfileService().getUserFullName('studentUsers', AuthService().user!.uid);
    this.fullName = fullName;
    var token = await NotificationService().getNotificationToken();
    ProfileService().setUserToken('studentUsers', AuthService().user!.uid, token);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryThemeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Početna"),
        actions: [
          IconButton(icon: !isSearchShown ? Icon(Icons.search_rounded) : Icon(Icons.search_off), onPressed: (){
            setState(() {
              isSearchShown = !isSearchShown;
            });

          },
          tooltip: 'Pretraži',),
          IconButton(icon: !isSortShown ? Icon(Icons.sort) : CancleSortIcon(), onPressed: (){
            setState(() {
              isSortShown = !isSortShown;
            });
          },
          tooltip: 'Poredaj',),
        ],
        backgroundColor: Colors.lightBlueAccent,
        bottom: TabBar(
          unselectedLabelColor: Colors.white60,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: [
            Tab(
              text: "Moji kolegiji",
            ),
            Tab(
              text: "Svi kolegiji",
            ),
          ],
        ),

      ),
      drawer: ProfileDrawer(fullName: fullName ?? '',),
      body: TabBarView(
          controller: _controller,
          children: [
            FutureCourses(futureValue: CourseService().getEnrolledCourses(), isSearchShown: isSearchShown, isSortShown: isSortShown,),
            FutureCourses(futureValue: CourseService().getCourses(), isSearchShown: isSearchShown, isSortShown: isSortShown,),

          ]
      ),

      bottomNavigationBar: BottomWidget(context, 1, 'studentUsers', AuthService().user!.uid),
    );
  }

}





class ProfessorFrontPage extends StatefulWidget {

  ProfileProfessor professor;
  List<ProfileStudent> allStudents;
  ProfessorFrontPage({Key? key,
    required this.professor,
    this.allStudents = const <ProfileStudent>[],
  }) : super(key: key);

  @override
  State<ProfessorFrontPage> createState() => _ProfessorFrontPageState();
}

class _ProfessorFrontPageState extends State<ProfessorFrontPage> with SingleTickerProviderStateMixin {

  late TabController _controller;
  bool isSearchShown = false;
  bool isSortShown = false;


  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    FirebaseMessaging.instance.getInitialMessage();
    init();
  }

  Future init() async {
    var token = await NotificationService().getNotificationToken();
    ProfileService().setUserToken('professorUsers', AuthService().user!.uid, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryThemeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Naslovna"),
        actions: [
          IconButton(icon: !isSearchShown ? Icon(Icons.search_rounded) : Icon(Icons.search_off), onPressed: (){
            setState(() {
              isSearchShown = !isSearchShown;
            });

          },
            tooltip: 'Pretraži',),
          IconButton(icon: !isSortShown ? Icon(Icons.sort) : CancleSortIcon(), onPressed: (){
            setState(() {
              isSortShown = !isSortShown;
            });
          },
            tooltip: 'Poredaj',),
        ],
        backgroundColor: Colors.lightBlueAccent,
        bottom: TabBar(
          unselectedLabelColor: Colors.white60,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: [
            Tab(
              text: "Vaši kolegiji",
            ),
            Tab(
              text: "Imenik",
            ),

          ],
        ),

      ),

      body: TabBarView(
          controller: _controller,
          children: [
            FutureCourses(futureValue: CourseService().getAssignedCourses(), isSearchShown: isSearchShown, isSortShown: isSortShown,),
            FutureStudentDirectory(professor: widget.professor, allStudents: widget.allStudents, isSearchShown: this.isSearchShown, isSortShown: this.isSortShown,),
    ]
      ),

      bottomNavigationBar: BottomWidget(context, 1, 'professorUsers', AuthService().user!.uid),
    );
  }

}




class FutureCourses extends StatefulWidget{

  Future<List<Course>> futureValue;
  bool isSearchShown;
  bool isSortShown;
  FutureCourses({required this.futureValue, this.isSearchShown = false, this.isSortShown = false,});

  @override
  State<FutureCourses> createState() => _FutureCoursesState();
}

class _FutureCoursesState extends State<FutureCourses> {

  String query = '';
  late List<Course> courses = <Course>[];
  late List<Course> allCourses;
  Timer? debouncer;
  String sortParameter = 'šifri';
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final allCourses = await widget.futureValue;
    setState(() {this.allCourses = allCourses;
    this.courses = allCourses;});
    sortCourse(sortParameter, isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              widget.isSearchShown ? buildSearch() : Container(),
              widget.isSortShown ? buildSort() : Container(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.85,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: courses.length, itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseItem(course: course);
                },),
              )
            ],
          );
        }


  void searchCourse(String query) {
    final courses = allCourses.where((course) {
      final titleLower = course.title.toLowerCase();
      final codeLower = course.code.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          codeLower.contains(searchLower);
    }).toList();


    setState(() {
      this.query = query;
      this.courses = courses;
    });
  }


  void sortCourse(String parameter, bool isAscending) {
    final courses = this.courses;
    switch (parameter) {
    case 'šifri':
      isAscending ? courses.sort((a, b) => a.code.compareTo(b.code)) : courses.sort((b, a) => a.code.compareTo(b.code));
    break;
    case 'nazivu':
      isAscending ? courses.sort((a, b) => a.title.compareTo(b.title)) : courses.sort((b, a) => a.title.compareTo(b.title));
      break;
    case 'broju bodova':
      isAscending ? courses.sort((a, b) => a.ECTS.compareTo(b.ECTS)) : courses.sort((b, a) => a.ECTS.compareTo(b.ECTS));
      break;
    case 'semestru':
      isAscending ? courses.sort((a, b) => a.semester.compareTo(b.semester)) : courses.sort((b, a) => a.semester.compareTo(b.semester));
      break;
    }

    setState(() {
      this.courses = courses;
    });
  }

  void sortAscending(){
    final courses = this.courses;
    courses.sort((a, b) => a.semester.compareTo(b.semester));
  }


  Widget buildSearch(){
    return SearchWidget( text: query, hintText: 'Pretražite kolegije', onChanged: (String value)  => searchCourse(value),
    );
  }

  Widget buildSort(){
    return SortWidget(parameter: sortParameter,  list: <String>['šifri', 'nazivu', 'broju bodova', 'semestru'], onChanged: (sortingParameter) {
      setState((){
        sortParameter = sortingParameter;
      });
      sortCourse(sortingParameter, isAscending);
    }, child: Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: isAscending ? Icon(Icons.arrow_downward, color: Colors.black87,) : Icon(Icons.arrow_upward, color: Colors.black87,), onPressed: (){
        setState((){
          isAscending = !isAscending;
        });
        sortCourse(sortParameter, isAscending);
      },

      ),
    ),
    );
  }

}



class FutureProfessor extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ProfileService().getProfileProfessorData(AuthService().user!.uid),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          }
          else {
            if(snapshot.data == null){
              return CircularProgressIndicator();
            }
            else{
              ProfileProfessor professor = snapshot.data;
              return FutureBuilder(
                  future: CourseService().getAllStudentEnrolledInCourses(professor.assignedCoursesCodes),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingScreen();
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: ErrorMessage(),
                      );
                    }
                    else {
                       List<ProfileStudent> allStudents = snapshot.data;

                        return ProfessorFrontPage(professor: professor, allStudents: allStudents,); }
                    }
              );
            }
          }
        }
    );
  }
}




class FutureStudentDirectory extends StatefulWidget{

  ProfileProfessor professor;
  List<ProfileStudent> allStudents;
  bool isSearchShown;
  bool isSortShown;
 FutureStudentDirectory({required this.professor, required this.allStudents, this.isSearchShown = false,
   this.isSortShown = false,});

  @override
  State<FutureStudentDirectory> createState() => _FutureStudentDirectoryState();
}

class _FutureStudentDirectoryState extends State<FutureStudentDirectory> {


  String query = '';
  late List<ProfileStudent> students = <ProfileStudent>[];
  Timer? debouncer;
  String sortParameter = 'imenu';
  bool isAscending = true;



  @override
  void initState() {
    super.initState();
    init();
  }


  Future init() async {
      setState(() {
      this.students = widget.allStudents;});
      sortStudents(sortParameter, isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isSearchShown ? buildSearch() : Container(),
        widget.isSortShown ? buildSort() : Container(),
        Expanded(child:
          GroupedListView<dynamic, String>(
            elements: getStudentsJsons(students),
            groupBy: (element) => element['godinaStudija'],
            itemBuilder: (context, element) => Card(
              child: Card(
                ),
            ),
          ),
          /*Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: students.length ?? 0,
              itemBuilder: (_, index) {
                return
                  Card(
                    color: Colors.white,
                    child: ListTile(title: Text('${students[index].name} ${students[index].surname}', style:TextStyle(color: Colors.black87, fontSize: 16),),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${students[index].birthDate.day}.${students[index].birthDate.month}.${students[index].birthDate.year}. ',
                              style: TextStyle(color: Colors.black54, fontSize: 12),),
                            Text(' ${students[index].godinaStudija}. god. stud.',
                              style: TextStyle(color: Colors.black54, fontSize: 12),),
                          ],)
                    ),);
              }
          ),
        )*/
        ),
      ],
    );
  }

 List<dynamic> getStudentsJsons(List<ProfileStudent> students){
    final jsons = <Map<String, dynamic>>[];
    for(var student in students){
      jsons.add(student.toJson());
    }
    return jsons;
  }


  void searchStudent(String query) {
    final students = widget.allStudents.where((student) {
      final titleLower = student.name.toLowerCase();
      final codeLower = student.surname.toLowerCase();
      final godStud = student.godinaStudija.toString();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          codeLower.contains(searchLower) || godStud.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.students = students;
    });
  }


  void sortStudents(String parameter, bool isAscending) {
    final students = this.students;
    switch (parameter) {
      case 'imenu':
        isAscending ? students.sort((a, b) => a.name.compareTo(b.name)) : students.sort((b, a) => a.name.compareTo(b.name));
        break;
      case 'prezimenu':
        isAscending ? students.sort((a, b) => a.surname.compareTo(b.surname)) : students.sort((b, a) => a.surname.compareTo(b.surname));
        break;
      case 'godini studija':
        isAscending ? students.sort((a, b) => a.godinaStudija.compareTo(b.godinaStudija)) : students.sort((b, a) => a.godinaStudija.compareTo(b.godinaStudija));
        break;
      case 'datumu rođenja':
        isAscending ? students.sort((a, b) => a.birthDate.compareTo(b.birthDate)) : students.sort((b, a) => a.birthDate.compareTo(b.birthDate));
        break;
    }

    setState(() {
      this.students = students;
    });
  }


  Widget buildSearch(){
    return SearchWidget( text: query, hintText: 'Pretražite studente', onChanged: (String value)  => searchStudent(value),
    );
  }

  Widget buildSort(){
    return SortWidget(parameter: sortParameter,  list: <String>['imenu', 'prezimenu', 'godini studija' , 'datumu rođenja'], onChanged: (sortingParameter) {
      setState((){

        sortParameter = sortingParameter;
      });
      sortStudents(sortingParameter, isAscending);
    }, child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),child: isAscending ? Icon(Icons.arrow_downward, color: Colors.black87,) : Icon(Icons.arrow_upward, color: Colors.black87,), onPressed: (){
      setState((){
        isAscending = !isAscending;
      });

      sortStudents(sortParameter, isAscending);

    }, ),
    );
  }


}





