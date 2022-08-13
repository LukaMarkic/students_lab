import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/screens/administrator/assignCourseToProfessor.dart';
import 'package:students_lab/screens/administrator/createCourseForm.dart';
import 'package:students_lab/screens/administrator/createSegmentForm.dart';
import 'package:students_lab/services/auth.dart';
import '../../services/database/profileService.dart';
import '../../services/notificationService.dart';
import '../home.dart';
import 'createProfessorsAccount.dart';

class AdminFrontPage extends StatefulWidget {
  const AdminFrontPage({Key? key}) : super(key: key);

  @override
  State<AdminFrontPage> createState() => _AdminFrontPageState();
}

class _AdminFrontPageState extends State<AdminFrontPage> {
  var user = AuthService().user;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    var token = await NotificationService().getNotificationToken();
    ProfileService().setUserToken(adminCollection, AuthService().user!.uid, token);
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: adminColorTheme,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin"),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                AuthService().signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: sizeHeight * 0.125,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.indigo.shade900,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          user?.email ?? '',
                          style: GoogleFonts.oswald(
                            textStyle: const TextStyle(
                              fontSize: 22.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox( height: sizeHeight * 0.05,),
              Container(
                width: sizeWidth,
                height: sizeHeight * 0.075,
                decoration: const BoxDecoration(
                    color: Color(0Xffd0eaf5),
                    border: Border.symmetric( horizontal: BorderSide(width: 1, color: Colors.black))),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateCourseForm()));
                  },
                  child: Text(
                    'Stvori kolegij',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0Xffd0eaf5)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                ),
              ),
              Container(
                width: sizeWidth,
                height: sizeHeight * 0.075,
                decoration: BoxDecoration(
                    color: Color(0Xffd0eaf5),
                    border: Border.symmetric(
                        horizontal: BorderSide(width: 1, color: Colors.black))),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateSegmentForm()));
                  },
                  child: Text(
                    'Stvori segment kolgija',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color(0Xffd0eaf5)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                ),
              ),
              Container(
                width: sizeWidth,
                height: sizeHeight * 0.075,
                decoration: BoxDecoration(
                    color: Color(0Xffd0eaf5),
                    border: Border.symmetric(
                        horizontal: BorderSide(width: 1, color: Colors.black))),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfessorSignupForm()));
                  },
                  child: Text(
                    'Stvori račun predavača',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0Xffd0eaf5)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                ),
              ),
              Container(
                width: sizeWidth,
                height: sizeHeight * 0.075,
                decoration: BoxDecoration(
                    color: Color(0Xffd0eaf5),
                    border: Border.symmetric(
                        horizontal: BorderSide(width: 1, color: Colors.black))),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssignCourseToProfessor()));
                  },
                  child: Text(
                    'Dodijeli kolegije profesorima',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0Xffd0eaf5)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
