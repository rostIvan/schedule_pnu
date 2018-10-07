
class DaySchedule {
  final List<Lesson> lessons = [];
  final ScheduleDate date;
  DaySchedule(this.date);
  @override
  String toString() => "DaySchedule[$date, $lessons]";
}

class Lesson {
  final int number;
  final LessonTime time;
  final int audience;
  final String info;
  Lesson(this.number, this.time, this.audience, this.info);
  @override
  String toString() => "Lesson[$number $time $audience $info]";
}

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
