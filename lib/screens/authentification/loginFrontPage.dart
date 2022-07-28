import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'adminLoginForm.dart';
import 'loginForm.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Scaffold(
      backgroundColor: backgroundWelcomeColor,
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.1),
            Text(
              "Dobro došli u Students Lab", textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black87),

            ),
            SizedBox(height: size.height * 0.05),

          Container(
            child: Image.asset(
              'assets/images/ferit_logo.png',
              width: size.height * 0.3,
              height: size.height * 0.3,
            ),
          ),
            TextButton(onPressed: (){
              launch('https://www.ferit.unios.hr');
            }, child: Text('Fakultet elektrotehnike, računarstva i informacijskih tehnologija Osijek (FERIT Osijek)', textAlign: TextAlign.center, style: TextStyle(color: Colors.black45, fontSize: 16, ),),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              width: size.width* 0.94,
              child: Column(
                children: [
                  Text(
                    "Mobilna aplikacija za poticanje aktivnog sudjelovanja studenata u nastavi",
                    style: TextStyle(color: Colors.black54, fontSize: 18, ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),

        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size.width * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child:  ElevatedButton(
              child: Text(
                "Prijavi se",
                style: TextStyle(fontSize: 18 ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginForm();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ),
        ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AdminLoginForm();
                    },
                  ),
                );
              },
              child: Text("Nastavi kao administrator"),
            ),
          ],
        ),
        ),
      ),
    );
  }
}


