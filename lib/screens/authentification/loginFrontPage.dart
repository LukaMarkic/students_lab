
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'adminLoginForm.dart';
import 'loginForm.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: exitAlert,
        child: Scaffold(
        backgroundColor: backgroundWelcomeColor,
        body: SingleChildScrollView(
          child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.1),
              const Text(
                "Dobro došli u Students Lab", textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black87),

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
              }, child: const Text('Fakultet elektrotehnike, računarstva i informacijskih tehnologija Osijek (FERIT Osijek)', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black45, fontSize: 16, ),),
              ),

              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: size.width* 0.94,
                child: Column(
                  children: const [
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
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child:  ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginForm();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                child: const Text(
                  "Prijavi se",
                  style: TextStyle(fontSize: 18 ),
                ),
              ),
            ),
          ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AdminLoginForm();
                      },
                    ),
                  );
                },
                child: const Text("Nastavi kao administrator"),
              ),
            ],
          ),
          ),
        ),
      ),
    );
}


  Future<bool> exitAlert () async {
    FocusScope.of(context).unfocus();
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          title: const Text('Želite li napustiti aplikaciju?', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: buttonExitStyle,
              child: const Text('Da', style: TextStyle(color: Colors.black87),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: buttonNotExitStyle,
              child: const Text('Ne', style: TextStyle(color: Colors.black45)),
            ),
          ],
        );
      },
    );
    return shouldPop!;
  }

}


