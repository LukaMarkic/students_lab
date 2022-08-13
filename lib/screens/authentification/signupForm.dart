import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/notificationService.dart';
import 'package:students_lab/widgets/inputs/roundedDate.dart';
import '../../services/auth.dart';
import '../../shared/methods/profileUserMethods.dart';
import '../../widgets/backgroundImageWidget.dart';
import '../../widgets/buttons/roundedButton.dart';
import '../../widgets/inputs/roundedInput.dart';
import '../../widgets/inputs/roundedPassword.dart';
import '../../widgets/inputs/roundedSelectYear.dart';



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
  DateTime? selectedDate;

  int? godinaStudija;
  bool _yearValidatedShown = false;
  bool _dateValidatedShown = false;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.7),
      appBar: AppBar(
        title:const Text(
          "Registracija",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,),
        body: BackgroundImageWidget(
          imagePath: 'assets/images/log-in-background.jpg',
          colorOpacity: 0.35,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.01),
                    Padding(padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),),
                    SizedBox(height: size.height * 0.03),
                    RoundedInputField(
                      validatorMessage: 'Potrebni unijeti ime',
                      hintText: "Unesite vaše ime",
                      icon: Icons.account_box_outlined,
                      onChanged: (value) {
                        setState(
                                () => name = value
                        );
                      },
                    ),
                    RoundedInputField(
                      validatorMessage: 'Potrebni unijeti prezime',
                      hintText: "Unesite vaše prezime",
                      icon: Icons.account_box_rounded,
                      onChanged: (value) {
                        setState(
                                () => surname = value
                        );
                      },
                    ),

                    RoundedDateField(
                      isValidateShown: _dateValidatedShown,
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
                      selectedDate: selectedDate,
                    ),
                    RoundedSelectYear(
                      isValidateShown: _yearValidatedShown,
                      godinaStudija: godinaStudija,onChanged: (newValue) {
                      setState(() {
                        godinaStudija = newValue!;
                      });
                    },),
                    RoundedInputField(
                      validatorMessage: 'Potrebni unijeti email',
                      hintText: "Unesite vaš email",
                      onChanged: (value) {
                        setState(
                                () => email = value
                        );
                      },
                    ),
                    RoundedHiddenField(
                      validatorMessage: 'Potrebni unijeti zaporku',
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
                        setValidateYear();
                        setValidateDate();
                        if(validate()){
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          var token = await NotificationService().getNotificationToken();
                          ProfileStudent student = ProfileStudent(email: email.trim(), name: name.trim(), surname: surname.trim(), godinaStudija: godinaStudija ?? 1, birthDate: selectedDate ?? defaultTime, token: token);
                          await AuthService().SignUpWithEmailPassword(student, 'studentUsers', password.trim()).then((value) => CheckingAccountAuth(context, value, "Email adresa je već iskorištena, pokušajete ponovno!"));
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }


  void setValidateYear(){
    if(godinaStudija == null){
      setState(() {
        _yearValidatedShown = true;
      });
    }else{setState(() {
      _yearValidatedShown = false;
    });}
  }

  void setValidateDate(){
    if(selectedDate == null){
      setState(() {
        _dateValidatedShown= true;
      });
    }else{setState(() {
      _dateValidatedShown = false;
    });}
  }

  bool validate() {

    bool validate = _formKey.currentState!.validate();
    if (validate) _formKey.currentState?.save();
    return validate;
  }
}
