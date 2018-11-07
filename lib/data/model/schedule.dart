
class DaySchedule {
  final List<Lesson> lessons = [];
  final ScheduleDate date;
  DaySchedule(this.date);
  @override
  String toString() => "DaySchedule[$date, $lessons]";
}

class Lesson {
  final ScheduleDate date;
  final int number;
  final LessonTime time;
  final String audience;
  final String info;
  Lesson(this.number, this.time, this.audience, this.info, this.date);
  @override
  String toString() => "Lesson[$number $time $audience $info]";
}

class ScheduleDate {
  final String fullDate;
  final String weekDay;
  ScheduleDate(this.fullDate, this.weekDay);
  @override
  String toString() => '$fullDate => $weekDay';
}

class LessonTime {
  final String timeStart;
  final String timeEnd;
  LessonTime(this.timeStart, this.timeEnd);
  @override
  String toString() => '($timeStart - $timeEnd)';
}
