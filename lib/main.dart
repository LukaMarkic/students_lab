import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:students_lab/error.dart';
import 'package:students_lab/screens/home.dart';
import 'package:students_lab/services/notificationService.dart';
import 'package:students_lab/theme.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'loading.dart';

Future<void> _firebaseMessagingBackground(RemoteMessage message) async{
//Open specific screen
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: _initialization,
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const MaterialApp(home: ErrorMessage());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                SfGlobalLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('hr'),
              ],
              locale: const Locale('hr'),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
              theme: appTheme,
          );
        }

        return const MaterialApp(home: LoadingScreen());
      },
    );
  }
}





