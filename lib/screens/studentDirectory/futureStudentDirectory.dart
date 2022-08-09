

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/screens/studentDirectory/studentDirectory.dart';
import 'package:students_lab/services/database/courseService.dart';

import '../../constants.dart';
import '../../models.dart';
import '../../shared/methods/groupingMethods.dart';
import '../../shared/methods/navigationMethods.dart';
import '../../shared/methods/ungroupedSharedMethods.dart';
import '../../theme.dart';
import '../../widgets/widgetsOfContentEditing/sortWidget.dart';
import '../../widgets/containers/dividerWidget.dart';
import '../../widgets/containers/roundedContainer.dart';
import '../../widgets/widgetsOfContentEditing/searchWidget.dart';
import '../../widgets/widgetsOfContentEditing/selectGroupingWidget.dart';

class FutureStudentDirectory extends StatefulWidget{

  ProfileProfessor professor;
  List<ProfileStudent> students;
  bool isSearchShown;
  bool isSortShown;
  bool isGroupedActive;
  FutureStudentDirectory({required this.professor, required this.students, this.isSearchShown = false,
    this.isSortShown = false, this.isGroupedActive = false
  });

  @override
  State<FutureStudentDirectory> createState() => _FutureStudentDirectoryState();
}

class _FutureStudentDirectoryState extends State<FutureStudentDirectory> {


  String query = '';
  String sortParameter = 'prezimenu';
  String groupParameter = 'Pregled studenta prema godini studija';
  List<String> groupParameters = const <String>[ 'Pregled studenta prema godini studija', 'Pregled studenta prema kolegiju',];
  bool isAscending = true;
  late List<DirectoryGroupedModel> directoryGroupedModels = <DirectoryGroupedModel>[];
  late List<DirectoryGroupedModel> allDir;
  late List<ProfileStudent> students = [];
  late List<Course> allAssignedCourses;


  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final allAssignedCourses = <Course>[];
    for(var courseCode in widget.professor.assignedCoursesCodes ?? []){
      final course = await CourseService().getCourseData(courseCode);
      allAssignedCourses.add(course);
    }
    setState(() {
      this.students = widget.students;
      this.allDir = groupStudentsByYear(widget.students);
      if(allDir.isNotEmpty) allDir[0].isExtended = true;
      this.directoryGroupedModels = allDir;});
      this.allAssignedCourses = allAssignedCourses;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: calendarTheme,
      child: Builder(builder: (context) {
        return Column(
          children: [
           widget.isGroupedActive ? SelectGroupingParameter(groupParameter: groupParameter, changeGrouping: changeGrouping, groupParameters: groupParameters) : Container(),
            widget.isSearchShown ? buildSearch() : Container(),
            widget.isSortShown ? buildSort() : Container(),
            widget.isGroupedActive ? grouped() : notGrouped(),
          ],);}),
    );
  }


  //Grouped

  Widget grouped(){

    return Expanded(child:
    Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: directoryGroupedModels.length,
          itemBuilder: (_, indexOne) {
            return
              ExpansionPanelList(
                animationDuration: Duration(milliseconds: 800),
                children: [
                  ExpansionPanel(
                    backgroundColor: Colors.white,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title:
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${directoryGroupedModels[indexOne].groupingByElement}', style: TextStyle(color: Colors.black87, fontSize: 18,
                                    fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                                DividerWrapper(padding: EdgeInsets.only(top: 5),),
                              ],
                            ),
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      color: Colors.white,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: directoryGroupedModels[indexOne].students.length,
                          itemBuilder: (_, indexTwo) {
                            return Card(
                              elevation: 5,
                              color: directoryListColor,
                              child: ListTile(
                                dense: true,
                                leading: Icon(Icons.account_box_outlined, size: 34,),
                                title: Text('${directoryGroupedModels[indexOne].students[indexTwo].name} ${directoryGroupedModels[indexOne].students[indexTwo].surname}', style:TextStyle(color: Colors.black87, fontSize: 16),),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${directoryGroupedModels[indexOne].students[indexTwo].birthDate.day}.${directoryGroupedModels[indexOne].students[indexTwo].birthDate.month}.${directoryGroupedModels[indexOne].students[indexTwo].birthDate.year}. ',
                                      style: TextStyle(color: Colors.black54, fontSize: 12),),
                                    Text(' ${directoryGroupedModels[indexOne].students[indexTwo].godinaStudija}. god. stud.',
                                      style: TextStyle(color: Colors.black54, fontSize: 12),),
                                  ],),
                                onTap: (){
                                  goToPage(context: context, page: FutureStudentDirectoryPage(student: directoryGroupedModels[indexOne].students[indexTwo], professorCourseCodes: widget.professor.assignedCoursesCodes ?? []));
                                },
                              ), );
                          }),),
                    isExpanded: directoryGroupedModels[indexOne].isExtended,
                    canTapOnHeader: true,
                  ),
                ],
                dividerColor: Colors.black,
                expansionCallback: (panelIndex, isExpanded) {
                  directoryGroupedModels[indexOne].isExtended = !directoryGroupedModels[indexOne].isExtended;
                  setState(() {
                  });
                },
              );
          }
      ),
    )
    );
  }



  changeGrouping(value) {
    setState((){
      groupParameter = value!;
    });
    if(groupParameter == groupParameters[1]){
      final allDir = groupStudentsByCourses(widget.students, allAssignedCourses, );
        setState(() async {
          this.allDir = allDir;
          this.directoryGroupedModels = allDir;
        });
    }else{
      setState(() {
        this.allDir = groupStudentsByYear(widget.students);
        this.directoryGroupedModels = allDir;});
    }
  }
  
  
  void searchGroupedStudent(String query) {
    var groups = <DirectoryGroupedModel>[];
    for(int i = 0; i != allDir.length; i++){
      var students = allDir[i].students.where((student) {
        final titleLower = student.name.toLowerCase();
        final codeLower = student.surname.toLowerCase();
        final godStud = student.godinaStudija.toString();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            codeLower.contains(searchLower) || godStud.contains(searchLower);
      }).toList();
      groups.add(DirectoryGroupedModel(groupingByElement: allDir[i].groupingByElement, students: students, isExtended: allDir[i].isExtended));
    }

    setState(() {
      this.query = query;
      directoryGroupedModels = groups;
    });

  }


  void sortGroupedStudents(String parameter, bool isAscending) {

    for(var directoryModel in directoryGroupedModels){

      var students = directoryModel.students;
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
        int index = directoryGroupedModels.indexOf(directoryModel);
        directoryGroupedModels[index].students = students;
      });
    }
  }







  //Not grouped

  Widget notGrouped(){

    return Expanded(
        child:
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (_, index) {
                return
                  Card(
                    color: directoryListColor,
                    child: ListTile(
                      leading: Icon(Icons.account_box_outlined, size: 34,),
                      title: Text('${students[index].name} ${students[index].surname}', style:TextStyle(color: Colors.black87, fontSize: 16),),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${students[index].birthDate.day}.${students[index].birthDate.month}.${students[index].birthDate.year}. ',
                              style: TextStyle(color: Colors.black54, fontSize: 12),),
                            Text(' ${students[index].godinaStudija}. god. stud.',
                              style: TextStyle(color: Colors.black54, fontSize: 12),),
                          ],
                        ),
                        onTap: (){
                        goToPage(context: context, page: FutureStudentDirectoryPage(student: students[index], professorCourseCodes: widget.professor.assignedCoursesCodes ?? []));
                      },
                    ),
                  );
              }
          ),
        )
    );
  }


  void searchStudent(String query) {
    final students = widget.students.where((student) {
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
  

  //



  Widget buildSearch(){
    return SearchWidget( text: query, hintText: 'Pretražite studente', onChanged: (String value) => widget.isGroupedActive ? searchGroupedStudent(value) : searchStudent(value));
  }


  Widget buildSort(){
    return SortWidget(parameter: sortParameter,  list: <String>['imenu', 'prezimenu', 'godini studija' , 'datumu rođenja'], onChanged: (sortingParameter) {
      setState((){
        sortParameter = sortingParameter;
      });
      widget.isGroupedActive ? sortGroupedStudents(sortingParameter, isAscending) : sortStudents(sortParameter, isAscending);
    }, child: ascendingButton(),
    );
  }

  Widget ascendingButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),child: isAscending ? Icon(Icons.arrow_downward, color: Colors.black87,) : Icon(Icons.arrow_upward, color: Colors.black87,), onPressed: (){
      setState((){
        isAscending = !isAscending;
      });
      widget.isGroupedActive ? sortGroupedStudents(sortParameter, isAscending) : sortStudents(sortParameter, isAscending);
    },
    );
  }

}