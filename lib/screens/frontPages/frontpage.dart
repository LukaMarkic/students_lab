import 'dart:async';
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/screens/frontPages/profesorFrontPage.dart';
import 'package:students_lab/screens/frontPages/studentFrontPage.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/profileService.dart';
import '../../error.dart';
import '../../loading.dart';
import '../../models.dart';
import '../../services/database/courseService.dart';
import '../../shared/methods/profileUserMethods.dart';
import '../administrator/adminFrontPage.dart';


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
              return FutureStudent();
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
                       return FutureBuilder(
                           future: CourseService().getAssignedCourses(),
                           builder: (context, AsyncSnapshot snapshot) {
                             if (snapshot.connectionState == ConnectionState.waiting) {
                               return const LoadingScreen();
                             } else if (snapshot.hasError) {
                               return const Center(
                                 child: ErrorMessage(),
                               );
                             }
                             else {
                               List<Course> assignedCourses = snapshot.data;
                               return ProfessorFrontPage(professor: professor, allStudents: allStudents, assignedCourses: assignedCourses,); }
                           }
                       );
                      }
                  }
              );
            }
          }
        }
    );
  }
}






class FutureStudent extends StatefulWidget{

  FutureStudent();

  @override
  State<FutureStudent> createState() => _FutureStudentState();
}

class _FutureStudentState extends State<FutureStudent> {

  late List<Course> allCourses = [];

  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final allCourses = await CourseService().getCourses();
    setState(() {
      this.allCourses = allCourses;
      });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: CourseService().getEnrolledCourses(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return const Center(
                child: ErrorMessage(),
              );
            }
            else {
              List<Course> enrolledCourses = snapshot.data;
              return StudentFrontPage(allCourses: allCourses, enrolledCourses: enrolledCourses,);
            }
          }
      );
  }
}






