
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/shared/sharedMethods.dart';
import '../constants.dart';
import '../error.dart';
import '../loading.dart';
import '../models.dart';
import '../services/database/gradeService.dart';


class GradeStatisticPage extends StatefulWidget{


  List<CourseGradeSegment> courseGradeSegments;


  GradeStatisticPage({required this.courseGradeSegments,});

  @override
  State<GradeStatisticPage> createState() => _GradeStatisticPageState();
}

class _GradeStatisticPageState extends State<GradeStatisticPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryThemeColor,
      appBar: AppBar(
        title: Text('Statistički pregled uspješnosti'),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,

      ),
      body:  SingleChildScrollView(
        child:
        Column(
          children: [

            SizedBox(height: 5,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.courseGradeSegments?.length ?? 0,
                  itemBuilder: (_, courseIndex) {
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
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                             Text('[${widget.courseGradeSegments[courseIndex].code}]  ${widget.courseGradeSegments[courseIndex].title}', style: TextStyle(color: Colors.black, fontSize: 16),),
                             Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text('${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].courseGrade! * 100)}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),),
                                 Text('/(${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].averageCourseGrade! * 100)}).', style: TextStyle(color: Colors.black54, fontSize: 14),),
                               ],
                             ),
                            ],),
                            const Divider(
                              color: primaryDividerColor,
                              thickness: 1.5,
                            ),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                shrinkWrap: true,
                                itemCount: widget.courseGradeSegments[courseIndex].segmentMarkTiles.length ?? 0,
                                itemBuilder: (_, markIndex) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Colors.black12,),
                                        left: BorderSide(width: 0.5, color: Colors.black12),
                                        right: BorderSide(width: 0.5, color: Colors.black12),
                                        top: BorderSide(width: 0.5, color: Colors.black12,),
                                      ),

                                    ),
                                    child: widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].segmentMark != null ? ListTile(
                                      title: Text(widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].title, style: TextStyle(color: Colors.black54, fontSize: 14),),
                                      trailing:  Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                        Text('${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].segmentMark ?? 0 * 100)}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),),
                                          Text('/(${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].averageSegmentMark ?? 0 * 100)}).', style: TextStyle(color: Colors.black54, fontSize: 14),),
                                        ],
                                      ),
                                    ) : Container(),
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
      ),
    );
  }

}




class FutureGradeStatisticBuild extends StatelessWidget{

  List<String> courseCodes;

  FutureGradeStatisticBuild({required this.courseCodes});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: GradeService().getCourseGradeSegments(courseCodes),
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
              var courseGradeSegments = snapshot.data;
              return  GradeStatisticPage(courseGradeSegments: courseGradeSegments);

            }
          }
        }
    );
  }

}