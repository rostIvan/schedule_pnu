
String formattedDate(DateTime time) =>'${time.day}.${time.month}.${time.year}';

String formatSingleDate(DateTime date) => "${date.day.toString().padLeft(2,'0')}.${date.month.toString().padLeft(2,'0')}";

String formatRangeDates(DateTime from, DateTime to) => "${formatSingleDate(from)} - ${formatSingleDate(to)}";

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