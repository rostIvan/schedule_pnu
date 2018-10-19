import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/page/preloader/view.dart';

void main() => runApp(new ScheduleApp());

class ScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PreloaderPage(),
  );
}