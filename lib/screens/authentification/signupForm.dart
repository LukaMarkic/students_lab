import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/notificationService.dart';
import 'package:students_lab/widgets/roundedDate.dart';
import '../../services/auth.dart';
import '../../shared/sharedMethods.dart';
import '../../widgets/backgroundImageWidget.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/roundedInput.dart';
import '../../widgets/roundedPassword.dart';
import 'package:intl/intl.dart';

import '../../widgets/roundedSelect.dart';



class SignupForm extends StatefulWidget {
  const SignupForm({ Key? key }) : super(key: key);
  @override
  _SignupForm createState() => _SignupForm();
}

class _SignupForm extends State<SignupForm> with SingleTickerProviderStateMixin
{
  String name = '';
  String surname = '';
  String email = '';
  String password = '';
  DateTime defaultTime = DateTime.utc(2000, 1, 1);
  late DateTime selectedDate = defaultTime;
  final DateFormat formatter = DateFormat('dd.MM.yyyy.');
  int? godinaStudija;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.7),
      appBar: AppBar(
        title:Text(
          "Registracija",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,),
        body: BackgroundImageWidget(
          imagePath: 'assets/images/log-in-background.jpg',
          colorOpacity: 0.35,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.01),
                  Padding(padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),),
                  SizedBox(height: size.height * 0.03),
                  RoundedInputField(
                    hintText: "Unesite vaše ime",
                    icon: Icons.account_box_outlined,
                    onChanged: (value) {
                      setState(
                              () => name = value
                      );
                    },
                  ),
                  RoundedInputField(
                    hintText: "Unesite vaše prezime",
                    icon: Icons.account_box_rounded,
                    onChanged: (value) {
                      setState(
                              () => surname = value
                      );
                    },
                  ),
                  RoundedDateField(
                    press: (){
                        showDatePicker(
                          context: context,
                          initialDate:  defaultTime,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((date) {
                          setState(() {
                            selectedDate = date!;
                          });
                        });
                    },
                    selectedDate: selectedDate != defaultTime ? formatter.format(selectedDate.toLocal()).toString().split(' ')[0] : 'Unesite datum rođenja',
                  ),
                  RoundedSelect(godinaStudija: godinaStudija,onChanged: (newValue) {
                    setState(() {
                      godinaStudija = newValue!;
                    });
                  },),
                  RoundedInputField(
                    hintText: "Unesite vaš email",
                    onChanged: (value) {
                      setState(
                              () => email = value
                      );
                    },
                  ),
                  RoundedHiddenField(
                    hintText: "Unesite vašu zaporku",
                    onChanged: (value) {
                      setState(
                              () => password = value
                      );
                    },
                  ),
                  RoundedButton(
                    text: "Stvori račun",
                    press: () async {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      var token = await NotificationService().getNotificationToken();
                      ProfileStudent student = ProfileStudent(name: name.trim(), surname: surname.trim(), godinaStudija: godinaStudija ?? 1, birthDate: selectedDate, token: token);
                      await AuthService().SignUpWithEmailPassword(student, 'studentUsers', email.trim(), password.trim()).then((value) => CheckingAccountAuth(context, value, "Email adresa je već iskorištena, pokušajete ponovno!")
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
