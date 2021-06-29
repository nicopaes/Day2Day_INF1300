import 'dart:async';
import 'dart:ui';

import 'package:day_2_day/src/notification_service.dart';
import 'package:day_2_day/src/route_generator.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

enum test { t1, that }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  //NotificationService().scheduleNotification();
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    //
    return MaterialApp(
      title: "Day2Day",
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber.shade300,
          accentColor: Colors.cyan[600],
          fontFamily: GoogleFonts.montserrat().fontFamily),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
