import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/page/selection/view.dart';

void main() => runApp(new ScheduleApp());

class ScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: SelectPage()
    );
  }
}