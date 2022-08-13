import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/services/database/courseService.dart';
import 'package:students_lab/widgets/inputs/roundedDoubleInput.dart';
import '../../models.dart';
import '../../services/database/storageServices.dart';
import '../../shared/methods/fileMethods.dart';
import '../../widgets/buttons/roundedButton.dart';
import '../../widgets/inputs/roundedInput.dart';
import '../course/builders/futureSegmentsBuild.dart';





class CreateCourseForm extends StatefulWidget {
  const CreateCourseForm({ Key? key }) : super(key: key);
  @override
  _CreateCourseForm createState() => _CreateCourseForm();
}

class _CreateCourseForm extends State<CreateCourseForm> with SingleTickerProviderStateMixin
{
  String title = '';
  String? code;
  double ECTS = 0;
  String? imgURL;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  Course course = Course(code: '000XXX');
  int semester = 1;
  File? _image;

  CourseService _courseService = CourseService();

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: adminColorTheme,
      appBar: AppBar(
        title:Text(
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
              Padding(padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Unesite ime kolegija",
                icon: Icons.layers_outlined,
                onChanged: (value) {
                  setState(
                          () => title = value.trim()
                  );
                },
              ),

              RoundedDoubleInputField(
                icon: Icons.format_list_numbered,
                hintText: "Unesite redni broj semestra",
                onChanged: (value) {
                  setState(
                          () => semester = int.parse(value)
                  );
                },
              ),
              RoundedInputField(
                hintText: "Unesite kod kolegija",
                icon: Icons.layers_rounded ,
                onChanged: (value) {
                  setState(
                          () => code = value.trim()
                  );
                },
              ),



              RoundedDoubleInputField(
                icon: Icons.school,
                hintText: "Unesite broj ECTS bodova",
                onChanged: (value) {
                  setState(
                          () => ECTS = double.parse(value)
                  );
                },
              ),

              RoundedButton(text: 'Odaberi tematsku boju kolegija', press: () {
                showRGBPicker();
              }, color: currentColor,),

              RoundedButton(text: 'Odaberi sliku kolegija', press: () async {
                if(code == null){
                  Fluttertoast.showToast(msg: "Molimo unesite kod kolegija", fontSize: 12,);
                }
                else{
                  await showPickedPhoto();
                }

              },),





              RoundedButton(
                text: "Stvori kolegij",
                press: () async {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  if(_image != null){
                    imgURL = await FirebaseStorageService().uploadFileAndReturnURL(_image, 'files/${code}/photos/cover/currentCover');
                  }
                  course = Course(title: title, ECTS: ECTS, color: currentColor.value, imgURL: imgURL, code: code ?? '000XXX', semester: semester);
                  await _courseService.addCourseData(course);
                  await _courseService.addDefaultSegmentsToCourse(code);

                  Fluttertoast.showToast(
                    msg: 'Kolegij stvoren', fontSize: 12, backgroundColor: Colors.grey,);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => FutureSegmentsBuild(course: course),
                    ),
                  );
                },
                color: Colors.lightGreen,
              ),

            ],

      ),

    ),
      ),
    );
  }






  //showDialogs

Future showRGBPicker() => showDialog(context: context,
    builder: (context) =>  AlertDialog(
      title: const Text('Odabeite boju!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Zatvori'),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
);



  Future showPickedPhoto() async {

    _image = await pickImage(ImageSource.gallery);

    setState(() {
    });

    showDialog(context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Odabrana slika!'),
            content: SingleChildScrollView(
              child: Container(
                child: _image != null ? Image.file(_image!) : Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text("Niste odabrali fotografiju",),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Zatvori'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

}
