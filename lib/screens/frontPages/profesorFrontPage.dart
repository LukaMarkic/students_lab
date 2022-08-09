
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models.dart';
import '../../services/auth.dart';
import '../../services/database/courseService.dart';
import '../../services/database/profileService.dart';
import '../../services/notificationService.dart';
import '../../shared/bottomBar.dart';
import '../../shared/methods/navigationMethods.dart';
import '../../shared/methods/ungroupedSharedMethods.dart';
import '../../widgets/widgetsOfContentEditing/cancelSortIcon.dart';
import '../../widgets/buttons/dropdownOptionsButton.dart';
import 'courseBuilder.dart';
import '../studentDirectory/futureStudentDirectory.dart';

class ProfessorFrontPage extends StatefulWidget {

  ProfileProfessor professor;
  List<ProfileStudent> allStudents;
  List<Course> assignedCourses;
  ProfessorFrontPage({Key? key,
    required this.professor,
    this.allStudents = const <ProfileStudent>[],
    this.assignedCourses = const [],
  }) : super(key: key);

  @override
  State<ProfessorFrontPage> createState() => _ProfessorFrontPageState();
}

class _ProfessorFrontPageState extends State<ProfessorFrontPage> with SingleTickerProviderStateMixin {


  //
  static const String _searchText = 'Pretraži';
  static const String _sortText = 'Sortiraj';
  static const String _groupText = 'Grupiraj';
  static const String _logOutText = 'Odjavi se';

  DropdownItem search = DropdownItem(text: _searchText, icon: const Icon(Icons.search),  iconCancel: const Icon(Icons.search_off));
  DropdownItem sort = DropdownItem(text: _sortText, icon: const Icon(Icons.sort), iconCancel: const CancelSortIcon());
  DropdownItem group = DropdownItem(text: _groupText, icon: const Icon(Icons.filter_list), iconCancel: const Icon(Icons.filter_list_off) );
  DropdownItem logout = DropdownItem(text: _logOutText, icon: const Icon(Icons.logout), iconCancel: const Icon(Icons.login) );

  late List<DropdownItem> firstItems = [search, sort, group, logout];

  //

  late TabController _tabController;
  bool isSearchShown = false;
  bool isSortShown = false;
  bool isGroupedActive = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    FirebaseMessaging.instance.getInitialMessage();
    init();
  }

  Future init() async {
    var token = await NotificationService().getNotificationToken();
    if(AuthService().user != null) ProfileService().setUserToken(professorCollection, AuthService().user!.uid, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryThemeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Naslovna"),
        actions: [
          DropdownOptionsButton(menuItems: firstItems,
            onChange: onChange,
          ),
          SizedBox(width: 10,),
        ],
        backgroundColor: Colors.lightBlueAccent,
        bottom: TabBar(
          unselectedLabelColor: Colors.white60,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          indicatorColor: Colors.white,
          controller: _tabController,
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
          controller: _tabController,
          children: [
            CoursesBuilder(courses: widget.assignedCourses, isSearchShown: isSearchShown, isSortShown: isSortShown, isGroupedActive: isGroupedActive,),
            FutureStudentDirectory(professor: widget.professor, students: widget.allStudents, isSearchShown: this.isSearchShown, isSortShown: this.isSortShown, isGroupedActive: isGroupedActive,),
          ]
      ),

      bottomNavigationBar: BottomWidget(context, 1, professorCollection, AuthService().user != null ? AuthService().user!.uid : ''),
    );
  }


  onChange (item) {
    switch (item.text) {
      case _searchText:
        setState(() {
          isSearchShown = !isSearchShown;
          item.isActive = !item.isActive;
        });
        break;
      case _sortText:
        setState(() {
          isSortShown = !isSortShown;
          item.isActive = !item.isActive;
        });
        break;
      case _groupText:
        setState(() {
          item.isActive = !item.isActive;
          isGroupedActive = !isGroupedActive;
        });
        break;
      case _logOutText:
        signOut(context);
        break;
    }
  }

}


