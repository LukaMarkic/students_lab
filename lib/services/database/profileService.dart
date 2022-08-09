
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/database/courseService.dart';
import 'gradeService.dart';


class ProfileService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addProfileData(String collectionName, ProfileUser user) async{

    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collectionName);
    Map<String, dynamic> uploadedData = user.toJson();
    await collectionReference.doc(user.id).set(uploadedData);


  }

  Future<void> updateProfileImageURL(String uid, String collectionName, String? imgURL) async{

    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collectionName);
    await collectionReference.doc(uid).update({'imgURL': imgURL});


  }



  Future<void> enrollInCourse(String uid, String courseCode) async{


    CollectionReference collectionReference = FirebaseFirestore.instance.collection('studentUsers');
    var ref = collectionReference.doc(uid);
    ref.update({
      'enrolledCoursesCodes' : FieldValue.arrayUnion([courseCode]),
    });
    GradeService().setGrade(CourseGrade(courseCode: courseCode, studentID: uid));
  }


  Future<void> leaveCourse(String uid, String courseCode) async{


    CollectionReference collectionReference = FirebaseFirestore.instance.collection('studentUsers');
    var ref = collectionReference.doc(uid);
    ref.update({
        'enrolledCoursesCodes' : FieldValue.arrayRemove([courseCode]),
      }
    );
  }

  Future<ProfileStudent> getProfileDataStudent(String uid) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('studentUsers');
    var documentSnapshot = await collectionReference.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
    return ProfileStudent.fromJson(data);
  }

  Future<List<ProfileStudent>> getAllProfileStudents() async{

    var collectionReference =  _db.collection('studentUsers');
    var snapshot = await collectionReference.get();
    var data = snapshot.docs.map((s) => s.data());
    var students = data.map((d) =>ProfileStudent.fromJson(d));
    return students.toList();

  }

  Future<String?> getUserFullName(String collectionName, String uid) async{

    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collectionName);
    var documentSnapshot = await collectionReference.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
    var fullName = data['name'] + ' ' + data['surname'] as String;
    return fullName;

  }


  //Admin

  Future<ProfileAdmin> getProfileAdminData(String uid) async{

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('adminUsers');
    var documentSnapshot = await collectionReference.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
    return ProfileAdmin.fromJson(data);

  }


  //Professor

  Future<ProfileProfessor> getProfileProfessorData(String uid) async{

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('professorUsers');
    var documentSnapshot = await collectionReference.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
    return ProfileProfessor.fromJson(data);

  }


  Future<void> assignCourse(String professorID, String courseCode)async {

    CollectionReference professorReference = FirebaseFirestore.instance.collection('professorUsers');
    var ref = professorReference.doc(professorID);
    ref.update({
      'assignedCoursesCodes' : FieldValue.arrayUnion([courseCode]),
    });
  }

  Future<List<ProfileProfessor>> getAllProfileProfessors() async{

    var collectionReference =  _db.collection('professorUsers');
    var snapshot = await collectionReference.get();
    var data = snapshot.docs.map((s) => s.data());
    var professors = data.map((d) =>ProfileProfessor.fromJson(d));
    return professors.toList();

  }






  //Notification

  Future<void> setUserToken(String collectionName, String userID , String? token)async {
    var ref = _db.collection(collectionName).doc(userID).set({
      'token' : token,
    },SetOptions(merge: true));
  }






  //Grade

  Future<ProfileStudent?> getStudentWithBestMark(String courseCode) async {

    double maxGrade = 0;
    ProfileStudent? studentWithBestMark;
    var students = await CourseService().getAllStudentEnrolledInCourses(<String>[courseCode]);
    if(students != null) {

      for (var student in students) {
        double? grade = await GradeService().getCourseGrade(student.id, courseCode);
        if (grade != null && grade >= maxGrade)
          {
              studentWithBestMark = ProfileStudent(birthDate: DateTime.now());
              studentWithBestMark = student;
              maxGrade = grade;
        }
      }
    }
    return studentWithBestMark;
  }


}