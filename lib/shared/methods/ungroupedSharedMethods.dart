
import 'package:flutter/material.dart';
import 'package:students_lab/services/database/courseService.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/services/database/homeworkService.dart';
import 'package:students_lab/services/database/profileService.dart';
import '../../constants.dart';
import '../../models.dart';




//Segments

bool ifDefaultSegment(String segmentCode){

  int i = 0;
  while( i != defaultSegments.length){
    if(defaultSegments[i].code == segmentCode) {
      return true;
    }
      i++;
  }
  return false;
}



//Scaffold

void showScaffoldMessage({context, message}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)));
}



//Number calculation

double roundToSecondDecimal(double value){
 return double.parse((value).toStringAsFixed(2));
}



//Student directory (Imenik)

Future<List<CourseStudentDirectoryModel>> getCourseStudentDirectoryModels(List<String> courseCodes, String studentID) async{

  CourseService courseService = CourseService();
  GradeService gradeService = GradeService();

  List<CourseStudentDirectoryModel> courseModels = [];
  for(var courseCode in courseCodes){

    double? courseGrade = await gradeService.getCourseGrade(studentID, courseCode);
    String courseTitle = await courseService.getCourseTitle(courseCode);

    CourseStudentDirectoryModel courseStudentDirectoryModel = CourseStudentDirectoryModel(courseCode: courseCode, studentID: studentID, courseGrade: courseGrade, title: courseTitle, segmentModels: []);

    List<Segment> segments = await courseService.getCourseSegments(courseCode);

    for(var segment in segments){
      double? segmentMark = await gradeService.getSegmentMark(studentID, courseCode, segment.code);
      SegmentStudentDirectoryModel segmentStudentDirectoryModel = SegmentStudentDirectoryModel(segmentCode: segment.code,
          courseCode: courseCode, title: segment.title, segmentMark: segmentMark, activityModels: [], isExtended: false);

      if(segment.homeworkSegmentModels != null){
        for (var model in segment.homeworkSegmentModels!) {
          var homeworkModel = HomeworkSegmentModel.fromJson(model);
          bool isSubmitted = await HomeworkService().isSubmitted(studentID, homeworkModel.homeworkID);
          double? activityMark = await gradeService.getActivityMark(studentID, courseCode, segment.code, homeworkModel.homeworkID);
          ActivityStudentDirectoryModel activityStudentDirectoryModel = ActivityStudentDirectoryModel(
              activityCode: homeworkModel.homeworkID, title: homeworkModel.title, activityType: ActivityType.homework, isSubmitted: isSubmitted, mark: activityMark);
          segmentStudentDirectoryModel.activityModels.add(activityStudentDirectoryModel);
        }
      }
      if(segment.quizSegmentModels != null){
        for (var model in segment.quizSegmentModels!) {
          var quizModel = QuizSegmentModel.fromJson(model);
          double? activityMark = await gradeService.getActivityMark(studentID, courseCode, segment.code, quizModel.quizID);
          bool isTaken = (activityMark != null);
          ActivityStudentDirectoryModel activityStudentDirectoryModel = ActivityStudentDirectoryModel(
            activityCode: quizModel.quizID, title: quizModel.title, mark: activityMark, activityType: ActivityType.quiz, isSubmitted: isTaken);
          segmentStudentDirectoryModel.activityModels.add(activityStudentDirectoryModel);
        }
      }
      if(segmentStudentDirectoryModel.activityModels.isNotEmpty) courseStudentDirectoryModel.segmentModels.add(segmentStudentDirectoryModel);
    }
    courseModels.add(courseStudentDirectoryModel);
  }
  return courseModels;
}




//Professor statistic preview

Future<ProfessorCourseAchievementModel> getProfessorCourseAchievementModel(String courseCode)async{

  double bestGrade = 0;
  double averageGrade = await GradeService().getAverageEnrolledStudentsCourseGrade(courseCode) ?? 0;
  ProfileStudent? bestStudent = await ProfileService().getStudentWithBestMark(courseCode);
  if( bestStudent != null)  bestGrade = await GradeService().getCourseGrade(bestStudent.id, courseCode) ?? 0;
  String title = await CourseService().getCourseTitle(courseCode);
  ProfessorCourseAchievementModel model = ProfessorCourseAchievementModel(
      courseCode: courseCode, title: title, averageGrade: averageGrade, bestGrade: bestGrade, bestStudent: bestStudent);
  return model;
}

