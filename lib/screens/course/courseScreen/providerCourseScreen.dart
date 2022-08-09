import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models.dart';
import '../../../services/database/courseService.dart';
import '../../../shared/methods/navigationMethods.dart';
import '../../../shared/methods/ungroupedSharedMethods.dart';
import '../../../widgets/inputs/roundedInput.dart';
import '../../../widgets/buttons/scalableButton.dart';
import '../../frontPages/frontpage.dart';
import '../builders/futureSegmentsBuild.dart';
import '../segmentItem.dart';
import 'courseScreen.dart';


class ProviderCourseScreen extends StatefulWidget {
  final Course course;
  List<Segment>? segments;

  ProviderCourseScreen({Key? key,required this.course, this.segments,}) : super(key: key);

  @override
  State<ProviderCourseScreen> createState() => _ProviderCourseScreenState();
}

class _ProviderCourseScreenState extends State<ProviderCourseScreen> {

  bool _isEditableState = false;
  late List<ProfileProfessor> assignedProfessors = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final assignedProfessors = await CourseService().getAllProfessAssignedToCourse(widget.course.code);
    setState(() {
      this.assignedProfessors = assignedProfessors;
    });
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.arrow_back_outlined), onPressed: () { goToPage(context: context, page: FrontPage()); },
        ),
        backgroundColor: Color(widget.course.color).withOpacity(0.9),
        actions: [
          EditIcon(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CourseCoverTheme(widget.course, size, null, assignedProfessors, context),
          _isEditableState ?

          ScalableButton(text: 'Dodaj segment', press: (){
            addCourseSegmentForm(widget.course);
          }, color: Color(widget.course.color), width: size.width*0.95,): Container(),
          ProvidersSegmentBuild(segments: widget.segments, course: widget.course, isEditableState: _isEditableState,),
        ]
        ),
      ),
    );
  }


  Widget EditIcon() {
    return IconButton(onPressed: (){
      setState(() {
        _isEditableState = !_isEditableState;
      });
    },
      icon: _isEditableState ? Icon(Icons.cancel) : Icon(Icons.edit),
      tooltip: _isEditableState ? 'Izađi' : 'Uredi',
    );
  }





  Future addCourseSegmentForm(Course course) async {
    String? segmentName;
    showDialog(context: context,
      builder: (context) =>
          StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black87,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Dodajte novi segment!'),
                  IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel_presentation,size: 22,),
                    tooltip: 'Izađi',
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundedInputField(
                    icon: Icons.segment,
                    hintText: "Unesite naziv segmenta",
                    onChanged: (value) {
                      setState(
                              () => segmentName = value
                      );
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('Dodaj'),
                    onPressed: () async {
                      if(segmentName == null){
                        Fluttertoast.showToast(
                          msg: 'Unesite naziv segmenta', fontSize: 12, backgroundColor: Colors.grey,);
                      } else{
                        Navigator.of(context).pop();
                        Segment segment = Segment(title: segmentName ?? 'Segment',);
                        await CourseService().addSegmentToCourse(course.code, segment);

                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => FutureSegmentsBuild(course: course)),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }
                ),
              ],
            );
          }
          ),
    );
  }
}




class ProvidersSegmentBuild extends StatelessWidget{
  List<Segment>? segments;
  final Course course;
  bool isEditableState;
  ProvidersSegmentBuild({Key? key, this.segments, required this.course, this.isEditableState = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: segments?.length ?? 0,
        itemBuilder: (_, index) {
          return isEditableState ? EditableSegmentItem(segment: segments![index], course: course, ) : ProviderSegmentItem(segment: segments![index], course: course);
        }
    );
  }
}
