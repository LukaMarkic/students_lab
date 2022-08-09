
import 'package:flutter/material.dart';
import 'package:students_lab/screens/frontPages/frontpage.dart';
import '../error.dart';
import '../loading.dart';
import '../services/auth.dart';
import 'authentification/loginFrontPage.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
            return FrontPage();
        } else {
            return const LoginScreen();
        }
      },
    );
  }
}


