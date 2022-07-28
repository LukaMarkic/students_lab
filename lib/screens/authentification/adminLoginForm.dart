import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/constants.dart';
import '../../services/auth.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/roundedInput.dart';
import '../../widgets/roundedPassword.dart';
import '../administrator/adminFrontPage.dart';


class AdminLoginForm extends StatefulWidget {
  const AdminLoginForm({ Key? key }) : super(key: key);
  @override
  _AdminLoginForm createState() => _AdminLoginForm();
}

class _AdminLoginForm extends State<AdminLoginForm> with SingleTickerProviderStateMixin
{

  String _email = '';
  String _password = '';
  String _seckey = '';


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: adminColorTheme,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title:Text(
          "Prijava",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: size.height * 0.01),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                Text('Obrazac prijave', textAlign: TextAlign.center, style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold, color: Color(0Xfff7fafa)),),
                  Text('ADMINISTRATOR', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white70,),),
                  Divider(height: 1.5, color: primaryDividerColor,),
                ],
              ),),

            SizedBox(height: size.height * 0.02),
            RoundedInputField(
              hintText: "Unesite vaš email",
              onChanged: (value) {
                setState(
                        () => _email = value
                );
              },
            ),
            RoundedHiddenField(
              hintText: "Unesite vašu zaporku",
              onChanged: (value) {
                setState(
                        () => _password = value
                );
              },
            ),
            RoundedHiddenField(
              hintText: "Unesite vaš ključ",
              onChanged: (value) {
                setState(
                        () => _seckey = value
                );
              },
              icon: Icons.keyboard_alt_outlined,

            ),
            RoundedButton(
              text: "Prijavi se",
              press: () async {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                await AuthService().AdminSignInWithEmailPassword(_email.trim(), _password.trim(), _seckey.trim()).then((value) => AdminCheckingAccountAuth(context, value, "Email adresa ili  zaporka nisu ispravne!\nMolimo pokušajte ponovno!"));
              },
            ),
            SizedBox(height: size.height * 0.03),

          ],
        ),
      ),
      ),


    );
  }

  Future<void> AdminCheckingAccountAuth(BuildContext context, String? uid, String message) async{


    if (uid != null) {
      var sky = await FirebaseFirestore.instance.collection('adminUsers').doc(uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          return data['sec_key'];
        }
      });
      if(sky != _seckey) {
        await AuthService().signOut();
        return;
      }else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminFrontPage()),
              (Route<dynamic> route) => false,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: message, fontSize: 12, backgroundColor: Colors.grey,);
    }
  }


}
