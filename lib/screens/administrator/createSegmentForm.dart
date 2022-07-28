
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/services/database/courseService.dart';
import '../../models.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/roundedInput.dart';



class CreateSegmentForm extends StatefulWidget {
  const CreateSegmentForm({ Key? key }) : super(key: key);
  @override
  _CreateSegmentForm createState() => _CreateSegmentForm();
}

class _CreateSegmentForm extends State<CreateSegmentForm> with SingleTickerProviderStateMixin {

  String courseCode = '000XXX';
  String title = '';
  String segmentCode = '0_XX';
  List<String> documentURLs = <String>[];
  late Segment segment;
  CourseService _courseService = CourseService();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: adminColorTheme,
      appBar: AppBar(
        title: Text(
          "Obrazac - Stvori kolegij",
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Unesite kod kolegija",
                icon: Icons.account_box_rounded,
                onChanged: (value) {
                  setState(
                          () => courseCode = value
                  );
                },
              ),
              RoundedInputField(
                hintText: "Unesite ime segmenta",
                icon: Icons.account_box_outlined,
                onChanged: (value) {
                  setState(
                          () => title = value
                  );
                },
              ),
              RoundedInputField(
                hintText: "Unesite kod segmenta",
                icon: Icons.account_box_rounded,
                onChanged: (value) {
                  setState(
                          () => segmentCode = value
                  );
                },
              ),


              RoundedButton(
                text: "Stvori segment",
                press: () async {
                  documentURLs.add('https://firebasestorage.googleapis.com/v0/b/students-lab-lm.appspot.com/o/203PRO%2Fphotos%2Fcover%2FcurrentCover?alt=media&token=39d2079d-f68f-4bdb-917c-8ad47b3966f3');
                  documentURLs.add('https://firebasestorage.googleapis.com/v0/b/students-lab-lm.appspot.com/o/503OAU%2Fphotos%2Fcover%2FcurrentCover?alt=media&token=3c480ec8-09ad-481c-9a45-87b1bc90efc8');
                  segment = Segment(title: title, code: segmentCode);
                  _courseService.addSegmentToCourse(courseCode, segment);
                },
                color: Colors.lightGreen,
              ),

            ],

          ),

        ),
      ),
    );
  }

}