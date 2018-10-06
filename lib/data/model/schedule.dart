
class ScheduleDate {
  final String date;
  final String weekDay;
  ScheduleDate(this.date, this.weekDay);
  @override
  String toString() => '$date => $weekDay';
}

class LessonTime {
  final String timeStart;
  final String timeEnd;
  LessonTime(this.timeStart, this.timeEnd);
  @override
  String toString() => '($timeStart - $timeEnd)';
}

class Lesson {
  final int number;
  final LessonTime time;
  final String info;
  Lesson(this.number, this.time, this.info);
  @override
  String toString() => "Lesson[$number $time $info]";
}

class DaySchedule {
  final List<Lesson> lessons = [];
  final ScheduleDate date;
  DaySchedule(this.date);
  @override
  String toString() => "DaySchedule[$date, $lessons]";
}
