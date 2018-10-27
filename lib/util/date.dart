
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