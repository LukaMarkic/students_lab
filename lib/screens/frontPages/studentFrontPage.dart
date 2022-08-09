


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

class StudentFrontPage extends StatefulWidget {

  List<Course> allCourses;
  List<Course> enrolledCourses;
  StudentFrontPage({Key? key,
    this.allCourses = const [],
    this.enrolledCourses = const [],
  }) : super(key: key);

  @override
  State<StudentFrontPage> createState() => _StudentFrontPageState();
}

class _StudentFrontPageState extends State<StudentFrontPage> with SingleTickerProviderStateMixin {

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
    init();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      NotificationService.display(event);
    });
  }

  Future init() async {

    if(AuthService().user != null) {
      var token = await NotificationService().getNotificationToken();
      ProfileService().setUserToken(studentCollection, AuthService().user!.uid, token);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryThemeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Početna"),
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
              text: "Moji kolegiji",
            ),
            Tab(
              text: "Svi kolegiji",
            ),
          ],
        ),

      ),
      body: TabBarView(
          controller: _tabController,
          children: [
            CoursesBuilder(courses: widget.enrolledCourses, isSearchShown: isSearchShown, isSortShown: isSortShown, isGroupedActive: isGroupedActive,),
            CoursesBuilder(courses: widget.allCourses, isSearchShown: isSearchShown, isSortShown: isSortShown, isGroupedActive: isGroupedActive,),
          ]
      ),

      bottomNavigationBar: BottomWidget(context, 1, studentCollection, AuthService().user != null ? AuthService().user!.uid : '' ),
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
        setState(() {
          signOut(context);
        });
        break;
    }
  }


}
