
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseStorageService{
final FirebaseStorage storage = FirebaseStorage.instance;
late UploadTask? currentUploadTask;

Future<UploadTask?> uploadFile(File file, String destination) async{
  try{
    final ref = storage.ref(destination);
    return  ref.putFile(file);
  } on FirebaseException catch(e){
    print(e);
    return null;
  }
}


Future<String?> uploadFileAndReturnURL(File? file, String destination) async{
  try{
    final ref = storage.ref(destination);
    await ref.putFile(file!);
    return ref.getDownloadURL();
  } on FirebaseException catch(e){
    print(e);
    return null;
  }
}

Future<String?> downloadFile(String destination) async{
  try{
    final downloadURL = await storage.ref(destination).getDownloadURL();
    return downloadURL;
  } on FirebaseException catch(e){
    print(e);
    return null;
  }
}

Future<void> deleteFile(String destination) async{
  try{
    String? url = await downloadFile(destination);
    if(url != null){
      await FirebaseStorage.instance.refFromURL(url).delete();
    }
  }on FirebaseException catch(e){
    print(e);
    return null;
  }
}

Future<void> deleteFileWithURL(String URL) async{
  try{
      await FirebaseStorage.instance.refFromURL(URL).delete();
  }on FirebaseException catch(e){
    print(e);
    return null;
  }
}

}



