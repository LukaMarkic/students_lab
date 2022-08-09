
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/courseService.dart';


class GradeService {


  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference studentUsersCollectionReference = FirebaseFirestore
      .instance.collection('studentUsers');

  Future<void> addActivityMark(String studentID, String courseID, ActivityMark activityMark) async {

    if (activityMark.maxScore == 0) {activityMark.maxScore = 100;}

    activityMark.mark = activityMark.achievedScore / activityMark.maxScore;
    Map<String, dynamic> activityMarkData = activityMark.toJson();
    studentUsersCollectionReference.doc(studentID).collection('courseGrades').doc(courseID).collection('segmentMarks').doc(activityMark.segmentID)
        .collection('activityGrades').doc(activityMark.activityID).set(activityMarkData);

    double? segmentFinalMark = await getAverageActivityMark(studentID, courseID, activityMark.segmentID);
    var segmentMark = SegmentMark(segmentCode: activityMark.segmentID, courseCode: courseID, mark: segmentFinalMark);
    Map<String, dynamic> segmentMarkData = segmentMark.toJson();
    studentUsersCollectionReference.doc(studentID).collection('courseGrades').doc(courseID).collection('segmentMarks').doc(activityMark.segmentID).set(segmentMarkData);

    double? courseMark = await getAverageSegmentsMark(studentID, courseID);
    var courseGrade = CourseGrade(courseCode: courseID, studentID: studentID, finalGrade: courseMark);
    Map<String, dynamic> courseGradeData = courseGrade.toJson();
    studentUsersCollectionReference.doc(studentID).collection('courseGrades').doc(courseID).update(courseGradeData);


    double? studentGrade = await getAverageCoursesGrade(studentID);
    studentUsersCollectionReference.doc(studentID).update({
      'collectiveGrade': studentGrade,
    });


  }



  Future<void> deleteActivityMark(String studentID, String courseCode, String segmentCode, String activityID) async {

    var docRef = studentUsersCollectionReference.doc(studentID).collection('courseGrades').doc(courseCode).collection('segmentMarks').doc(segmentCode).collection(
        'activityGrades').doc(activityID);
    var doc = await docRef.get();

    if(doc.exists){
      docRef.delete();
      double? segmentFinalMark = await getAverageActivityMark(studentID, courseCode, segmentCode);
      var segmentMark = SegmentMark(segmentCode: segmentCode, courseCode: courseCode, mark: segmentFinalMark);
      Map<String, dynamic> segmentMarkData = segmentMark.toJson();
      studentUsersCollectionReference.doc(studentID).collection('courseGrades').doc(courseCode).collection('segmentMarks').doc(segmentCode).set(segmentMarkData);

      double? courseMark = await getAverageSegmentsMark(studentID, courseCode);
      var courseGrade = CourseGrade(courseCode: courseCode, studentID: studentID, finalGrade: courseMark);
      Map<String, dynamic> courseGradeData = courseGrade.toJson();
      studentUsersCollectionReference.doc(studentID).collection('courseGrades').doc(courseCode).update(courseGradeData);

      double? studentGrade = await getAverageCoursesGrade(studentID);
      studentUsersCollectionReference.doc(studentID).update({
        'collectiveGrade': studentGrade,
      });
    }

  }

  Future<void> setGrade(CourseGrade courseGrade) async {
    Map<String, dynamic> courseData = courseGrade.toJson();
    studentUsersCollectionReference.doc(courseGrade.studentID).collection(
        'courseGrades').doc(courseGrade.courseCode).set(courseData);
  }

  Future<void> deleteGrade(String studentID, String courseCode) async {
    studentUsersCollectionReference.doc(studentID)
        .collection('courseGrades')
        .doc(courseCode)
        .delete();
  }

  Future<ActivityMark?> checkIsQuizFinishedAnReturnResults(String studentID,
      String courseCode, String segmentCode, String quizID) async {
    var ref = _db.collection('studentUsers').doc(studentID).collection(
        'courseGrades').doc(courseCode).collection('segmentMarks').doc(
        segmentCode).collection('activityGrades');
    var doc = await ref.doc(quizID).get();
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();
      return ActivityMark.fromJson(data!);
    } else {
      return null;
    }
  }


  Future<double?> getActivityMark(String studentID, String courseID,
      String segmentID, String activityID) async {
    var ref = _db.collection('studentUsers').doc(studentID).collection(
        'courseGrades').doc(courseID).collection('segmentMarks')
        .doc(segmentID)
        .collection('activityGrades');
    var snapshot = await ref.doc(activityID).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      var activityGrade = data['mark'] as double;
      return activityGrade;
    } else {
      return null;
    }
  }

  Future<double?> getSegmentMark(String studentID, String courseID, String segmentID) async {
    var ref = _db.collection('studentUsers').doc(studentID).collection('courseGrades').doc(courseID).collection('segmentMarks');
    var snapshot = await ref.doc(segmentID).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      var segmentMark = data['mark'];
      return segmentMark;
    } else {
      return null;
    }
  }

  Future<double?> getCourseGrade(String studentID, String courseID) async {
    var ref = _db.collection('studentUsers').doc(studentID).collection('courseGrades');
    var snapshot = await ref.doc(courseID).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      var courseGrade = data['finalGrade'];
      if(courseGrade != null) {
        return courseGrade;
      }
      return null;
    } else {
      return null;
    }
  }



  //Average scores

  Future<double?> getAverageActivityMark(String studentID, String courseID,
      String segmentID) async {
    double sum = 0;
    var ref = _db.collection('studentUsers').doc(studentID).collection(
        'courseGrades').doc(courseID).collection('segmentMarks')
        .doc(segmentID)
        .collection('activityGrades');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var activityMarks = data.map((d) => ActivityMark.fromJson(d)).toList();

    if (activityMarks.isEmpty) {
      return null;
    } else {
      int length = 0;
      activityMarks.forEach((activityMark) {
        if(activityMark.mark != null){
          sum += activityMark.mark!;
          length++;
        }
      });
      if(length == 0){
        return null;
      }else{
        return sum / length;
      }
    }
  }



  Future<double?> getAverageSegmentsMark(String studentID,
      String courseID) async {
    double sum = 0;
    var ref = _db.collection('studentUsers').doc(studentID).collection(
        'courseGrades').doc(courseID).collection('segmentMarks');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var segmentMarks = data.map((d) => SegmentMark.fromJson(d)).toList();

    if (segmentMarks.isEmpty) {
      return null;
    } else {
      int length = 0;
      for(var segmentMark in segmentMarks){
        if(segmentMark.mark != null){
          sum += segmentMark.mark!;
          length++;
        }
      };
      if(length == 0){
        return null;
      }else{
        return sum / length;
      }

    }
  }


  Future<double?> getAverageCoursesGrade(String studentID) async {
    double sum = 0;
    var ref = _db.collection('studentUsers').doc(studentID).collection(
        'courseGrades');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var courseGrades = data.map((d) => CourseGrade.fromJson(d)).toList();

    if (courseGrades.isEmpty) {
      return null;
    } else {
      int length = 0;
      for(var courseGrade in courseGrades){
        if(courseGrade.finalGrade != null){
          sum += courseGrade.finalGrade!;
          length++;
        }

      }
      if(length == 0){
        return null;
      }else{
        return sum / length;
      }
    }
  }


  Future<double?> getAverageEnrolledStudentsGrade(List<String> courseCodes) async {

    double sum = 0;
    int length = 0;
    List<ProfileStudent>? students = await CourseService().getAllStudentEnrolledInCourses(courseCodes);
    if(students != null){
      for(var student in students){
        if(student.collectiveGrade != null){
          sum += student.collectiveGrade!;
          length++;
        }
      }
      if(length == 0){
        return null;
      }else{
        return sum / length;
      }
    }else{
      return null;
    }
  }

  Future<double?> getAverageEnrolledStudentsCourseGrade(String courseCode) async {

    double sum = 0;
    var students = await CourseService().getAllStudentEnrolledInCourses(<String>[courseCode]);
    if(students != null){
      int length = 0;
      for(var student in students){
        final grade = await getCourseGrade(student.id, courseCode);
        if(grade != null){
          sum += grade;
          length++;
        }
      }
      if(length == 0){
        return null;
      }else{
        return sum / length;
      }
    }else{
      return null;
    }

  }


  Future<double?> getAverageEnrolledStudentsSegmentMark(String courseCode, String segmentCode) async {

    double sum = 0;
    var students = await CourseService().getAllStudentEnrolledInCourses(<String>[courseCode]);
    if(students != null){
      int length = 0;
      for(var student in students){
        final mark = await getSegmentMark(student.id, courseCode, segmentCode);
        if(mark != null){
          sum += mark;
          length++;
        }
      }
      if(length == 0){
        return null;
      }else{
        return sum / length;
      }
    }else{
      return null;
    }

  }




  Future<List<String>> getAllStudentIDsWithSpecificActivityMark( String courseCode, String segmentCode, String activityID) async {

    List<String> result = <String>[];

    var ref = _db.collection('studentUsers');
    var snapshot = await ref.get();
    var studentDocuments = snapshot.docs;

    for(var studentDocument in studentDocuments){
      var ref = _db.collection('studentUsers').doc(studentDocument.id).collection('courseGrades').doc(courseCode).collection('segmentMarks').doc(segmentCode).collection('activityGrades');
      var doc = await ref.doc(activityID).get();
      if (doc.exists) {
        result.add(studentDocument.id);
      }
    }


    return result;
  }

  Future<List<CourseGradeSegment>> getCourseGradeSegments(List<String> courseGradeCodes) async{

    List<CourseGradeSegment> courseGradeSegments = <CourseGradeSegment>[];

    for(var courseGradeCode in courseGradeCodes){
      var courseGrade = await getCourseGrade(AuthService().user!.uid, courseGradeCode);
      if(courseGrade != null){
        var averageCourseGrade = await getAverageEnrolledStudentsCourseGrade(courseGradeCode);
        var course = await CourseService().getCourseData(courseGradeCode);
        var title = course.title;
        var segmentMarkTiles = await getCourseSegmentMarksTiles(courseGradeCode);
        courseGradeSegments.add(CourseGradeSegment(code: courseGradeCode, title: title, courseGrade: courseGrade, averageCourseGrade: averageCourseGrade, segmentMarkTiles: segmentMarkTiles));
      }
    }

    return courseGradeSegments;
  }

  Future<List<SegmentMarkTile>> getCourseSegmentMarksTiles(String courseGradeCode) async{

    List<SegmentMarkTile> segmentMarkTiles = <SegmentMarkTile>[];
    final segments = await CourseService().getCourseSegments(courseGradeCode);
    for(var segment in segments){
      var code = segment.code;
      var title = segment.title;
      var segmentMark = await getSegmentMark(AuthService().user!.uid, courseGradeCode, code);
      var averageSegmentMark = await getAverageEnrolledStudentsSegmentMark(courseGradeCode, code);
      segmentMarkTiles.add(SegmentMarkTile(code: code, title: title, segmentMark: segmentMark, averageSegmentMark: averageSegmentMark));
    }

    return segmentMarkTiles;
  }





}



