
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/screens/frontPages/frontpage.dart';
import '../screens/calendar/builders/futureCalendarBuilder.dart';
import '../screens/profile.dart';


Widget BottomWidget(BuildContext context, int selectedIndex, String collectionName, String userID){

  return  BottomNavigationBar(
    backgroundColor: Colors.blue,
    fixedColor: fixedBottomBarColor,
    unselectedItemColor: unselectedBottomBarColor,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined),
        label: 'Profil',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Početna',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.today),
        label: 'Kalendar',
      ),
    ],
    currentIndex: selectedIndex,
    onTap: (int idx) {
      switch (idx) {
        case 0:
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  ProfileScreen()));
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FrontPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FutureCalendarBuild(collectionName: collectionName, userID: userID,)),
          );
          break;
      }
    },

  );
}


