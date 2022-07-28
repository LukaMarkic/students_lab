
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/screens/frontpage.dart';
import 'package:students_lab/screens/quiz/quizScreen.dart';
import 'package:students_lab/widgets/roundedContainer.dart';
import '../../constants.dart';
import '../../error.dart';
import '../../loading.dart';
import '../../models.dart';
import '../../services/database/quizService.dart';


class QuizPreviewScreen extends StatefulWidget {


  Quiz? quiz;
  List<Question>? questions;
  QuizPreviewScreen({
    this.quiz,
    this.questions,
  });
  @override
  _QuizPreviewScreenState createState() => _QuizPreviewScreenState();
}

class _QuizPreviewScreenState extends State<QuizPreviewScreen> {

  @override
  void initState() {
    super.initState();
    widget.questions?.sort((a, b) => a.index.compareTo(b.index));
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child:
        Column(
          children: [
            RoundedContainer(
              child: Center(
                child: Column(
                  children: [
                    Text('${widget.quiz?.title}', style: TextStyle(color: Colors.black,fontSize: 22),),
                    Text('${widget.quiz?.description}', style: TextStyle(color: Colors.black87,fontSize: 12),),
                    Text('${widget.quiz?.duration} sekundi', style: TextStyle(color: Colors.black54,fontSize: 11),),
                  ],
                ),
              ),
            ),

            SizedBox(height: 5,),

            Container(
              child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.questions?.length ?? 0,
              itemBuilder: (_, questionIndex) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  elevation: 5,
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  child:  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${questionIndex + 1 }.  ${widget.questions![questionIndex].questionField}', style: TextStyle(color: Colors.black87, fontSize: 16),),
                        const Divider(
                          color: primaryDividerColor,
                          thickness: 1.5,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            shrinkWrap: true,
                            itemCount: widget.questions?[questionIndex].answers.length ?? 0,
                            itemBuilder: (_, answerIndex) {
                              var option = Answer.fromJson(widget.questions![questionIndex].answers[answerIndex]);
                              return Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 1, color: Colors.black12,),
                                    left: BorderSide(width: 0.5, color: Colors.black12),
                                    right: BorderSide(width: 0.5, color: Colors.black12),
                                    top: BorderSide(width: 0.5, color: Colors.black12,),
                                  ),

                                ),
                                child: ListTile(
                                  title: Text(option.answer, style: const TextStyle(color: Colors.black54, fontSize: 14),),
                                  trailing: option.isRight ?  Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                  ) : Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                );
            }
          ),
            ),
          ],
        ),
    );
  }
}



class FutureQuizBuild extends StatelessWidget{

  String quizID;
  bool isProvider;
  ActivityMark? activityMark;
  FutureQuizBuild({required this.quizID, required this.isProvider, this.activityMark});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: QuizService().getQuizData(quizID),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          }
          else {
            if(snapshot.data == null){
              return CircularProgressIndicator();
            }
            else{
              var quiz = snapshot.data;
              return  FutureBuilder(
                  future: QuizService().getQuestions(quizID),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingScreen();
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: ErrorMessage(),
                      );
                    }
                    else {
                      if(snapshot.data == null){
                        return CircularProgressIndicator();
                      }
                      else{
                        List<Question> questions = snapshot.data;
                        return isProvider ? Scaffold(appBar: AppBar(),body: QuizPreviewScreen(quiz: quiz, questions: questions,),) : StartPage(quiz: quiz, questions: questions, activityMark: activityMark,);
                      }
                    }
                  }
              );

            }
          }
        }
    );
  }

}