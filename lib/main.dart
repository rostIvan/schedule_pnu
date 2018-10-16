import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/page/home/view.dart';
import 'package:lessons_schedule_pnu/page/preloader/view.dart';
import 'package:lessons_schedule_pnu/page/selection/view.dart';

void main() => runApp(new ScheduleApp());

class ScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PreloaderPage(),
    routes: _routes(),
  );

  Map<String, WidgetBuilder> _routes() => {
    '/home' : (context) => HomePage(),
    '/select' : (context) => SelectPage(),
  };
}