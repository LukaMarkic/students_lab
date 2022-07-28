
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:students_lab/models.dart';
import 'package:students_lab/services/database/courseService.dart';
import 'package:timezone/timezone.dart' as tz;
import '../shared/sharedMethods.dart';


class NotificationService{

  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();


  static void display(RemoteMessage message) async{
    try {
      Random random = new Random();
      int id = random.nextInt(1000);

      final NotificationDetails firebaseNotificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            'mychannel',
            'my channel',
            importance: Importance.max,
            priority: Priority.high,
          )
      );

      await _notifications.show(
        id,
        message.notification!.title,
        message.notification!.body,
        firebaseNotificationDetails,);
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }

  static Future _notificationDetails() async{
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
    );
  }

  static Future init({bool initScheduled = false}) async{
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);

    await _notifications.initialize(settings,onSelectNotification: ((payload) async {
      onNotifications.add(payload);
    }));
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
}) async => _notifications.show(id, title, body, await _notificationDetails(),payload: payload);

  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
}) async => _notifications.zonedSchedule(id, title, body, tz.TZDateTime.from(scheduledDate, tz.local), await _notificationDetails(),payload: payload,
  androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );



  Future<String?> getNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }


  Future<void> sendNotificationToEnrolledStudentsUsers(String title, String message, List<String> courseCodes)async {
    List<ProfileStudent>? students = await CourseService().getAllStudentEnrolledInCourses(courseCodes);
    if(students != null){
      for(var student in students){
        if(student.token != null){
          sendNotification(title, message, student.token! );
        }
      }
    }
    else{
      return;
    }

  }

}