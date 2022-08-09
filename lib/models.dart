
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'constants.dart';

part 'models.g.dart';


@JsonSerializable()
class ProfileUser{
  late String name;
  late String surname;
  late DateTime birthDate;
  late String email;
  String? token;
  String? imgURL;
  String id;

  ProfileUser(
      {
        this.name = 'Name',
        this.surname = 'Surname',
        required this.birthDate,
        this.token,
        this.imgURL,
        this.id = 'XXX',
        this.email = '',
      }
      );

  factory ProfileUser.fromJson(Map<String, dynamic> json) => _$ProfileUserFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileUserToJson(this);
}


@JsonSerializable()
class ProfileStudent implements ProfileUser{

  @override
  DateTime birthDate;

  @override
  String? imgURL;

  @override
  String name;

  @override
  String surname;

  @override
  String id;

  @override
  String? token;

  @override
  String email;

  int godinaStudija;
  List<String> enrolledCoursesCodes;
  double? collectiveGrade;


  ProfileStudent(
      {
        this.name = 'Name',
        this.surname = 'Surname',
        required this.birthDate,
        this.godinaStudija = 1,
        this.token,
        this.imgURL,
        this.id = 'XXX',
        this.enrolledCoursesCodes = const <String>[],
        this.collectiveGrade,
        this.email = '',
      }
      );

  @override
  factory ProfileStudent.fromJson(Map<String, dynamic> json) => _$ProfileStudentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileStudentToJson(this);


}




@JsonSerializable()
class ProfileProfessor implements ProfileUser{

  @override
  DateTime birthDate;

  @override
  String name;

  @override
  String surname;

  @override
  String? imgURL;

  @override
  String id;

  @override
  String? token;

  @override
  String email;

  List<String>? assignedCoursesCodes;


  ProfileProfessor(
      {
        this.name = 'Name',
        this.surname = 'Surname',
        required this.birthDate,
        this.imgURL,
        this.token,
        this.assignedCoursesCodes,
        this.id = 'XXX',
        this.email = '',
      }
      );

  @override
  factory ProfileProfessor.fromJson(Map<String, dynamic> json) => _$ProfileProfessorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileProfessorToJson(this);




}


@JsonSerializable()
class ProfileAdmin implements ProfileUser{

  @override
  DateTime birthDate;

  @override
  String? imgURL;

  @override
  String name;

  @override
  String surname;

  @override
  String id;

  @override
  String? token;

  @override
  String email;

  String sec_key;

  ProfileAdmin(
      {
        this.name = 'Name',
        this.surname = 'Surname',
        required this.birthDate,
        this.sec_key = 'XXXXXX',
        this.imgURL,
        this.token,
        this.id = 'XXX',
        this.email = '',
      }
      );

  @override
  factory ProfileAdmin.fromJson(Map<String, dynamic> json) => _$ProfileAdminFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileAdminToJson(this);




}




@JsonSerializable()
class Course{

  String title;
  double ECTS;
  String? imgURL;
  int color;
  String code;
  int semester;

  Course(
      {
        this.title = 'Course',
        this.ECTS = 0,
        this.imgURL,
        this.color = 0Xff0000FF,
        required this.code,
        this.semester = 1,
      }
      );

  @override
  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}




@JsonSerializable()
class Segment{

  String title;
  String code;
  List<String>? linkURLs;
  List<Map<String, dynamic>> documents;
  List<Map<String, dynamic>>? quizSegmentModels;
  List<Map<String, dynamic>>? homeworkSegmentModels;

  Segment(
      {
        this.title = 'Segment',
        this.code = '0_XXX',
        this.documents = const <Map<String, dynamic>>[],
        this.linkURLs,
        this.quizSegmentModels,
        this.homeworkSegmentModels,
      }
      );

  @override
  factory Segment.fromJson(Map<String, dynamic> json) => _$SegmentFromJson(json);
  Map<String, dynamic> toJson() => _$SegmentToJson(this);
}



@JsonSerializable()
class Document{

  String name;
  String URL;
  String extension;

  Document(
      {
        this.name = 'Document',
        required this.URL,
        this.extension= 'pdf',
      }
      );

  @override
  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}


@JsonSerializable()
class QuizSegmentModel{

  String title;
  String quizID;
  bool isVisible;


  QuizSegmentModel(
      {
        this.title = '',
        this.quizID  ='',
        this.isVisible = false,
      }
      );

  @override
  factory QuizSegmentModel.fromJson(Map<String, dynamic> json) => _$QuizSegmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuizSegmentModelToJson(this);
}


@JsonSerializable()
class HomeworkSegmentModel{

  String title;
  String homeworkID;
  bool isVisible;


  HomeworkSegmentModel(
      {
        this.title = '',
        this.homeworkID  ='',
        this.isVisible = false,
      }
      );

  @override
  factory HomeworkSegmentModel.fromJson(Map<String, dynamic> json) => _$HomeworkSegmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeworkSegmentModelToJson(this);
}



//Quiz and questions


@JsonSerializable()
class Quiz{

  String id;
  String courseCode, segmentCode;
  String title;
  String description;
  int duration;

  Quiz(
      {
        this.id = '',
        this.courseCode = '', this.segmentCode = '',
        this.title = '',
        this.description = '',
        this.duration = 60,
      }
      );

  @override
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}


@JsonSerializable()
class Question{

      String id;
      int index;
      String quizID;
      String questionField;
      List<Map<String, dynamic>> answers;

      Question({
        this.id = '',
        this.index = 0,
        this.quizID = '',
        this.questionField = '',
        this.answers = const <Map<String, dynamic>>[],
      }
      );

@override
factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
Map<String, dynamic> toJson() => _$QuestionToJson(this);
}


@JsonSerializable()
class Answer{

  String answer;
  bool isRight;

  Answer({
    this.answer = '',
    this.isRight = false,
     }
     );

  @override
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}



//Homeworks

@JsonSerializable()
class Homework{

  String id;
  String courseCode;
  String segmentCode;
  String title;
  String description;
  String? documentURL;
  DateTime deadline;

  Homework({
    this.id = '',
    this.courseCode = '',
    this.segmentCode = '',
    this.title = '',
    this.description = '',
    this.documentURL,
    required this.deadline,
  }
  );

@override
factory Homework.fromJson(Map<String, dynamic> json) => _$HomeworkFromJson(json);
Map<String, dynamic> toJson() => _$HomeworkToJson(this);
}



@JsonSerializable()
class SubmittedHomework{

  String studentID;
  String studentFullName;
  String homeworkID;
  String? feedback;
  String? documentURL;
  DateTime? timeOfSubmit;
  bool graded;

  SubmittedHomework({
    this.studentID = '',
    this.studentFullName = '',
    this.homeworkID = '',
    this.feedback = '',
    this.documentURL = '',
    this.timeOfSubmit,
    this.graded = false,
  }
      );

  @override
  factory SubmittedHomework.fromJson(Map<String, dynamic> json) => _$SubmittedHomeworkFromJson(json);
  Map<String, dynamic> toJson() => _$SubmittedHomeworkToJson(this);
}



@JsonSerializable()
class SubmittedHomeworkListModel{

  SubmittedHomework submittedHomework;
  String studentFullName;
  double? grade;


  SubmittedHomeworkListModel({
    required this.submittedHomework,
    this.studentFullName = '',
    this.grade,
  }
      );

  @override
  factory SubmittedHomeworkListModel.fromJson(Map<String, dynamic> json) => _$SubmittedHomeworkListModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubmittedHomeworkListModelToJson(this);
}





//Grades

@JsonSerializable()
class CourseGrade{

  String courseCode;
  String studentID;
  double? finalGrade;


  CourseGrade(
      {
        this.courseCode = '',
        this.studentID = '',
        this.finalGrade,
      }
      );

  @override
  factory CourseGrade.fromJson(Map<String, dynamic> json) => _$CourseGradeFromJson(json);
  Map<String, dynamic> toJson() => _$CourseGradeToJson(this);
}

@JsonSerializable()
class SegmentMark{

  String segmentCode;
  String courseCode;
  double? mark;


  SegmentMark(
      {
        this.segmentCode = '',
        this.courseCode = '',
        this.mark,
      }
      );

  @override
  factory SegmentMark.fromJson(Map<String, dynamic> json) => _$SegmentMarkFromJson(json);
  Map<String, dynamic> toJson() => _$SegmentMarkToJson(this);
}



@JsonSerializable()
class ActivityMark{

  String activityID;
  String segmentID;
  double maxScore;
  double achievedScore;
  double? mark;

  ActivityMark(
      {
        this.activityID = '',
        this.segmentID = '',
        this.maxScore = 100,
        this.achievedScore = 0,
        this.mark,
      }
      );

  @override
  factory ActivityMark.fromJson(Map<String, dynamic> json) => _$ActivityMarkFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityMarkToJson(this);
}





class CourseGradeSegment{

  String code;
  String title;
  double? courseGrade;
  double? averageCourseGrade;
  List<SegmentMarkTile> segmentMarkTiles;

  CourseGradeSegment({
    required this.code,
    required this.title,
    required this.courseGrade,
    required this.averageCourseGrade,
    this.segmentMarkTiles = const [],
});

}


class SegmentMarkTile{

  String code;
  String title;
  double? segmentMark;
  double? averageSegmentMark;

  SegmentMarkTile({
    required this.code,
    required this.title,
    required this.segmentMark,
    required this.averageSegmentMark,
  });

}








@JsonSerializable()
class Event {
  String id;
  final DateTime day;
  final String title;
  final String description;
  final int backgroundColor;
  final String? courseCode;


  Event({
    this.id = '',
    required this.day,
    required this.title,
    required this.description,
    this.backgroundColor = 0xff26F611,
    this.courseCode,
  });

  @override
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

}



@JsonSerializable()
class DirectoryGroupedModel{

  dynamic groupingByElement;
  List<ProfileStudent> students;
  bool isExtended;

  DirectoryGroupedModel({
    this.groupingByElement = '',
    this.students = const [],
    this.isExtended = false,
  });

  @override
  factory DirectoryGroupedModel.fromJson(Map<String, dynamic> json) => _$DirectoryGroupedModelFromJson(json);
  Map<String, dynamic> toJson() => _$DirectoryGroupedModelToJson(this);

}


@JsonSerializable()
class CourseGroupedModel{

  dynamic groupingByElement;
  List<Course> courses;
  bool isExtended;

  CourseGroupedModel({
    this.groupingByElement = '',
    this.courses = const [],
    this.isExtended = false,
  });

  @override
  factory CourseGroupedModel.fromJson(Map<String, dynamic> json) => _$CourseGroupedModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourseGroupedModelToJson(this);

}



class DropdownItem {
  String text;
  final icon;
  final iconCancel;
  bool isActive;

  DropdownItem({
    required this.text,
    required this.icon,
    required this.iconCancel,
    this.isActive = true,
  });
}




//Student directory (Imenik)

class CourseStudentDirectoryModel{

  String title;
  String studentID;
  String courseCode;
  double? courseGrade;
  List<SegmentStudentDirectoryModel> segmentModels;

  CourseStudentDirectoryModel({
    required this.courseCode,
    this.title = '',
    this.studentID = '',
    this.courseGrade,
    this.segmentModels = const [],
  });

}


class SegmentStudentDirectoryModel{
  String segmentCode;
  String courseCode;
  String title;
  double? segmentMark;
  bool isExtended;
  List<ActivityStudentDirectoryModel> activityModels;

  SegmentStudentDirectoryModel({
    required this.segmentCode,
    this.courseCode = '',
    this.segmentMark,
    this.title = '',
    this.isExtended = false,
    this.activityModels = const [],
  });
}


class ActivityStudentDirectoryModel{

  String activityCode;
  String title;
  double? mark;
  ActivityType activityType;
  bool isSubmitted;

  ActivityStudentDirectoryModel({
    required this.activityCode,
    this.title = '',
    this.mark,
    this.activityType = ActivityType.homework,
    this.isSubmitted = false,
  });
}






class ProfessorCourseAchievementModel{

  String courseCode;
  String title;
  double averageGrade;
  double bestGrade;
  ProfileStudent? bestStudent;

  ProfessorCourseAchievementModel({
    required this.courseCode,
    this.title = '',
    this.averageGrade = 0,
    this.bestGrade = 0,
    this.bestStudent,
  });

}