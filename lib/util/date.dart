
String formatDate(DateTime date, {bool shortYear = false}) {
  if(!shortYear)
    return '${formatSingleDate(date)}.${date.year}';
  return '${formatSingleDate(date)}.${date.year.toString().substring(2)}';
}

String formatSingleDate(DateTime date) => "${date.day.toString().padLeft(2,'0')}.${date.month.toString().padLeft(2,'0')}";

String formatRangeDates(DateTime from, DateTime to, {bool showShortYear = false, bool showFullYear = false}) {
  if (!showShortYear && !showFullYear)
    return "${formatSingleDate(from)} - ${formatSingleDate(to)}";
  else if(showShortYear)
    return "${formatDate(from, shortYear: true)} - ${formatDate(to, shortYear: true)}";
  else
    return "${formatDate(from, shortYear: false)} - ${formatDate(to, shortYear: false)}";
}

String formatWeekDay(DateTime date) {
  switch(date.weekday) {
    case 1: return 'Пн.';
    case 2: return 'Вт.';
    case 3: return 'Ср.';
    case 4: return 'Чт.';
    case 5: return 'Пт.';
    case 6: return 'Сб.';
    case 7: return 'Нд.';
  }
  return null;
}

String formatWeekRange(DateTime from, DateTime to) => '${formatWeekDay(from)} - ${formatWeekDay(to)}';

List<DateTime> dateRange(DateTime startDate, DateTime endDate) {
  var range = endDate.difference(startDate).inDays + 1;
  return List.generate(range, (i) => startDate.add(Duration(days: i)).toUtc()).toList();
}

String formatFullWeekDay(DateTime date) {
  switch(date.weekday) {
    case 1: return 'Понеділок';
    case 2: return 'Вівторок';
    case 3: return 'Середа';
    case 4: return 'Четвер';
    case 5: return 'П\'ятниця';
    case 6: return 'Субота';
    case 7: return 'Неділя';
  }
  return null;
}

String formatFullMonth(DateTime date) {
  switch(date.month) {
    case 1 : return 'Січень';
    case 2 : return 'Лютий';
    case 3 : return 'Березень';
    case 4 : return 'Квітень';
    case 5 : return 'Травень';
    case 6 : return 'Червень';
    case 7 : return 'Липень';
    case 8 : return 'Серпень';
    case 9 : return 'Вересень';
    case 10 : return 'Жовтень';
    case 11 : return 'Листопад';
    case 12 : return 'Грудень';
  }
  return null;
}

DateTime parseTime(String date, String time) {
  final d = date.split('.');
  final t = [d[2], d[1], d[0]].join('-') + ' ' + time;
  return DateTime.parse(t);
}