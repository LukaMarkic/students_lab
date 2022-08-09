

import 'package:flutter/material.dart';
import '../../screens/frontPages/frontpage.dart';
import '../../screens/home.dart';
import '../../services/auth.dart';

void goToPage({context, page}){
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page
  ));
}

void goBack({context}){
  Navigator.of(context).pop();
}

void goToPageWithLastPop({context, page}){

  Navigator.of(context).pop();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => FrontPage()),
    ModalRoute.withName('/'),
  );
  Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => page
      )
  );
}



void signOut(BuildContext context){
  AuthService().signOut();
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen()));
}