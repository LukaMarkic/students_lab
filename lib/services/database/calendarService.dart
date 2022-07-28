
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models.dart';
import 'courseService.dart';


class CalendarService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<String?> addEventToUser(String collectionName, String userID, Event event)async {
    try{

      var ref = _db.collection(collectionName).doc(userID).collection('events').doc();
      event.id = ref.id;
      Map<String, dynamic> uploadedData = event.toJson();
      ref.set(uploadedData);
      return ref.id;
    }
    on FirebaseException catch(e){
      print(e);
      return null;
    }
  }

  Future<List<Event>?> getUserEvents(String collectionName, String userID) async {


    var ref = _db.collection(collectionName).doc(userID).collection('events');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var events = data.map((d) => Event.fromJson(d));
    return events.toList();
  }

  Future<void> removeEvent(String collectionName, String userID, String eventID) async{

    await _db.collection(collectionName).doc(userID).collection('events').doc(eventID).delete();

  }

  Future<void> setEventToAllEnrolledStudents(String courseCodes, Event event) async {

    List<ProfileStudent>? students = await CourseService().getAllStudentEnrolledInCourses([courseCodes]);
    if(students != null){
      for(var student in students){
        addEventToUser('studentUsers', student.id, event);
      }
    }
  }

  Future<void> removeEventToAllEnrolledStudents(String courseCodes, String eventID) async {

    List<ProfileStudent>? students = await CourseService().getAllStudentEnrolledInCourses([courseCodes]);
    if(students != null){
      for(var student in students){
        removeEvent('studentUsers', student.id, eventID);
      }
    }
  }

}






