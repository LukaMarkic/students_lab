
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/services/database/quizService.dart';
import 'package:students_lab/services/database/storageServices.dart';
import '../../constants.dart';
import 'calendarService.dart';
import 'homeworkService.dart';


class CourseService{


    final FirebaseFirestore _db = FirebaseFirestore.instance;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('courses');
    FirebaseStorageService _firebaseStorageService =  FirebaseStorageService();

    Future<void> addCourseData(Course course) async{
      try{
        Map<String, dynamic> uploadedData = course.toJson();
       await collectionReference.doc(course.code).set(uploadedData);
      }
      on FirebaseException catch(e){
        print(e);
        return null;
      }

    }

    Future<void> updateCourseImageURL(String code, String? imgURL) async{

      await collectionReference.doc(code).update({'imgURL': imgURL});

    }


    Future<Course> getCourseData(String code) async{

      var documentSnapshot = await collectionReference.doc(code).get();
      Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
      return Course.fromJson(data);
    }

    Future<String> getCourseTitle(String code) async{

      String title = '';

      var documentSnapshot = await collectionReference.doc(code).get();
      if(documentSnapshot.data() != null ){
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        title = data['title'] as String;
        return title;
      }else{
        return title;
      }

    }


      //Student
    Future<List<Course>> getEnrolledCourses() async {
      if(AuthService().user != null){
        String uid = AuthService().user!.uid;
        var codes = await getStudentEnrolledCourseCodes(uid);
        if(codes.isNotEmpty) {
          var ref = _db.collection('courses').where('code',  whereIn: codes);
          var snapshot = await ref.get();
          var data = snapshot.docs.map((s) => s.data());
          var enrolledCourses = data.map((d) => Course.fromJson(d));
          return enrolledCourses.toList();
        }else{
          return [];
        }
      }else{
        return [];
      }
    }


    Future<List<ProfileStudent>?> getAllStudentEnrolledInCourses(List<String>? courseCodes) async{

      if(courseCodes == null) {return null;}
      else{
        List<ProfileStudent> allEnrolledStudents = <ProfileStudent>[];
        for(var courseCode in courseCodes){
          var ref = _db.collection('studentUsers').where('enrolledCoursesCodes', arrayContains: courseCode);
          var snapshot = await ref.get();

            var data = snapshot.docs.map((s) => s.data());
            var enrolledStudents = data.map((d) => ProfileStudent.fromJson(d)).toList();
            allEnrolledStudents.addAll(enrolledStudents);

          }
        var seen = Set<String>();
        List<ProfileStudent> uniquelist = allEnrolledStudents.where((student) => seen.add(student.id)).toList();
        return uniquelist;
      }
    }

    Future<List<ProfileStudent>?> getEnrolledStudents(String courseCode) async{

      var ref = _db.collection('studentUsers').where('enrolledCoursesCodes', arrayContains: courseCode);
      var snapshot = await ref.get();
      var data = snapshot.docs.map((s) => s.data());
      var enrolledStudents = data.map((d) => ProfileStudent.fromJson(d));
      return enrolledStudents.toList();

    }
    

    Future<List<String>> getStudentEnrolledCourseCodes(String uid) async{
      var student = await ProfileService().getProfileDataStudent(uid);
      return student.enrolledCoursesCodes;
    }

    Future<List<Course>> getCourses() async {
      var ref = _db.collection('courses');
      var snapshot = await ref.get();
      var data = snapshot.docs.map((s) => s.data());
      var courses = data.map((d) => Course.fromJson(d));
      return courses.toList();
    }


        //Professor
    Future<List<Course>> getAssignedCourses() async {

      String uid = AuthService().user!.uid;
      List<Course> assignedCourses = <Course>[];
      ProfileProfessor professor = await ProfileService().getProfileProfessorData(uid);
      List<Course> allCourses = await getCourses();

      professor.assignedCoursesCodes?.forEach((assignedCode) async {
        var index = allCourses.indexWhere((course) => course.code == assignedCode);
        assignedCourses.add(allCourses.elementAt(index));
      });

      return assignedCourses;

    }


    Future<List<ProfileProfessor>> getAllProfessAssignedToCourse(String courseCode) async{


        List<ProfileProfessor> allAssignedProfessors = <ProfileProfessor>[];

          var ref = _db.collection('professorUsers').where('assignedCoursesCodes', arrayContains: courseCode);
          var snapshot = await ref.get();

          var data = snapshot.docs.map((s) => s.data());
          var assignedProfessors = data.map((d) => ProfileProfessor.fromJson(d)).toList();
          allAssignedProfessors.addAll(assignedProfessors);

        var seen = Set<String>();
        List<ProfileProfessor> uniquelist = allAssignedProfessors.where((professor) => seen.add(professor.id)).toList();
        return uniquelist;

    }



    //Segment

    Future<void> addDefaultSegmentsToCourse(String? courseCode)async {

      try{
        if(courseCode != null){
          List<Segment> segments = defaultSegments;
          segments.forEach((segment) async {
            Map<String, dynamic> uploadedData = segment.toJson();
            await collectionReference.doc(courseCode).collection('segments').doc(segment.code).set(uploadedData);
          });
        }else{
          return;
        }
      }
      on FirebaseException catch(e){
        print(e);
        return null;
      }
    }

    Future<void> addSegmentToCourse(String courseCode, Segment segment) async{
      int index = await getLastSegmentIndex(courseCode) + 1;
      segment.code = segment.title.length < 4 ? '${index}_${segment.title.substring(0,segment.title.length).toUpperCase()}' : '${index}_${segment.title.substring(0,4).toUpperCase()}';
      Map<String, dynamic> uploadedData = segment.toJson();
      collectionReference.doc(courseCode).collection('segments').doc(segment.code).set(uploadedData);
    }

    Future<int> getLastSegmentIndex(String courseCode) async{
      var ref = _db.collection('courses').doc(courseCode).collection('segments');
      var snapshot = await ref.get();
      var documents = snapshot.docs;
      var result = int.parse(documents.elementAt(documents.length - 2).id.split('_').first);
      return result;
    }

    Future<void> removeSegmentFromCourse(String courseCode, Segment segment) async{
      var documents = segment.documents.map((d) => Document.fromJson(d)).toList();
      documents.forEach((document) async {
        await _firebaseStorageService.deleteFileWithURL(document.URL);
      });
      await collectionReference.doc(courseCode).collection('segments').doc(segment.code).delete();

    }

    Future<Segment> getCourseSegmentData(String courseCode, String segmentCode) async {

      var snapshot = await _db.collection('courses').doc(courseCode).collection('segments').doc(segmentCode).get();
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      return Segment.fromJson(data);
    }

    Future<List<Segment>> getCourseSegments(String courseCode) async {

      var ref = _db.collection('courses').doc(courseCode).collection('segments');
      var snapshot = await ref.get();
      var data = snapshot.docs.map((s) => s.data());
      var segments = data.map((d) => Segment.fromJson(d));
      return segments.toList();
    }

    Future<void> addDocumentToCourseSegment(String courseCode, String segmentCode, Document document) async{

      Map<String, dynamic> uploadedData = document.toJson();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
       ref.update({
      'documents': FieldValue.arrayUnion([uploadedData]),
      });
    }


    Future<void> removeDocumentFromCourseSegment(String courseCode, String segmentCode, Document document) async{

      await _firebaseStorageService.deleteFileWithURL(document.URL);
      Map<String, dynamic> uploadedData = document.toJson();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'documents': FieldValue.arrayRemove([uploadedData]),
      });
    }

    Future<void> addLinkToCourseSegment(String courseCode, String segmentCode, String link)async {
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'linkURLs': FieldValue.arrayUnion([link]),
      });
    }

    Future<void> removeLinkFromCourseSegment(String courseCode, String segmentCode, String link)async {
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'linkURLs': FieldValue.arrayRemove([link]),
      });
    }

    Future<List<Document>> getCourseSegmentDocuments(Segment segment) async {

      var documents = segment.documents.map((d) => Document.fromJson(d));
      return documents.toList();
    }


    Future<int> getCourseSegmentsLength(String courseCode) async {

      var ref = _db.collection('courses').doc(courseCode).collection('segments');
      var snapshot = await ref.get();
      var length = snapshot.docs.length;
      return length;
    }

    Future<void> addQuizModelToCourseSegment(String courseCode, String segmentCode, QuizSegmentModel quizModel)async {
      Map<String, dynamic> data = quizModel.toJson();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'quizSegmentModels': FieldValue.arrayUnion([data]),
      });
    }

    Future<void> removeQuizModelFromCourseSegment(String courseCode, String segmentCode, QuizSegmentModel quizModel)async {

      //Remove quiz with questions
      QuizService().removeQuiz(quizModel.quizID);

      //Remove model
      Map<String, dynamic> data = quizModel.toJson();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'quizSegmentModels': FieldValue.arrayRemove([data]),
      });

      //Remove quiz mark
      var studentIDs = await GradeService().getAllStudentIDsWithSpecificActivityMark(courseCode, segmentCode, quizModel.quizID);
      if(studentIDs.isNotEmpty){
        for(var studentID in studentIDs){
          GradeService().deleteActivityMark(studentID, courseCode, segmentCode, quizModel.quizID);
        }
      }
    }


    Future<void> updateQuizModels(String courseCode, String segmentCode, List<QuizSegmentModel> quizModel)async {

      List<Map<String, dynamic>> data = quizModel.map((d) => d.toJson()).toList();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'quizSegmentModels': data,
      });
    }




    //Homeworks models


    Future<void> addHomeworkModelToCourseSegment(String courseCode, String segmentCode, HomeworkSegmentModel homeworkSegmentModel)async {
      Map<String, dynamic> data = homeworkSegmentModel.toJson();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'homeworkSegmentModels': FieldValue.arrayUnion([data]),
      });
    }

    Future<void> removeHomeworkModelFromCourseSegment(String courseCode, String segmentCode, HomeworkSegmentModel homeworkSegmentModel)async {

      //Remove homework
      HomeworkService().removeHomework(homeworkSegmentModel.homeworkID);

      //Remove model from segment
      Map<String, dynamic> data = homeworkSegmentModel.toJson();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'homeworkSegmentModels': FieldValue.arrayRemove([data]),
      });

      //Remove homework mark
      var studentIDs = await GradeService().getAllStudentIDsWithSpecificActivityMark(courseCode, segmentCode, homeworkSegmentModel.homeworkID);
      if(studentIDs.isNotEmpty){
        for(var studentID in studentIDs){
          GradeService().deleteActivityMark(studentID, courseCode, segmentCode, homeworkSegmentModel.homeworkID);
        }
      }

      //Remove event
      CalendarService().removeEventForAllClients(homeworkSegmentModel.homeworkID);
    }

    Future<void> updateHomeworkModels(String courseCode, String segmentCode, List<HomeworkSegmentModel> homeworkModels)async {

      List<Map<String, dynamic>> data = homeworkModels.map((d) => d.toJson()).toList();
      var ref = collectionReference.doc(courseCode).collection('segments').doc(segmentCode);
      ref.update({
        'homeworkSegmentModels': data,
      });
    }




  }

