
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/database/calendarService.dart';
import 'package:students_lab/shared/methods/ungroupedSharedMethods.dart';
import 'package:students_lab/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/database/courseService.dart';
import '../../shared/bottomBar.dart';
import '../../shared/methods/navigationMethods.dart';
import '../../widgets/alertWindow.dart';
import '../course/courseScreen/courseScreen.dart';

class TableCalendarScreen extends StatefulWidget {

  Map<DateTime, List<Event>>? selectedEvents;
  String collectionName;
  String userID;

  TableCalendarScreen({Key? key, required this.selectedEvents, required this.collectionName, required this.userID}) : super(key: key);

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {


  DateTime selectedDay = DateTime.now();
  CalendarFormat format = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  Map<CalendarFormat, String> availableCalendarFormats = const {CalendarFormat.month : 'Mjesec', CalendarFormat.twoWeeks : '2 tjedna', CalendarFormat.week : 'Tjedan'};

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();



  List<Event> _getEventsfromDay(DateTime date) {
    return widget.selectedEvents?[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: calendarTheme,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Pregled obveza'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  daysOfWeekHeight: 32,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  locale: 'hr',
                  focusedDay: selectedDay,
                  firstDay: DateTime.now().subtract(Duration(days: 365)),
                  lastDay: DateTime(2050),
                  currentDay: DateTime.now(),
                  calendarFormat: format,
                  availableCalendarFormats: availableCalendarFormats,
                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      focusedDay = focusDay;
                    });
                  },


                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },

                  calendarStyle: CalendarStyle(
                    cellPadding: EdgeInsets.symmetric(vertical: 5),
                    markerDecoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff29D200).withOpacity(0.75)),
                    todayDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withAlpha(95)),
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.85),

                    ),
                  ),

                  eventLoader: _getEventsfromDay,

                ),
                ..._getEventsfromDay(selectedDay).map(
                      (Event event) => Container(
                          margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 0.2,
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: ListTile(
                            onTap: ()async{

                              if(event.courseCode != null){
                                var segments = await CourseService().getCourseSegments(event.courseCode!);
                                var course = await CourseService().getCourseData(event.courseCode!);
                                goToPage(context: context, page: CourseScreen(course: course, segments: segments,));
                              }
                            },
                            title: Text( event.title,),
                            subtitle: Text( event.description,),
                            trailing: IconButton(icon: Icon(Icons.highlight_remove_outlined,
                               color: Colors.black,
                              size: 28,
                              ), onPressed: (){
                              showAlertWindow(context, 'Želite li izbrisati: ' + event.title, () async {
                                CalendarService().removeEvent(widget.collectionName, widget.userID, event.id);
                                setState(() {
                                  widget.selectedEvents?[selectedDay]?.remove(event);
                                });
                                Navigator.of(context).pop();
                              },
                              );
                            },
                            tooltip: 'Ukloni podsjetnik',
                            ),
                          ),
                      ),
                ),
                SizedBox(height: 75,),
              ],
            ),
          ),


          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EventEditingPage()));
            },
          ),
          bottomNavigationBar: BottomWidget(context, 2, widget.collectionName, widget.userID),
        );
      }),
    );
  }




Widget EventEditingPage() {
  return Theme(
      data: calendarTheme,
      child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                leading: CloseButton(),
                actions: SaveFormButton(),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuildTitle(),
                      SizedBox(height: 10,),
                      BuildDescription(),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            );
          }
      )
  );
  }


  List<Widget> SaveFormButton() {
    return [
      ElevatedButton.icon(onPressed: (){
        SaveForm();
      }, icon: Icon(Icons.done), label: const Text('Spremi'),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),),
    ];
  }




  Widget BuildTitle(){

    return TextFormField(
        style: TextStyle(fontSize: 22),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Unesite naziv'
        ),
        validator: (title) => title != null && title.isEmpty ? 'Potrebno unijeti naziv' : null,
        controller: titleController,
      );
  }



  Widget BuildDescription(){

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        style: TextStyle(fontSize: 18),
        decoration: const InputDecoration(
            icon: Icon(Icons.description),
            border: UnderlineInputBorder(),
            hintText: 'Unesite opis',
            hintStyle: TextStyle(color: Colors.black45),
        ),
        minLines: 1,
        maxLines: 8,
        keyboardType: TextInputType.multiline,
        validator: (description) => description != null && description.isEmpty ? 'Potrebno unijeti opis' : null,
        controller: descriptionController,
      ),
    );
  }





  Future SaveForm() async{
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      final event = Event(
        title: titleController.text, description: descriptionController.text, day: selectedDay,
      );
      CalendarService().addEventToUser(widget.collectionName, widget.userID, event);
      if (widget.selectedEvents?[selectedDay] != null) {
        widget.selectedEvents?[selectedDay]?.add(
          event,
        );
      } else {
        widget.selectedEvents?[selectedDay] = [
          event
        ];
      }
      setState(() {
      });
      titleController.clear();
      Navigator.of(context).pop();
    }
  }

}



