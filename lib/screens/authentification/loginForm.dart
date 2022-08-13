import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:students_lab/screens/authentification/signupForm.dart';
import 'package:students_lab/widgets/backgroundImageWidget.dart';
import '../../constants.dart';
import '../../services/auth.dart';
import '../../shared/methods/navigationMethods.dart';
import '../../shared/methods/profileUserMethods.dart';
import '../../widgets/accountCheck.dart';
import '../../widgets/buttons/roundedButton.dart';
import '../../widgets/inputs/roundedInput.dart';
import '../../widgets/inputs/roundedPassword.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({ Key? key }) : super(key: key);
  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> with SingleTickerProviderStateMixin
{

  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:Text(
          "Prijava",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,),
        body: BackgroundImageWidget(
          imagePath: 'assets/images/log-in-background.jpg',
          colorOpacity: 0.45,
          child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.025),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text('Obrazac prijave', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700),),
                      ),
                      Divider(height: 2, color: primaryDividerColor,),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.075),
                RoundedInputField(
                  validatorMessage: 'Molimo unesite Vašu adresu',
                  hintText: "Unesite vaš email",
                  onChanged: (value) {
                    setState(
                            () => email = value
                    );
                  },
                ),
                RoundedHiddenField(
                  validatorMessage: 'Potrebno unijeti zaporku',
                  hintText: "Unesite vašu zaporku",
                  onChanged: (value) {
                    setState(
                            () => password = value
                    );
                  },
                ),
                RoundedButton(
                  text: "Prijavi se",
                  press: () async {
                    if(validate()){
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      await AuthService().SignInWithEmailPassword(email.trim(), password.trim()).then((value) => CheckingAccountAuth(context, value,"Email adresa ili  zaporka nisu ispravne!\nMolimo pokušajte ponovno!"));
                      }
                    },
                ),
                SizedBox(height: size.height * 0.03),
                DoesntHaveAccountWidget(
                  press: () {
                    goToPage(context: context, page: SignupForm());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    //Validate Form Fields by form key
    bool validate = _formKey.currentState!.validate();
    if (validate) _formKey.currentState?.save();
    return validate;
  }

}
