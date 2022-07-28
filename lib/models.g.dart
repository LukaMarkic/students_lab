// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileUser _$ProfileUserFromJson(Map<String, dynamic> json) => ProfileUser(
      name: json['name'] as String? ?? 'Name',
      surname: json['surname'] as String? ?? 'Surname',
      birthDate: DateTime.parse(json['birthDate'] as String),
      token: json['token'] as String?,
      imgURL: json['imgURL'] as String?,
      id: json['id'] as String? ?? 'XXX',
    );

Map<String, dynamic> _$ProfileUserToJson(ProfileUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'birthDate': instance.birthDate.toIso8601String(),
      'token': instance.token,
      'imgURL': instance.imgURL,
      'id': instance.id,
    };

ProfileStudent _$ProfileStudentFromJson(Map<String, dynamic> json) =>
    ProfileStudent(
      name: json['name'] as String? ?? 'Name',
      surname: json['surname'] as String? ?? 'Surname',
      birthDate: DateTime.parse(json['birthDate'] as String),
      godinaStudija: json['godinaStudija'] as int? ?? 1,
      token: json['token'] as String?,
      imgURL: json['imgURL'] as String?,
      id: json['id'] as String? ?? 'XXX',
      enrolledCoursesCodes: (json['enrolledCoursesCodes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      collectiveGrade: (json['collectiveGrade'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProfileStudentToJson(ProfileStudent instance) =>
    <String, dynamic>{
      'birthDate': instance.birthDate.toIso8601String(),
      'imgURL': instance.imgURL,
      'name': instance.name,
      'surname': instance.surname,
      'id': instance.id,
      'token': instance.token,
      'godinaStudija': instance.godinaStudija,
      'enrolledCoursesCodes': instance.enrolledCoursesCodes,
      'collectiveGrade': instance.collectiveGrade,
    };

ProfileProfessor _$ProfileProfessorFromJson(Map<String, dynamic> json) =>
    ProfileProfessor(
      name: json['name'] as String? ?? 'Name',
      surname: json['surname'] as String? ?? 'Surname',
      birthDate: DateTime.parse(json['birthDate'] as String),
      imgURL: json['imgURL'] as String?,
      token: json['token'] as String?,
      assignedCoursesCodes: (json['assignedCoursesCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      id: json['id'] as String? ?? 'XXX',
    );

Map<String, dynamic> _$ProfileProfessorToJson(ProfileProfessor instance) =>
    <String, dynamic>{
      'birthDate': instance.birthDate.toIso8601String(),
      'name': instance.name,
      'surname': instance.surname,
      'imgURL': instance.imgURL,
      'id': instance.id,
      'token': instance.token,
      'assignedCoursesCodes': instance.assignedCoursesCodes,
    };

ProfileAdmin _$ProfileAdminFromJson(Map<String, dynamic> json) => ProfileAdmin(
      name: json['name'] as String? ?? 'Name',
      surname: json['surname'] as String? ?? 'Surname',
      birthDate: DateTime.parse(json['birthDate'] as String),
      sec_key: json['sec_key'] as String? ?? 'XXXXXX',
      imgURL: json['imgURL'] as String?,
      token: json['token'] as String?,
      id: json['id'] as String? ?? 'XXX',
    );

Map<String, dynamic> _$ProfileAdminToJson(ProfileAdmin instance) =>
    <String, dynamic>{
      'birthDate': instance.birthDate.toIso8601String(),
      'imgURL': instance.imgURL,
      'name': instance.name,
      'surname': instance.surname,
      'id': instance.id,
      'token': instance.token,
      'sec_key': instance.sec_key,
    };

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      title: json['title'] as String? ?? 'Course',
      ECTS: (json['ECTS'] as num?)?.toDouble() ?? 0,
      imgURL: json['imgURL'] as String?,
      color: json['color'] as int? ?? 0Xff0000FF,
      code: json['code'] as String,
      semester: json['semester'] as int? ?? 1,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'title': instance.title,
      'ECTS': instance.ECTS,
      'imgURL': instance.imgURL,
      'color': instance.color,
      'code': instance.code,
      'semester': instance.semester,
    };

Segment _$SegmentFromJson(Map<String, dynamic> json) => Segment(
      title: json['title'] as String? ?? 'Segment',
      code: json['code'] as String? ?? '0_XXX',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
      linkURLs: (json['linkURLs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      quizSegmentModels: (json['quizSegmentModels'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      homeworkSegmentModels: (json['homeworkSegmentModels'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'title': instance.title,
      'code': instance.code,
      'linkURLs': instance.linkURLs,
      'documents': instance.documents,
      'quizSegmentModels': instance.quizSegmentModels,
      'homeworkSegmentModels': instance.homeworkSegmentModels,
    };

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      name: json['name'] as String? ?? 'Document',
      URL: json['URL'] as String,
      extension: json['extension'] as String? ?? 'pdf',
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'name': instance.name,
      'URL': instance.URL,
      'extension': instance.extension,
    };

QuizSegmentModel _$QuizSegmentModelFromJson(Map<String, dynamic> json) =>
    QuizSegmentModel(
      title: json['title'] as String? ?? '',
      quizID: json['quizID'] as String? ?? '',
      isVisible: json['isVisible'] as bool? ?? false,
    );

Map<String, dynamic> _$QuizSegmentModelToJson(QuizSegmentModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'quizID': instance.quizID,
      'isVisible': instance.isVisible,
    };

HomeworkSegmentModel _$HomeworkSegmentModelFromJson(
        Map<String, dynamic> json) =>
    HomeworkSegmentModel(
      title: json['title'] as String? ?? '',
      homeworkID: json['homeworkID'] as String? ?? '',
      isVisible: json['isVisible'] as bool? ?? false,
    );

Map<String, dynamic> _$HomeworkSegmentModelToJson(
        HomeworkSegmentModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'homeworkID': instance.homeworkID,
      'isVisible': instance.isVisible,
    };

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      id: json['id'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      segmentCode: json['segmentCode'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      duration: json['duration'] as int? ?? 60,
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'id': instance.id,
      'courseCode': instance.courseCode,
      'segmentCode': instance.segmentCode,
      'title': instance.title,
      'description': instance.description,
      'duration': instance.duration,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      quizID: json['quizID'] as String? ?? '',
      questionField: json['questionField'] as String? ?? '',
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'quizID': instance.quizID,
      'questionField': instance.questionField,
      'answers': instance.answers,
    };

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      answer: json['answer'] as String? ?? '',
      isRight: json['isRight'] as bool? ?? false,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'answer': instance.answer,
      'isRight': instance.isRight,
    };

Homework _$HomeworkFromJson(Map<String, dynamic> json) => Homework(
      id: json['id'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      segmentCode: json['segmentCode'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      documentURL: json['documentURL'] as String?,
      deadline: DateTime.parse(json['deadline'] as String),
    );

Map<String, dynamic> _$HomeworkToJson(Homework instance) => <String, dynamic>{
      'id': instance.id,
      'courseCode': instance.courseCode,
      'segmentCode': instance.segmentCode,
      'title': instance.title,
      'description': instance.description,
      'documentURL': instance.documentURL,
      'deadline': instance.deadline.toIso8601String(),
    };

SubmittedHomework _$SubmittedHomeworkFromJson(Map<String, dynamic> json) =>
    SubmittedHomework(
      studentID: json['studentID'] as String? ?? '',
      studentFullName: json['studentFullName'] as String? ?? '',
      homeworkID: json['homeworkID'] as String? ?? '',
      feedback: json['feedback'] as String? ?? '',
      documentURL: json['documentURL'] as String? ?? '',
      timeOfSubmit: json['timeOfSubmit'] == null
          ? null
          : DateTime.parse(json['timeOfSubmit'] as String),
      graded: json['graded'] as bool? ?? false,
    );

Map<String, dynamic> _$SubmittedHomeworkToJson(SubmittedHomework instance) =>
    <String, dynamic>{
      'studentID': instance.studentID,
      'studentFullName': instance.studentFullName,
      'homeworkID': instance.homeworkID,
      'feedback': instance.feedback,
      'documentURL': instance.documentURL,
      'timeOfSubmit': instance.timeOfSubmit?.toIso8601String(),
      'graded': instance.graded,
    };

SubmittedHomeworkListModel _$SubmittedHomeworkListModelFromJson(
        Map<String, dynamic> json) =>
    SubmittedHomeworkListModel(
      submittedHomework: SubmittedHomework.fromJson(
          json['submittedHomework'] as Map<String, dynamic>),
      studentFullName: json['studentFullName'] as String? ?? '',
      grade: (json['grade'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SubmittedHomeworkListModelToJson(
        SubmittedHomeworkListModel instance) =>
    <String, dynamic>{
      'submittedHomework': instance.submittedHomework,
      'studentFullName': instance.studentFullName,
      'grade': instance.grade,
    };

CourseGrade _$CourseGradeFromJson(Map<String, dynamic> json) => CourseGrade(
      courseCode: json['courseCode'] as String? ?? '',
      studentID: json['studentID'] as String? ?? '',
      finalGrade: (json['finalGrade'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CourseGradeToJson(CourseGrade instance) =>
    <String, dynamic>{
      'courseCode': instance.courseCode,
      'studentID': instance.studentID,
      'finalGrade': instance.finalGrade,
    };

SegmentMark _$SegmentMarkFromJson(Map<String, dynamic> json) => SegmentMark(
      segmentCode: json['segmentCode'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      mark: (json['mark'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SegmentMarkToJson(SegmentMark instance) =>
    <String, dynamic>{
      'segmentCode': instance.segmentCode,
      'courseCode': instance.courseCode,
      'mark': instance.mark,
    };

ActivityMark _$ActivityMarkFromJson(Map<String, dynamic> json) => ActivityMark(
      activityID: json['activityID'] as String? ?? '',
      segmentID: json['segmentID'] as String? ?? '',
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 100,
      achievedScore: (json['achievedScore'] as num?)?.toDouble() ?? 0,
      mark: (json['mark'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ActivityMarkToJson(ActivityMark instance) =>
    <String, dynamic>{
      'activityID': instance.activityID,
      'segmentID': instance.segmentID,
      'maxScore': instance.maxScore,
      'achievedScore': instance.achievedScore,
      'mark': instance.mark,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String? ?? '',
      day: DateTime.parse(json['day'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      backgroundColor: json['backgroundColor'] as int? ?? 0xff26F611,
      courseCode: json['courseCode'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'day': instance.day.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'backgroundColor': instance.backgroundColor,
      'courseCode': instance.courseCode,
    };
