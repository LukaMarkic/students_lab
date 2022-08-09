
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:students_lab/screens/gradeScreen.dart';
import 'package:students_lab/screens/studentDirectory/studentDirectory.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/services/notificationService.dart';
import 'package:students_lab/shared/bottomBar.dart';
import 'package:students_lab/shared/methods/ungroupedSharedMethods.dart';
import 'package:students_lab/widgets/containers/dividerWidget.dart';
import 'package:students_lab/widgets/profilePhoto.dart';
import 'package:students_lab/widgets/buttons/roundedButton.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../error.dart';
import '../loading.dart';
import '../models.dart';
import '../services/auth.dart';
import '../services/database/courseService.dart';
import '../services/database/profileService.dart';
import '../shared/methods/activityMarkResponseMethods.dart';
import '../shared/methods/navigationMethods.dart';
import '../shared/methods/profileUserMethods.dart';
import '../theme.dart';
import '../widgets/widgetsOfContentEditing/cancelSortIcon.dart';
import '../widgets/buttons/squaredButton.dart';
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
              return FutureProfessorProfileScreen();
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
                      return StudentProfilePage(student: student, gradeEnrolledStudents: gradeEnrolledStudents,);
                    }
                  }
              );
            }
          }
    );
  }

}


class StudentProfilePage extends StatelessWidget{

  ProfileStudent student;
  double? gradeEnrolledStudents;
  StudentProfilePage({required this.student, this.gradeEnrolledStudents});
  var user = AuthService().user;

  @override
  Widget build(BuildContext context) {
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
              child: ProfilePhotoWidget(imageURL: student.imgURL, collectionName: studentCollection,),
            ),
            ProfileInfo(
              profile: student,
              child: Row(
                children: [
                  const VerticalDivider(
                    color: primaryDividerColor, width: 20, thickness: 1.5,
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
                    SquaredButton(text: 'Pregled ocjena i statistike', color: primaryThemeColor.withOpacity(0.8),
                      press: () {
                      goToPage(context: context, page: FutureGradeStatisticBuild(courseCodes: student.enrolledCoursesCodes),);
                    }, paddingVertical: 10,
                    textColor: Colors.black54,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
            SquaredButton(textColor: Colors.black, text: 'Odjavi se', color: primaryThemeColor.withOpacity(0.8), press: () {signOut(context);
            },),
            SizedBox(height: 10,),
          ],
        ),
      ),
      bottomNavigationBar: BottomWidget(context, 0, studentCollection, user!.uid),
    );
  }
}






class FutureProfessorProfileScreen extends StatefulWidget {

  const FutureProfessorProfileScreen({Key? key,}) : super(key: key);

  @override
  State<FutureProfessorProfileScreen> createState() => _FutureProfessorProfileScreenState();
}

class _FutureProfessorProfileScreenState extends State<FutureProfessorProfileScreen> {

  late List<ProfessorCourseAchievementModel> courseAchievementModels = <ProfessorCourseAchievementModel>[];



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
            return ProfessorProfileScreen(professor: profileUser,);
          }
        }
    );
  }
}



class ProfessorProfileScreen extends StatefulWidget{

  ProfileProfessor professor;
  ProfessorProfileScreen({required this.professor});

  @override
  State<ProfessorProfileScreen> createState() => _ProfessorProfileScreenState();
}

class _ProfessorProfileScreenState extends State<ProfessorProfileScreen> {

  late List<ProfessorCourseAchievementModel> courseAchievementModels = <ProfessorCourseAchievementModel>[];
  var user = AuthService().user;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final courseAchievementModels = <ProfessorCourseAchievementModel>[];
    for(var courseCode in widget.professor.assignedCoursesCodes ?? []){
      final courseAchievementModel = await getProfessorCourseAchievementModel(courseCode);
      courseAchievementModels.add(courseAchievementModel);
    }
    setState(() {
      this.courseAchievementModels = courseAchievementModels;
     });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(automaticallyImplyLeading: false,
        title: const Text('Profesor'), backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
                color: primaryThemeColor,
              ),
              child: ProfilePhotoWidget(imageURL: widget.professor.imgURL, collectionName: professorCollection,),
            ),
            ProfileInfo(profile: widget.professor,),
            const SizedBox(height: 20,),

            Card(
              color: profileColor,
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child:
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Text('Pregled uspjeha po kolegiju', style: TextStyle( fontSize: 17,
                          fontWeight: FontWeight.bold, color: Colors.black),),
                    ),
                    (courseAchievementModels.length == widget.professor.assignedCoursesCodes!.length) ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: courseAchievementModels.length,
                        itemBuilder: (_, index) {
                          return Card(
                            color: listColor,
                            margin: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: Text(courseAchievementModels[index].title, style: const TextStyle( fontSize: 16,
                                      fontWeight: FontWeight.bold, color: Colors.black87),),
                                ),
                                DividerWrapper(padding: EdgeInsets.only(bottom: 8, left: 8, right: 8)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircularPercentIndicator(
                                      footer:  ConstrainedBox(
                                        constraints: new BoxConstraints(
                                          maxWidth: 120,
                                        ),
                                        child: const Padding(padding: EdgeInsets.only(top: 4),
                                          child: Text('Prosječan uspjeh studenata',
                                            softWrap: true,
                                            style: TextStyle(fontSize: 14, color: Colors.black45), textAlign: TextAlign.center,),),
                                      ),
                                      radius: 60.0,
                                      lineWidth: 8.0,
                                      percent: courseAchievementModels[index].averageGrade,
                                      center: Text('${roundToSecondDecimal((courseAchievementModels[index].averageGrade) * 100)} %', style: TextStyle(color: Colors.black),),
                                      progressColor: getResultColor(courseAchievementModels[index].averageGrade),
                                    ),
                                    CircularPercentIndicator(
                                      footer:  ConstrainedBox(
                                        constraints: new BoxConstraints(
                                          maxWidth: 120.0,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4,),
                                          child: Column(
                                            children: [
                                              const Text('Najbolji uspjeh',
                                                softWrap: true,
                                                style: TextStyle(fontSize: 14, color: Colors.black45), textAlign: TextAlign.center,),
                                              courseAchievementModels[index].bestStudent != null ? InkWell(onTap: () {
                                                goToPage(context: context, page: FutureStudentDirectoryPage(
                                                  student: courseAchievementModels[index].bestStudent!,
                                                  professorCourseCodes: widget.professor.assignedCoursesCodes ?? [], ));
                                              },
                                                child: Text('(${courseAchievementModels[index].bestStudent!.name} ${courseAchievementModels[index].bestStudent!.surname})',
                                                  softWrap: true,
                                                  style: const TextStyle(fontSize: 13, color: Colors.black38), textAlign: TextAlign.center,),
                                              ) : const Text('Neodređeno', style: TextStyle(fontSize: 13, color: Colors.black12),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      radius: 60.0,
                                      lineWidth: 8.0,
                                      percent: courseAchievementModels[index].bestGrade,
                                      center: Text('${roundToSecondDecimal((courseAchievementModels[index].bestGrade) * 100)} %', style: TextStyle(color: Colors.black),),
                                      progressColor: getResultColor(courseAchievementModels[index].bestGrade),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                              ],
                            ),
                          );
                        }
                    ) : Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      height: 60,
                      width: 50,
                      child: const
                        CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            SquaredButton(textColor: Colors.black, text: 'Odjavi se', color: primaryThemeColor.withOpacity(0.8), press: () {signOut(context);
            },),
            const SizedBox(height: 30,),
          ],
        ),
      ),

      bottomNavigationBar: BottomWidget(context, 0, professorCollection, user!.uid),
    );
  }
}




class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key,
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
                title: Text('Admin'), backgroundColor: Colors.lightBlue,
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
                      child: ProfilePhotoWidget(imageURL: profileUser.imgURL, collectionName: adminCollection,),
                    ),
                    ProfileInfo(profile: profileUser,),
                    RoundedButton(text: 'Odjavi se', press: (){
                      signOut(context);
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



class ProfileInfo extends StatelessWidget {

  ProfileUser profile;
  Widget? child;
  ProfileInfo({Key? key, required this.profile, this.child}) : super(key: key);

  var user = AuthService().user;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 10, bottom: 15, right: 10),
      decoration: const BoxDecoration(
        color: profileColor,
        border: Border(bottom: BorderSide(color: primaryDividerColor)),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileNameInfo(profileUser: profile, email: user?.email,),
              const Divider(
                color: primaryDividerColor,
                thickness: 2,
              ),
              IntrinsicHeight(child:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.today, color: Color(0Xff0286bf),
                    size: 28,),
                  const SizedBox(width: 10),
                  Text('${profile.birthDate.day}.${profile.birthDate.month}.${profile.birthDate.year}.',
                    style: GoogleFonts.oswald( textStyle: const TextStyle(
                      fontSize: 18.0, color: Colors.black54,),
                    ),
                  ),
                  child ?? Container(),
                ],
              ),
              ),
            ],
          ),
        ],
      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Tooltip(
              message: 'Pošalji elektronsku poštu.',
              child:
              InkWell(
                onTap:  ()  {
                  final url = 'mailto:$email';
                  launch(url);
                },
                child: Text(email ?? '',
                  style: GoogleFonts.oswald(
                    textStyle: const TextStyle(
                      fontSize: 19.0, color: Colors.black54,),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}