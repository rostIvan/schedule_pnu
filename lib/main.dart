import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/page/home.dart';
import 'package:lessons_schedule_pnu/util/cp1251.dart';

void main() => runApp(new ScheduleApp());

class ScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PNU lessons schedule',
      theme: ThemeData.light(),
      home: HomePage()
    );
  }
}