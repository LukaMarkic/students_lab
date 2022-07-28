
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/screens/calendar/tableCalendar.dart';
import 'package:students_lab/services/database/calendarService.dart';
import '../../../error.dart';
import '../../../loading.dart';

class FutureCalendarBuild extends StatelessWidget{

  String collectionName;
  String userID;
  FutureCalendarBuild({required this.collectionName, required this.userID});

  @override
  Widget build(BuildContext context) {

    return  FutureBuilder(
        future: CalendarService().getUserEvents(collectionName, userID),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: ErrorMessage(),
            );
          }
          else {

              List<Event>? events = snapshot.data;
              var selectedEvents = fillMap(events);
              return TableCalendarScreen(selectedEvents: selectedEvents, collectionName: collectionName, userID: userID);
            }
          }
    );
  }



}

Map<DateTime, List<Event>>? fillMap(List<Event>? events){
  Map<DateTime, List<Event>> map = {};
  if(events != null){
    for(var event in events){

      //Setting to day only without time
      final DateTime day = DateTime.parse('${DateUtils.dateOnly(event.day)}Z');
      if (map[day] != null) {
        map[day]?.add(
          event,
        );
      } else {
        map[day] = [
          event
        ];
      }
    }
    return map;
  }else{
    return null;
  }

}