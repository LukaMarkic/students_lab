
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


Widget buildUploadStatus(UploadTask task, String fileName) => StreamBuilder<TaskSnapshot>(
  stream: task.snapshotEvents,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final snap = snapshot.data!;
      final progress = snap.bytesTransferred / snap.totalBytes;
      final percentage = (progress * 100).toStringAsFixed(2);
      if(progress == 1){
        Fluttertoast.showToast(
          msg: 'Uspješno preneseno', fontSize: 14,);
        return Text(fileName);
      }
      return Text(
        '$percentage %',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else {
      return Container();
    }
  },
);