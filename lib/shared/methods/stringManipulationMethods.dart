
import 'dart:math';
import 'package:internationalization/internationalization.dart';


//DateTime

String getTimeFormat(DateTime selectedDate){
  String result;
  final DateFormat formatter = DateFormat('dd.MM.yyyy.');
  result = formatter.format(selectedDate.toLocal()).toString().split(' ')[0];
  return result;
}

String getTimeDifference(DateTime firstDate, DateTime secondDate){
  var timeDifference = secondDate.difference(firstDate);
  int days = timeDifference.inDays;
  int hours = timeDifference.inHours - timeDifference.inDays * 24;
  int minutes = timeDifference.inMinutes - timeDifference.inHours * 60;
  int seconds = timeDifference.inSeconds - timeDifference.inMinutes * 60;
  return days.toString() + (days == 1 ? ' dan ' : ' dana ') + hours.toString() + (hours == 1 ? ' sat ' : hours <= 4 ? ' sata ' : ' sati ' ) +
      minutes.toString() + ' min ' + seconds.toString() + (seconds == 1 ? ' sekunda ' : seconds <= 4 ? ' sekunde ' : ' sekundi ' );
}



//

String getRandomString(int length){

  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

String getHiddenCode(String code){
  String result = '';
  int length = code.length;
  if(length > 4){
    result += code.substring(length-5, length-1);
  }else{
    result += code;
  }
  return result;
}