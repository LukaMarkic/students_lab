
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/database/profileService.dart';

import '../../screens/quiz/FormSteps/questionForm.dart';
import 'gradeService.dart';


class QuizService{


  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('quizzes');

  Future<String?> addQuizData(Quiz quiz)async {
    try{

      var ref = collectionReference.doc();
      quiz.id = ref.id;
      Map<String, dynamic> uploadedData = quiz.toJson();
      ref.set(uploadedData);
      return ref.id;
    }
    on FirebaseException catch(e){
      print(e);
      return null;
    }
  }

  Future<Quiz> getQuizData(String quizID) async {

    var ref = _db.collection('quizzes').doc(quizID);
    var snapshot = await ref.get();
    var data = snapshot.data();
    return Quiz.fromJson(data!);
  }

  Future<void> addQuestionToQuiz(Question question)async {
    Map<String, dynamic> uploadedData = question.toJson();
    collectionReference.doc(question.quizID).collection('questions').doc(question.id).set(uploadedData);
  }




  Future<void> removeQuiz(String quizID) async{

    var ref = collectionReference.doc(quizID).collection('questions');
    var snapshot = await ref.get();
    var questions = snapshot.docs;
    for(var question in questions){
      question.reference.delete();
    }
    await collectionReference.doc(quizID).delete();
  }

  Future<void> removeQuestionFromQuiz(String quizID, String questionID) async{

    await collectionReference.doc(quizID).collection('questions').doc(questionID).delete();

  }



  Future<List<Quiz>> getSegmentQuizzes(quizID) async {

    var ref = _db.collection('quizzes');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var quizzesIt = data.map((d) => Quiz.fromJson(d));
    var quizzes = quizzesIt.toList();
    return quizzes.toList();
  }


  Future<List<Question>> getQuestions(String quizID) async {

    var ref = _db.collection('quizzes').doc(quizID).collection('questions');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var questions = data.map((d) => Question.fromJson(d));
    return questions.toList();
  }



  Future<void> deleteActivityMarkOfStudentsEnrolledInCourse(String courseCode, String segmentCode, String activityID) async {
    List<ProfileStudent> allStudents = await ProfileService().getAllProfileStudents();
    for(var student in allStudents){
      await GradeService().deleteActivityMark(student.id, courseCode, segmentCode, activityID);
    }
  }



  List<Question> getQuestionsFromQuestionForm(List<QuestionForm> formQuestions){
    var questions = <Question>[];
    for(var formQuestion in formQuestions){
      questions.add(formQuestion.question);
    }
    return questions;
  }


//Provjera jesu li najmamnje dva odgovora
  bool checkIfTwoQuestionAnswers(List<Question> questions){
    var allQuestionAnswerValid = true;
    for (var element in questions) {
      allQuestionAnswerValid = (allQuestionAnswerValid && (element.answers.length >= 2));
    }
    return allQuestionAnswerValid;
  }




}

