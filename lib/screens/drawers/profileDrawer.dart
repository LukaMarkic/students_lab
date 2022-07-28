import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/shared/sharedMethods.dart';
import '../../error.dart';
import '../../loading.dart';


class ProfileDrawer extends StatefulWidget {
  String fullName;
  ProfileDrawer({ Key? key, this.fullName = ''}) : super(key: key);

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {



  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryThemeColor,
      child:  FutureBuilder(
          future: ProfileService().getProfileDataStudent(AuthService().user!.uid),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return const Center(
                child: ErrorMessage(),
              );
            }
            else {
              if(snapshot.data == null){
                return CircularProgressIndicator();
              }
              else{
                ProfileStudent student = snapshot.data;
                return ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.account_circle_outlined, color: Colors.black,),
                      title: Text('${student.name} ${student.surname}',style: TextStyle(fontSize: 16, color: Colors.black),),
                    ),
                    ListTile(
                      leading: Icon(Icons.email_outlined, color: Colors.black87,),
                      title: Text(AuthService().user!.email ?? '', style: TextStyle(color: Colors.black87, fontSize: 14,),),
                    ),
                   SizedBox(height: 30,),
                    TextButton(onPressed: (){
                      signOut(context);
                    }, child: Text('Odjavi se', style: TextStyle(color: Colors.green),)),


                  ],
                );
              }
            }
          }
      ),
    );
  }
}
