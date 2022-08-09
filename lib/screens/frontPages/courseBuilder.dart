

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/widgets/containers/dividerWidget.dart';

import '../../constants.dart';
import '../../models.dart';
import '../../shared/methods/groupingMethods.dart';
import '../../shared/methods/ungroupedSharedMethods.dart';
import '../../theme.dart';
import '../../widgets/widgetsOfContentEditing/sortWidget.dart';
import '../../widgets/widgetsOfContentEditing/cancelSortIcon.dart';
import '../../widgets/widgetsOfContentEditing/searchWidget.dart';
import '../../widgets/widgetsOfContentEditing/selectGroupingWidget.dart';
import '../course/courseItem.dart';

class CoursesBuilder extends StatefulWidget{

  List<Course> courses;
  bool isSearchShown;
  bool isSortShown;
  bool isGroupedActive;
  CoursesBuilder({this.courses = const [], this.isSearchShown = false, this.isSortShown = false, this.isGroupedActive = true});

  @override
  State<CoursesBuilder> createState() => _CoursesBuilderState();
}

class _CoursesBuilderState extends State<CoursesBuilder> {

  String query = '';
  late List<CourseGroupedModel> courseGroupedModels = <CourseGroupedModel>[];
  late List<Course> allCourses;
  late List<Course> courses = <Course>[];
  String groupParameter = 'Pregled kolegija po semestru';
  List<String> groupParameters = const <String>[ 'Pregled svih kolegija', 'Pregled kolegija po semestru',];
  String sortParameter = 'šifri';
  bool isAscending = true;
  final List<String> sortByList =  <String>['šifri', 'nazivu', 'broju bodova', 'semestru'];


  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {

    setState(() {
      this.allCourses = widget.courses;
      this.courses = allCourses;
      this.courseGroupedModels = groupCoursesBySemester(allCourses);});
    sortGroupedCourses(sortParameter, isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: calendarTheme,
      child: Builder(builder: (context) {
        return Column(
          children: [
            widget.isSearchShown ? buildSearch() : Container(),
            widget.isSortShown ? buildSort() : Container(),
            buildCourses(),
          ],
        );
      }
      ),
    );
  }


  Widget buildCourses(){
    return widget.isGroupedActive ? GroupedBySemester() : NotGrouped();
  }


/*Grouped*/

  Widget GroupedBySemester(){
    return  Expanded(child:
    Card(
      color: primaryThemeColor,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: courseGroupedModels.length,
          itemBuilder: (_, index) {
            return Container(
              child:
              ExpansionPanelList(
                animationDuration: Duration(milliseconds: 800),
                children: [
                  ExpansionPanel(
                    backgroundColor: primaryThemeColor,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${courseGroupedModels[index].groupingByElement}', style: TextStyle(color: Colors.black87, fontSize: 18,
                                fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                            DividerWrapper(padding: EdgeInsets.only(top: 5),),
                          ],
                        ),
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.only(top: 0, bottom: 32),
                      child: Expanded(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 2.0,
                            mainAxisSpacing: 2.0,
                            crossAxisSpacing: 10.0,
                          ),
                          itemCount: courseGroupedModels[index].courses.length,
                          itemBuilder: (context, index2) {
                            final course = courseGroupedModels[index].courses[index2];
                            return CourseItem(course: course);
                          },),
                      ),
                    ),
                    isExpanded: courseGroupedModels[index].isExtended,
                    canTapOnHeader: true,
                  ),

                ],
                dividerColor: Colors.black,
                expansionCallback: (panelIndex, isExpanded) {
                  courseGroupedModels[index].isExtended = !courseGroupedModels[index].isExtended;
                  setState(() {
                  });
                },

              ),
            );
          }
      ),
    ),
    );
  }

  void searchGroupedCourses(String query) {


    final courses = allCourses.where((course) {
      final titleLower = course.title.toLowerCase();
      final codeLower = course.code.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          codeLower.contains(searchLower);
    }).toList();


    setState(() {
      this.query = query;
      courseGroupedModels = groupCoursesBySemester(courses);
    });

  }


  void sortGroupedCourses(String parameter, bool isAscending) {

    for(var courseModel in courseGroupedModels){

      final courses = courseModel.courses;

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
        int index = courseGroupedModels.indexOf(courseModel);
        courseGroupedModels[index]..courses = courses;
      });
    }
  }

  //




  /*Not Gruped*/

  Widget NotGrouped(){
    return
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.0,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseItem(course: course);
          },),
      );
  }

  void searchCourses(String query) {
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


  void sortCourses(String parameter, bool isAscending) {
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

  //




  Widget buildSearch(){
    return widget.isGroupedActive ? SearchWidget( text: query, hintText: 'Pretražite kolegije', onChanged: (String value)  => searchGroupedCourses(value)) : SearchWidget( text: query, hintText: 'Pretražite kolegije', onChanged: (String value)  => searchCourses(value),);
  }

  Widget buildSort(){
    return SortWidget(parameter: sortParameter,  list: sortByList, onChanged: (sortingParameter) {
      setState((){
        sortParameter = sortingParameter;
      });
      widget.isGroupedActive ? sortGroupedCourses(sortingParameter, isAscending) : sortCourses(sortingParameter, isAscending);
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
        widget.isGroupedActive ? sortGroupedCourses(sortParameter, isAscending) : sortCourses(sortParameter, isAscending);
      },

      ),
    ),
    );
  }
}
