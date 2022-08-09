
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/widgets/alertWindow.dart';
import 'package:students_lab/widgets/backgroundImageWidget.dart';
import '../../../models.dart';
import '../../../services/database/courseService.dart';
import '../../../services/database/quizService.dart';
import '../../../shared/methods/navigationMethods.dart';
import '../../../shared/methods/stringManipulationMethods.dart';
import '../../../shared/methods/ungroupedSharedMethods.dart';
import '../../../widgets/buttons/addButtonWidget.dart';
import '../../../widgets/inputs/roundedDoubleInput.dart';
import '../../../widgets/inputs/roundedInput.dart';
import '../../course/courseScreen/courseScreen.dart';
import '../quizPreview.dart';
import 'questionForm.dart';

class QuizFormSteps extends StatefulWidget {

  String courseCode;
  String segmentCode;
  QuizFormSteps({Key? key,
    this.courseCode = '',
    this.segmentCode = '',
  }) : super(key: key);


  @override
  State<QuizFormSteps> createState() => _QuizFormStepsState();
}

class _QuizFormStepsState extends State<QuizFormSteps> {

  List<QuestionForm> questions = List.empty(growable: true);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _index = 0;
  late Quiz quiz = Quiz(courseCode: widget.courseCode, segmentCode: widget.segmentCode,);

  List<Step> stepList() => <Step>[
    Step(
      state: _index <= 0 ? StepState.editing : StepState.complete,
      isActive: _index >= 0,
      title: const Text('Opis'),
      content: quizDescriptionForm(),
    ),
     Step(
       state: _index <= 1 ? StepState.editing : StepState.complete,
       isActive: _index >= 1,
      title: Text('Pitanja'),
      content: questionForms()
    ),
     Step(
       state: _index <= 2 ? StepState.editing : StepState.complete,
       isActive: _index >= 2,
      title: Text('Potvrda'),
      content: QuizPreviewScreen(quiz: quiz, questions: QuizService().getQuestionsFromQuestionForm(questions),) ,
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: exitAlert,
        child: Scaffold(
        appBar: AppBar(title: Text('Kviz obrazac'),),
        body:
        BackgroundImageWidget(imagePath: 'assets/images/quiz-background.jpg',
          padding: EdgeInsets.all(0),
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails details){
              return Container(
                child: Row(
                  children: [
                    TextButton(onPressed: details.onStepContinue, child: Text(_index < 2 ? 'Nastavi' : 'Predaj', style: TextStyle(color: Colors.black),),
                      style: buttonStepperStyleContinue,
                    ),
                    Container(width: 15,),
                    _index > 0 ? TextButton(onPressed: details.onStepCancel, child: Text('Nazad', style: TextStyle(color: Colors.black)),
                      style: buttonStepperStyleBack,) : Text(''),
                  ],
                ),
              );
            },
      type: StepperType.horizontal,
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (_index < (stepList().length - 1)) {
          if(_index == 0) {
            nextPage();
          }else if(_index == 1){
            finalPage();
          }
          else{
            setState(() {
              _index += 1;
            });
          }
        }else if(_index >= 2){
          submitQuiz();
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: stepList(),
    ),),),);
  }

  void nextPage(){
    if(validateDescription()){
      setState(() {
        _index += 1;
      });
    }
  }

  void finalPage(){
    if (questions.length > 0) {
      if(!QuizService().checkIfTwoQuestionAnswers(QuizService().getQuestionsFromQuestionForm(questions))){
        Fluttertoast.showToast(msg: 'Potrebno unijeti najmanje dva odgovora');
      }else{
        var allValid = isAllQuestionFormsValidated();
        if(allValid){
          setState(() {
            _index += 1;
          });
      }
    }
    }else{
      showScaffoldMessage(context: context, message: 'Potrebno je unijeti barem jedno pitanje.');
    }
  }



  void submitQuiz(){
    showAlertWindow(context, 'Želite li spremiti kviz', submitPress);
  }

  void submitPress () async {
    var quizID = await QuizService().addQuizData(quiz);
    if(quizID != null){

      //Model form course segments
      QuizSegmentModel quizModel = QuizSegmentModel(quizID: quizID, title: quiz.title);
      CourseService().addQuizModelToCourseSegment(widget.courseCode, widget.segmentCode, quizModel);

      //Adding questions to quiz
      for(var element in questions){
        element.question.quizID = quizID;
        await QuizService().addQuestionToQuiz(element.question);
      }

      //Go to course
      var segments = await CourseService().getCourseSegments(widget.courseCode);
      var course = await CourseService().getCourseData(widget.courseCode);
      goToPageWithLastPop(context: context, page: CourseScreen(course: course, segments: segments,));

    }else{
      Fluttertoast.showToast(msg: "Kviz nije stvoren!", fontSize: 12,);
    }
  }


  Widget quizDescriptionForm(){

    var size = MediaQuery.of(context).size;
    return SingleChildScrollView( child:
    Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 20,),
            RoundedInputField(
              validatorMessage: 'Potrijebno unijeti naziv kviza',
              borderRadius: 5,
              icon: Icons.title,
              hintText: "Unesite naziv kviza",
              onChanged: (value) {
                setState(
                        () => quiz.title = value
                );
              },
            ),
            SizedBox(height: 10,),
            RoundedInputField(
              validatorMessage: 'Potrijebno unijeti opis kviza',
              borderRadius: 5,
              color: Colors.white,
              icon: Icons.description,
              hintText: "Unesite opis kviza",
              onChanged: (value) {
                setState(
                        () => quiz.description = value
                );
              },
            ),
            SizedBox(height: 5,),
            RoundedDoubleInputField(
              icon: Icons.timelapse_outlined,
              hintText: "Unesite trajanje kviza [sekunde]",
              onChanged: (value) {
                setState(
                        () => quiz.duration = int.parse(value)
                );
              },
            ),
            SizedBox(height: size.height * 0.1,),
          ],),),
    ),
    );
  }

  bool validateDescription() {
    //Validate Form Fields by form key
    bool validate = formKey.currentState!.validate();
    if (validate) formKey.currentState?.save();
    return validate;
  }

  Widget questionForms(){
    return SingleChildScrollView( child:
    Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: questions.length <= 0 ?
          Center(
            child:
                Material(
                  elevation: 1,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8),
                shadowColor: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Potrebno dodati pitanje', style: TextStyle( color: Colors.amber, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),),
                ),
              )
              : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: questions.length,
            itemBuilder: (_, i) {
              questions[i].index = i+1;
              questions[i].question.index = i;
              return questions[i];
            } ,
          ),
        ),
        AddButton(message: 'Dodaj pitanje', onPress: onAddForm,buttonColor: Colors.greenAccent, contentColor: Colors.black87,),
        SizedBox(height: 20,),
      ],),
    );
  }

  void onDelete(Question _question) {
    setState(() {
      int index = questions
          .indexWhere((element) => element.question.id == _question.id);
      if (questions.isNotEmpty) {
        questions.removeAt(index);
      }
    });
  }

  void onAddForm() {

    setState(() {
      var rand = getRandomString(8);
      List<Map<String, dynamic>> answers = <Map<String, dynamic>>[Answer().toJson(), Answer().toJson()];
      var _question = Question(id: rand, index: questions.length, answers: answers);
      questions.add(QuestionForm(
        index: questions.length,
        question: _question,
        onRemove: () => onDelete(_question),
      ));
    });
  }


  bool isAllQuestionFormsValidated(){
    var allValid = true;
    questions.forEach((element) => allValid = (allValid && element.isValidated()));
    return allValid;
  }





  Future<bool> exitAlert () async {
    FocusScope.of(context).unfocus();
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Želite li napustiti obrazac?'),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: buttonStepperStyleContinue,
              child: const Text('Da', style: TextStyle(color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);

              },
              child: const Text('Ne', style: TextStyle(color: Colors.black)),
              style: buttonStepperStyleBack,
            ),
          ],
        );
      },
    );
    return shouldPop!;
  }


}

