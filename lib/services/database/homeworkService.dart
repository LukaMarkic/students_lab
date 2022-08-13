
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/services/database/storageServices.dart';


class HomeworkService{


  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('homeworks');

  Future<String?> addHomework(Homework homework) async{

    var ref = collectionReference.doc();
    homework.id = ref.id;
    Map<String, dynamic> homeworkData = homework.toJson();
    ref.set(homeworkData);
    return ref.id;
  }

  Future<void> removeHomework(String homeworkID) async{

    FirebaseStorageService firebaseStorageService = FirebaseStorageService();
    Homework homework = await getHomeworkData(homeworkID);
    if(homework.documentURL != null) firebaseStorageService.deleteFileWithURL(homework.documentURL!);

    var ref = collectionReference.doc(homeworkID).collection('submittedHomeworks');
    var snapshot = await ref.get();
    var submittedHomeworks = snapshot.docs;

    for(var submittedHomework in submittedHomeworks){
      var data = submittedHomework.data();
      SubmittedHomework submittedStudentHomework = SubmittedHomework.fromJson(data);
      if(submittedStudentHomework.documentURL != null) firebaseStorageService.deleteFileWithURL(submittedStudentHomework.documentURL!);
      submittedHomework.reference.delete();
    }

    await collectionReference.doc(homeworkID).delete();

  }

  Future<Homework> getHomeworkData(String homeworkID) async {

    var ref = _db.collection('homeworks').doc(homeworkID);
    var snapshot = await ref.get();
    var data = snapshot.data();
    return Homework.fromJson(data!);
  }


  Future<void> submitHomework(SubmittedHomework submittedHomework)async {
    Map<String, dynamic> data = submittedHomework.toJson();
    collectionReference.doc(submittedHomework.homeworkID).collection('submittedHomeworks').doc(submittedHomework.studentID).set(data);
  }


  Future<List<SubmittedHomework>> getSubmittedHomeworks(String homeworkID) async {

    var ref = _db.collection('homeworks').doc(homeworkID).collection('submittedHomeworks');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var submittedHomeworks = data.map((d) => SubmittedHomework.fromJson(d));
    return submittedHomeworks.toList();
  }


  Future<SubmittedHomework?> getUserSubmittedHomeworks(String homeworkID, String userID) async {

    var ref = _db.collection('homeworks').doc(homeworkID).collection('submittedHomeworks');
    var doc = await ref.doc(userID).get();
    if(doc.exists){
      return SubmittedHomework.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;

  }


  Future<void> gradeHomework(String studentID, String courseID ,ActivityMark activityMark)async {
    var ref = _db.collection('homeworks').doc(activityMark.activityID).collection('submittedHomeworks');
    var doc =  ref.doc(studentID);
    doc.update({
      'graded': true,
    });
    GradeService().addActivityMark(studentID, courseID, activityMark);

  }


  Future<bool> isSubmitted(String studentID, String homeworkID)async {
    var ref = _db.collection('homeworks').doc(homeworkID).collection('submittedHomeworks');
    var doc = await ref.doc(studentID).get();
    return doc.exists;
  }


  Future<List<SubmittedHomeworkListModel>?> getSubmittedHomeworkModels(Homework homework) async {

    List<SubmittedHomeworkListModel>? submittedHomeworkList = <SubmittedHomeworkListModel>[];
    double? grade;
    var submittedHomeworks = await HomeworkService().getSubmittedHomeworks(homework.id);


        submittedHomeworks.forEach((submittedHomework) async {
          var fullName  = await ProfileService().getUserFullName('studentUsers', submittedHomework.studentID);
          if(submittedHomework.graded){
            grade = await GradeService().getActivityMark(submittedHomework.studentID, homework.courseCode, homework.segmentCode, homework.id);
          }
          submittedHomeworkList.add(SubmittedHomeworkListModel(submittedHomework: submittedHomework, studentFullName: fullName ?? '', grade: grade));
        });


      return submittedHomeworkList;



  }







}

