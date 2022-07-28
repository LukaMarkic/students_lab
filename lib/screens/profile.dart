
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:students_lab/screens/gradeScreen.dart';
import 'package:students_lab/screens/quiz/FormSteps/quizFormSteps.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/services/notificationService.dart';
import 'package:students_lab/shared/bottomBar.dart';
import 'package:students_lab/shared/sharedMethods.dart';
import 'package:students_lab/widgets/profilePhoto.dart';
import 'package:students_lab/widgets/roundedButton.dart';
import '../constants.dart';
import '../error.dart';
import '../loading.dart';
import '../models.dart';
import '../services/auth.dart';
import '../services/database/profileService.dart';
import '../widgets/squaredButton.dart';
import 'home.dart';
import 'package:timezone/data/latest.dart' as tz;


class ProfileScreen extends StatelessWidget {

  ProfileScreen({Key? key,
  });


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
          }
          else {
            if (snapshot.data == UserType.student){
              return StudentProfileScreen();
            }
            else if(snapshot.data == UserType.admin) {
              return AdminProfileScreen();
            }else{
              return ProfessorProfileScreen();
            }
          }
        }
    );
  }
}





class StudentProfileScreen extends StatefulWidget {


  StudentProfileScreen({Key? key,
  }) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {

  @override
  void initState(){
    super.initState();
    tz.initializeTimeZones();
  }


  @override
  void dispose() {
    NotificationService.onNotifications.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

      return FutureBuilder<ProfileStudent>(
          future: ProfileService().getProfileDataStudent(user!.uid),
          builder: (context, AsyncSnapshot<ProfileStudent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return Center(
                child: ErrorMessage(message: snapshot.error.toString()),
              );
            } else{
              ProfileStudent student = snapshot.data!;
              return FutureBuilder(
                  future: GradeService().getAverageEnrolledStudentsGrade(student.enrolledCoursesCodes),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingScreen();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: ErrorMessage(message: snapshot.error.toString()),
                      );
                    } else{
                      double? gradeEnrolledStudents = snapshot.data;
                      return Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(automaticallyImplyLeading: false,
                          title: Text('Korisnik'), backgroundColor: Colors.lightBlue,
                        ),
                        body: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [

                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: const BoxDecoration(
                                  color: primaryThemeColor,
                                ),
                                child: ProfilePhotoWidget(imageURL: student.imgURL, collectionName: 'studentUsers',),
                              ),

                              Container(
                                padding: EdgeInsets.only(top: 25, left: 20, bottom: 25, right: 10),
                                decoration: const BoxDecoration(
                                  color: Color(0Xfff5f9fa),
                                  border: Border(bottom: BorderSide(color: primaryDividerColor)),
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ProfileNameInfo(profileUser: student, email: user.email,),
                                        IntrinsicHeight(child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.today, color: Color(0Xff0286bf),
                                              size: 28,),
                                            const SizedBox(width: 10),
                                            Text('${student.birthDate.day}.${student.birthDate.month}.${student.birthDate.year}.',
                                              style: GoogleFonts.oswald(
                                                textStyle: const TextStyle(
                                                  fontSize: 18.0, color: Colors.black54,),
                                              ),
                                            ),
                                            const VerticalDivider(
                                              color: primaryDividerColor,
                                              width: 20,
                                              thickness: 1.5,
                                            ),
                                            const Icon(
                                              Icons.school, color: Color(0Xff0286bf),
                                              size: 28,),
                                            const SizedBox(width: 10),
                                            Text('${student.godinaStudija}. g. stud.',
                                              style: GoogleFonts.oswald(
                                                textStyle: const TextStyle(
                                                  fontSize: 18.0, color: Colors.black54,),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20,),
                              Card(
                                color: Colors.white.withOpacity(0.9),
                                clipBehavior: Clip.antiAlias,
                                elevation: 4,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                                  child:
                                  Column(
                                    children: [
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      CircularPercentIndicator(
                                        footer: Text('Vaša uspješnost', style: TextStyle(color: Colors.black),),
                                        radius: 60.0,
                                        lineWidth: 8.0,
                                        percent: student.collectiveGrade ?? 0,
                                        center: new Text('${roundToSecondDecimal((student.collectiveGrade ?? 0) * 100)} %', style: TextStyle(color: Colors.black),),
                                        progressColor: getResultColor(student.collectiveGrade ?? 0),
                                      ),
                                      CircularPercentIndicator(
                                        footer: Text('Prosječni uspjeh', style: TextStyle(color: Colors.black),),
                                        radius: 60.0,
                                        lineWidth: 8.0,
                                        percent: gradeEnrolledStudents ?? 0,
                                        center: new Text('${roundToSecondDecimal((gradeEnrolledStudents ?? 0) * 100)} %', style: TextStyle(color: Colors.black),),
                                        progressColor: getResultColor(gradeEnrolledStudents ?? 0),
                                      ),
                                    ],
                                    ),
                                    SquaredButton(text: 'Pregled ocjena i statistike', color: primaryThemeColor.withOpacity(0.8), press: () {

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => FutureGradeStatisticBuild(courseCodes: student.enrolledCoursesCodes)   ),
                                      );

                                    }, paddingVertical: 10,),

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 50,),


                              SquaredButton(textColor: Colors.black, text: 'Odjavi se', color: primaryThemeColor.withOpacity(0.8), press: () {
                                signOut(context);
                               },),
                              SizedBox(height: 10,),


                            ],
                          ),
                        ),

                        bottomNavigationBar: BottomWidget(context, 0, 'studentUsers', user.uid),
                      );
                    }
                  }
              );
            }
          }
    );
  }

}






class ProfessorProfileScreen extends StatefulWidget {


  const ProfessorProfileScreen({Key? key,
  }) : super(key: key);

  @override
  State<ProfessorProfileScreen> createState() => _ProfessorProfileScreenState();
}

class _ProfessorProfileScreenState extends State<ProfessorProfileScreen> {

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    return FutureBuilder<ProfileProfessor>(
        future: ProfileService().getProfileProfessorData(user!.uid),
        builder: (context, AsyncSnapshot<ProfileProfessor> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else{
            var profileUser = snapshot.data!;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(automaticallyImplyLeading: false,
                title: Text('Profesor'), backgroundColor: Colors.lightBlue,
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: primaryThemeColor,
                      ),
                      child: ProfilePhotoWidget(imageURL: profileUser.imgURL, collectionName: 'professorUsers',),

                    ),

                    Container(
                      padding: EdgeInsets.only(top: 25, left: 20, bottom: 25, right: 10),
                      decoration: const BoxDecoration(
                        color: Color(0Xfff5f9fa),
                        border: Border(bottom: BorderSide(color: primaryDividerColor)),
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileNameInfo(profileUser: profileUser, email: user.email),
                              IntrinsicHeight(child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.today, color: Color(0Xff0286bf),
                                    size: 28,),
                                  const SizedBox(width: 10),
                                  Text('${profileUser.birthDate.day}.${profileUser.birthDate.month}.${profileUser.birthDate.year}.',
                                    style: GoogleFonts.oswald(
                                      textStyle: const TextStyle(
                                        fontSize: 18.0, color: Colors.black54,),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: primaryDividerColor,
                                    width: 20,
                                    thickness: 1.5,
                                  ),

                                ],
                              ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 85,),

                    RoundedButton(text: 'Odjavi se', press: (){
                      AuthService().signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }, color: Color(0Xff90f09b),),

                  ],
                ),
              ),

              bottomNavigationBar: BottomWidget(context, 0, 'professorUsers', user.uid),
            );
          }
        }
    );
  }

}



class AdminProfileScreen extends StatefulWidget {


  AdminProfileScreen({Key? key,
  }) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    return FutureBuilder<ProfileAdmin>(
        future: ProfileService().getProfileAdminData(user!.uid),
        builder: (context, AsyncSnapshot<ProfileAdmin> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else{
            var profileUser = snapshot.data!;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(automaticallyImplyLeading: false,
                title: Text('Profesor'), backgroundColor: Colors.lightBlue,
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: primaryThemeColor,
                      ),
                      child: ProfilePhotoWidget(imageURL: profileUser.imgURL, collectionName: 'adminUsers',),

                    ),

                    Container(
                      padding: EdgeInsets.only(top: 25, left: 20, bottom: 25, right: 10),
                      decoration: const BoxDecoration(
                        color: Color(0Xfff5f9fa),
                        border: Border(bottom: BorderSide(color: primaryDividerColor)),
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.account_circle_outlined,
                                      color: Colors.blueAccent, size: 30.0),
                                  const SizedBox(width: 10),
                                  Text("${profileUser.name} ${profileUser
                                      .surname}",
                                    style: GoogleFonts.oswald(
                                      textStyle: const TextStyle(
                                        fontSize: 24.0, color: Colors.black,),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.email, color: Colors.indigo.shade900,
                                    size: 30,),
                                  const SizedBox(width: 10),
                                  Text(user.email ?? '',
                                    style: GoogleFonts.oswald(
                                      textStyle: const TextStyle(
                                        fontSize: 22.0, color: Colors.black54,),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: primaryDividerColor,
                                thickness: 2,
                              ),
                              IntrinsicHeight(child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.today, color: Color(0Xff0286bf),
                                    size: 28,),
                                  const SizedBox(width: 10),
                                  Text('${profileUser.birthDate.day}.${profileUser.birthDate.month}.${profileUser.birthDate.year}.',
                                    style: GoogleFonts.oswald(
                                      textStyle: const TextStyle(
                                        fontSize: 18.0, color: Colors.black54,),
                                    ),
                                  ),


                                ],
                              ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                    RoundedButton(text: 'Odjavi se', press: (){
                      AuthService().signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }, color: Color(0Xff90f09b),),

                  ],
                ),
              ),

            );
          }
        }
    );
  }

}




class ProfileNameInfo extends StatelessWidget{

  ProfileUser profileUser;
  String? email;

  ProfileNameInfo({
    required this.profileUser,
    required this.email,
});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle_outlined,
                color: Colors.blueAccent, size: 30.0),
            const SizedBox(width: 10),
            Text("${profileUser.name} ${profileUser.surname}",
              style: GoogleFonts.oswald(
                textStyle: const TextStyle(
                  fontSize: 24.0, color: Colors.black,),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.email, color: Colors.indigo.shade900,
              size: 30,),
            const SizedBox(width: 10),
            Text(email ?? '',
              style: GoogleFonts.oswald(
                textStyle: const TextStyle(
                  fontSize: 20.0, color: Colors.black54,),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const Divider(
          color: primaryDividerColor,
          thickness: 2,
        ),
      ],
    );
  }




}