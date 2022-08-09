


import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants.dart';
import 'package:path/path.dart' as p;


Future pickImage(ImageSource source) async{

  final image = await ImagePicker().pickImage(source: source, imageQuality: 60,);
  if(image == null) return;

  final imageTemporary = File(image.path);
  return imageTemporary;

}


Future<File?> getFile() async {
  File? file;
  late String filePath;

  final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.custom,
    allowedExtensions: ['docx', 'pdf', 'doc', 'XLSX', 'XLS', 'ppt', 'pptx', 'pptm'],);
  if(result == null){
    return null;
  }else{
    filePath = result.files.single.path!;
    file = File(filePath);
    return file;
  }
}


//Open downloaded file

Future openFileFromURL(String URL, String fileName) async{
  final file = await downloadFile(URL, fileName);
  if(file == null) return;
  OpenFile.open(file.path);
}

Future<File?> downloadFile(String url, String fileName) async{
  final appStorage = await getApplicationDocumentsDirectory();
  final file = File('${appStorage.path}/$fileName');


  final response = await Dio().get(url,
    options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout: 0,
    ),
  );

  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  await raf.close();
  return file;

}


void loadingDialog (BuildContext context, dynamic function) async {

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                // Some text
                Text('Učitavanje sadržaja', style: textStyleColorBlack,)
              ],
            ),
          ),
        );
      });

  await function;
  await Future.delayed(const Duration(microseconds: 200));

  Navigator.of(context).pop();
}



String getNameFromURL(String URL){

  return URL.split(RegExp(r'(%2F)..*(%2F)'))[1].split("?alt")[0];
}



String getExtensionFromFirebaseURL(String URL){
  return p.extension(URL).split('?alt').first.substring(1,p.extension(URL).split('?alt').first.length);
}