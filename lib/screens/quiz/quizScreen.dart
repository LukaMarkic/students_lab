import 'dart:async';
import 'dart:ui';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_lab/constants.dart';
import 'package:students_lab/services/auth.dart';
import 'package:students_lab/services/database/gradeService.dart';
import 'package:students_lab/shared/sharedMethods.dart';
import 'package:students_lab/widgets/roundedButton.dart';
import '../../models.dart';
import '../../services/database/courseService.dart';
import '../course/courseScreen.dart';
import '../frontpage.dart';



class QuizScreen extends StatefulWidget {

  Quiz quiz;
  List<Question> questions;
  QuizScreen({Key? key, required this.quiz, required this.questions}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {


  int question_pos = 0;
  int score = 0;
  int idx = 0;
  bool btnPressed = false;
  PageController? _controller;
  bool answered = false;
  final timeController = CountDownController();
  late Stopwatch _stopwatch;
  int _passedTime = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _stopwatch = new Stopwatch()..start();
    widget.questions.sort((a, b) => a.index.compareTo(b.index));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Timer _timer;
    return Scaffold(
      body:
      Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/quiz-background.jpg"),
        fit: BoxFit.cover,
        ),
        ),
        child:
          BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
          padding: EdgeInsets.only(top: size.height*0.045, left: 8, right: 8),
          color: Colors.black.withOpacity(0.8),
          child: PageView.builder(
            controller: _controller!,
            onPageChanged: (page) {
              setState(() {
                answered = false;
                _passedTime += _stopwatch.elapsed.inSeconds;
                _stopwatch = Stopwatch()..start();
              });
            },
            physics: new NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              List<Answer> answers = widget.questions[index].answers.map((d) => Answer.fromJson(d)).toList();
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 2, right: 6),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${index + 1}/${widget.questions.length}", textAlign: TextAlign.start,
                          style: GoogleFonts.oswald(textStyle: TextStyle(fontSize: size.height*0.045, color: Colors.white60,),
                          ),
                        ),
                        Container(
                          height: size.height*0.1,
                          width: size.height*0.1,
                          child: CountDownProgressIndicator(
                            controller: timeController,
                            valueColor: Colors.redAccent,
                            strokeWidth: 6,
                            backgroundColor: Colors.blueGrey,
                            initialPosition: _passedTime,
                            duration: widget.quiz.duration,
                            onComplete: () => Pressed(),
                            timeTextStyle: TextStyle( fontSize: size.height*0.022, color: Colors.white,),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider( color: Colors.white, thickness: 2.5,),
                  const SizedBox( height: 10.0,),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "${widget.questions[index].questionField}",
                      style: GoogleFonts.oswald(textStyle: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.15,
                  ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          shrinkWrap: true,
                          itemCount: answers.length,
                          itemBuilder: (_, answerIndex) {
                            return Container(
                              width: double.infinity,
                              height: size.height*0.07,
                              margin: const EdgeInsets.only( top: 10.0),

                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                              side: BorderSide(color: Colors.black54)
                                          ),
                                fillColor: btnPressed ? (idx == answerIndex) ? (answers[answerIndex].isRight) ? Colors.green : Colors.red : Colors.white : Colors.white,
                                onPressed: !answered  ? () {
                                  if (answers[answerIndex].isRight) {
                                    score++;
                                  }
                                  idx = answerIndex;
                                  setState(() {
                                    btnPressed = true;
                                    answered = true;
                                  });
                                  _timer = new Timer(const Duration(milliseconds: 100), () {
                                    Pressed();
                                  });
                                } : null,
                                child: Text(answers[answerIndex].answer,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    )),
                              ),
                            );
                          }
                      ),


                ],
              );
            },
            itemCount: widget.questions.length,
          ),),),),
    );
  }

  Future<void> Pressed()
  async {
    if (_controller!.page?.toInt() == widget.questions.length - 1) {
      if(AuthService().user != null){
        GradeService().addActivityMark(AuthService().user!.uid, widget.quiz.courseCode, ActivityMark(activityID: widget.quiz.id, segmentID: widget.quiz.segmentCode, maxScore: widget.questions.length/1.0, achievedScore: score/1.0));}
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPage(quiz: widget.quiz, maxScore: widget.questions.length, achievedScore: score,)),
              (Route<dynamic> route) => false,
        );

    } else {
      _controller!.nextPage(
          duration: Duration(milliseconds: 50),
          curve: Curves.bounceIn);

      setState(() {
        btnPressed = false;
      });
    }
  }
}



class StartPage extends StatelessWidget {
  Quiz quiz;
  List<Question> questions;
  ActivityMark? activityMark;

 StartPage({Key? key, required this.quiz, required this.questions, this.activityMark,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
      ),
      body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/quiz-background.jpg"),
          fit: BoxFit.cover,
          ),
        ),
      child:
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25,horizontal: 10),
          color: Colors.black.withOpacity(0.7),
          child:

      Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                  Text(quiz.title, style: TextStyle(color: Colors.white70, fontSize: 38, fontWeight: FontWeight.bold), ),
                  const SizedBox(height: 10,),
                  const Divider(height: 1,color: primaryDividerColor,),
                  const SizedBox(height: 20,),
                  Expanded( child: Text(quiz.description + "\n\nKviz ima: ${questions.length} ${questions.length == 1 ? 'pitanje' : 'pitanja'}.", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  Text('Trajanje: ${quiz.duration} sekundi', style: TextStyle(color: Colors.grey[100]),),
                  const SizedBox(height: 5,),
                  activityMark == null ? RoundedButton(text: 'Započnite provjeru', press: (){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizScreen(quiz: quiz, questions: questions)),
                          (Route<dynamic> route) => false,
                    );
                  }) : Container(margin: EdgeInsets.only(top: 25, bottom: 15),
                    child: Column(
                      children: [
                        Text(getResultTitle(activityMark!.mark!), style: TextStyle(fontSize: 22),),
                        Text('Riješeno s uspijehom od: ${roundToSecondDecimal(activityMark!.mark! *100)} %',
                          style: TextStyle(color: getResultColor(activityMark!.mark!), fontSize: 18),
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 10,),
          ],
        ),
        ),
      ),
      ),
    );
  }
}


class ResultPage extends StatelessWidget {
  final Quiz quiz;
  final int achievedScore;
  final int maxScore;
  const ResultPage({Key? key, required this.quiz, required this.maxScore, required this.achievedScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          showScaffoldMessage(context: context, message: 'Nije moguće se vratti natrag.');
          return false;
        },
        child:
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue.withOpacity(0.3),
            leading: IconButton(onPressed: (){
              goToCoursePage(context);
            }, icon: Icon(Icons.arrow_back),),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/quiz-background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child:
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getResultFeedback(),
                    SizedBox(
                      height: 100.0,
                    ),
                    Container(
                      width: 230,
                      height: 55,
                      child: TextButton(
                        child: const Text('Vrati se na početnu',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,),),
                        onPressed: (){
                          goToCoursePage(context);
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  void goToCoursePage (BuildContext context) async{
    var segments = await CourseService().getCourseSegments(quiz.courseCode);
    var course = await CourseService().getCourseData(quiz.courseCode);
    goToPageWithLastPop(context: context, page: CourseScreen(course: course, segments: segments,));
  }

  Widget getResultFeedback(){
    return Column(
      children: [
      SizedBox(
        width: double.infinity,
        child: Text(
          getResultTitle(achievedScore/(maxScore/1.0)),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        height: 45.0,
      ),
      Text(
        "Vaš rezultat je: ",
        style: TextStyle(color: Colors.white, fontSize: 34.0),
      ),
      SizedBox(
        height: 20.0,
      ),
      Text(
        "$achievedScore/$maxScore",
        style: TextStyle(
          color: getResultColor(achievedScore/(maxScore/1.0)),
          fontSize: 52.0,
          fontWeight: FontWeight.bold,),
      ),
    ],
    );
  }



}



class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({Key? key, required this.question}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(question.questionField),
          ),
        ),
      ],
    );
  }

}
