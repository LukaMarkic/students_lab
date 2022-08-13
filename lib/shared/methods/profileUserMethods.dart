
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants.dart';
import '../../screens/authentification/adminLoginForm.dart';
import '../../screens/frontPages/frontpage.dart';
import '../../services/auth.dart';
import '../../services/database/courseService.dart';
import 'navigationMethods.dart';


Future<void> CheckingAccountAuth(BuildContext context, String? uid, String message) async{

  if (uid != null) {
    UserType type = await getUserType(uid);
    if(type == UserType.admin) {
      await AuthService().signOut();
      Fluttertoast.showToast(
        msg: 'Pogrešni prozor!\nPokušajte ovdje.', fontSize: 14, backgroundColor: Colors.grey,);
      goToPage(context: context, page: AdminLoginForm());
      return;
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FrontPage()),
            (Route<dynamic> route) => false,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: message, fontSize: 12, backgroundColor: Colors.grey,);
  }

  if (AuthService().user != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FrontPage()),
    );
  } else {
    Fluttertoast.showToast(
      msg: message, fontSize: 12, backgroundColor: Colors.grey,);
  }
}



Future<UserType> getUserType(String? docId) async {
  try {
    var collectionRef = FirebaseFirestore.instance.collection(studentCollection);
    var doc = await collectionRef.doc(docId).get();
    if(doc.exists) {
      return UserType.student;
    } else{
      collectionRef = FirebaseFirestore.instance.collection(adminCollection);
      var doc = await collectionRef.doc(docId).get();
      if(doc.exists) {
        return UserType.admin;
      }else{
        return UserType.professor;
      }
    }
  } catch (e) {
    throw e;
  }
}




Future<bool> isEnrolledIn(String courseCode) async {
  try {

    var uid = AuthService().user!.uid;
    var codes = await CourseService().getStudentEnrolledCourseCodes(uid);
    return codes.contains(courseCode);
  } catch (e) {
    throw e;
  }
}