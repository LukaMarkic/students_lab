
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/shared/sharedMethods.dart';
import 'package:students_lab/widgets/uploadStatus.dart';
import '../constants.dart';
import 'package:file_picker/file_picker.dart';
import '../services/database/storageServices.dart';


class FilePickerWidget extends StatefulWidget {

  final Color color, textColor;
  late String directoryPath;
  String? URL;

  FilePickerWidget({
    this.color = buttonColor,
    this.textColor = Colors.white,
    this.directoryPath = '',
    Key? key,
  }) : super(key: key);

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  final FirebaseStorageService firebaseStorage = FirebaseStorageService();

  UploadTask? task;
  File? file;
  late String filePath;
  late String fileName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size.width * 0.8,
          child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: newElevatedButton(context),
          ),
        ),
        task != null ? buildUploadStatus(task!, fileName)  : Container(),
      ],
    );
  }

  Widget newElevatedButton(BuildContext context) {
    return ElevatedButton(
      child: Text(
        'Dodaj dokument',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async{
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          );
          if(result == null){
          ShowScaffoldMessage(context, 'Dokument nije odabran');
          return;
          }else{

          filePath = result.files.single.path!;
          fileName = result.files.single.name;

          file = File(filePath);
          task = await firebaseStorage.uploadFile(file!, "${widget.directoryPath}/${fileName}");

          var imageUrl = await (await task)?.ref.getDownloadURL();
          widget.URL = imageUrl.toString();

          setState(() {});

          }
        },
      style: ElevatedButton.styleFrom(
          primary: widget.color,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              color: widget.textColor, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}