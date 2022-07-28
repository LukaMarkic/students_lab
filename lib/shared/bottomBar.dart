
import 'package:flutter/material.dart';
import 'package:students_lab/screens/frontpage.dart';
import '../screens/calendar/builders/futureCalendarBuilder.dart';
import '../screens/profile.dart';


Widget BottomWidget(BuildContext context, int _selectedIndex, String collectionName, String userID){

  return  BottomNavigationBar(
    backgroundColor: Colors.blue,
    fixedColor: Color(0xffE3E3E3),
    unselectedItemColor: Color(0xff484848),
    items: <BottomNavigationBarItem>[
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
    currentIndex: _selectedIndex,
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
            MaterialPageRoute(builder: (context) => FrontPage()),
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


