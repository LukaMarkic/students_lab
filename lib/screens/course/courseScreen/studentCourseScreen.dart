import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../models.dart';
import '../../../../services/auth.dart';
import '../../../../services/database/courseService.dart';
import '../../../../services/database/gradeService.dart';
import '../segmentItem.dart';
import 'courseScreen.dart';



class StudentCourseScreen extends StatefulWidget {
  final Course course;
  List<Segment>? segments;
  StudentCourseScreen({Key? key,required this.course, this.segments}) : super(key: key);

  @override
  State<StudentCourseScreen> createState() => _StudentCourseScreenState();
}

class _StudentCourseScreenState extends State<StudentCourseScreen> {

  double? courseGrade;
  late List<ProfileProfessor> assignedProfessors = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final courseGrade = await GradeService().getCourseGrade(AuthService().user!.uid, widget.course.code);
    final assignedProfessors = await CourseService().getAllProfessAssignedToCourse(widget.course.code);
    setState(() {
      this.courseGrade = courseGrade;
      this.assignedProfessors = assignedProfessors;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.course.color).withOpacity(0.9),
        actions: [
          FutureBuilder<ElevatedButton>(future: FutureElevatedButtonLabelEnrolment(context, widget.course.code), builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container();}
            else{
              return snapshot.data ?? Container();
            }
          }
          ),
        ],
      ),
      body: SingleChildScrollView(child:
      Column(
        children: [
          CourseCoverTheme(widget.course, size, courseGrade, assignedProfessors, context),
          ClientSegmentBuild(segments: widget.segments, course: widget.course,),
        ],
      ),
      ),
    );
  }
}



class ClientSegmentBuild extends StatelessWidget{
  List<Segment>? segments;
  final Course course;
  List<Quiz>? quizzes;
  ClientSegmentBuild({Key? key, this.segments, required this.course, this.quizzes}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: segments?.length ?? 0,
        itemBuilder: (_, index) {
          return SegmentItem(segment: segments![index], course: course,);
        }
    );
  }
}

