
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/services/database/courseService.dart';
import '../../models.dart';
import '../../widgets/buttons/roundedButton.dart';
import '../../widgets/inputs/roundedInput.dart';



class CreateSegmentForm extends StatefulWidget {
  const CreateSegmentForm({ Key? key }) : super(key: key);
  @override
  _CreateSegmentForm createState() => _CreateSegmentForm();
}

class _CreateSegmentForm extends State<CreateSegmentForm> with SingleTickerProviderStateMixin {

  String courseCode = '000XXX';
  String title = '';
  String segmentCode = '0_XX';
  late Segment segment;
  final CourseService _courseService = CourseService();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: adminColorTheme,
      appBar: AppBar(
        title: const Text(
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