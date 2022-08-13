
import 'package:flutter/material.dart';
import 'package:students_lab/shared/methods/ungroupedSharedMethods.dart';
import 'package:students_lab/widgets/containers/dividerWidget.dart';
import '../constants.dart';
import '../error.dart';
import '../loading.dart';
import '../models.dart';
import '../services/database/gradeService.dart';
import '../widgets/containers/roundedContainer.dart';


class GradeStatisticPage extends StatefulWidget{

  List<CourseGradeSegment> courseGradeSegments;

  GradeStatisticPage({Key? key, required this.courseGradeSegments,}) : super(key: key);

  @override
  State<GradeStatisticPage> createState() => _GradeStatisticPageState();
}

class _GradeStatisticPageState extends State<GradeStatisticPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryThemeColor,
      appBar: AppBar(
        title: const Text('Statistički pregled uspješnosti'),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,

      ),
      body:  SingleChildScrollView(
        child:
        Column(
          children: [

            const SizedBox(height: 5,),
            RoundedContainer(
              child: Center(
                child: Column(
                  children: const [
                    Text('Pregled statistike i uspjeha riješenosti', style: TextStyle(color: Colors.black,fontSize: 18),),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    const Text('Kolegij',style: TextStyle(color: Colors.black, fontSize: 16),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Vaša usješnost', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),),
                        Text('/(Prosjek)', style: TextStyle(color: Colors.black54, fontSize: 14),),
                      ],
                    ),
                  ],),
                  DividerWrapper(padding: const EdgeInsets.symmetric(vertical: 5),),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.courseGradeSegments.length,
                      itemBuilder: (_, courseIndex) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          elevation: 5,
                          color: Colors.white,
                          clipBehavior: Clip.antiAlias,
                          child:  Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.courseGradeSegments[courseIndex].title, style: const TextStyle(color: Colors.black, fontSize: 16),),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].courseGrade! * 100)}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),),
                                        Text('/(${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].averageCourseGrade! * 100)}).', style: const TextStyle(color: Colors.black54, fontSize: 14),),
                                      ],
                                    ),
                                  ],),
                                const Divider(
                                  color: primaryDividerColor,
                                  thickness: 1.5,
                                ),
                                ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    shrinkWrap: true,
                                    itemCount: widget.courseGradeSegments[courseIndex].segmentMarkTiles.length,
                                    itemBuilder: (_, markIndex) {
                                      return widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].segmentMark != null ? Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(width: 1, color: Colors.black12,),
                                              left: BorderSide(width: 0.5, color: Colors.black12),
                                              right: BorderSide(width: 0.5, color: Colors.black12),
                                              top: BorderSide(width: 0.5, color: Colors.black12,),
                                            ),

                                          ),
                                          child: ListTile(
                                            title: Text(widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].title, style: const TextStyle(color: Colors.black54, fontSize: 14),),
                                            trailing:  Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].segmentMark ?? 0 * 100)}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),),
                                                Text('/(${roundToSecondDecimal(widget.courseGradeSegments[courseIndex].segmentMarkTiles[markIndex].averageSegmentMark ?? 0 * 100)}).', style: const TextStyle(color: Colors.black54, fontSize: 14),),
                                              ],
                                            ),
                                          )
                                      ): Container();
                                    }
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ],
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

  FutureGradeStatisticBuild({Key? key, required this.courseCodes}) : super(key: key);

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
              return const CircularProgressIndicator();
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