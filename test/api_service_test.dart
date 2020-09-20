import 'package:lessons_schedule_pnu/data/service.dart';
import 'package:lessons_schedule_pnu/util/date.dart';
import 'package:http/http.dart' as http;

void main() {
  final ScheduleService service = ScheduleScrapper(
      group: 'ІПЗМ-1',
      // teacher: 'Іщеряков* Сергій Михайлович',
      startDate: formatDate(DateTime.now().add(Duration(days: 1))),
      endDate: formatDate(DateTime.now().add(Duration(days: 8))));
  service.getSchedule().then((items) {
    items.forEach((daySchedule) {
      print('Date: ' + daySchedule.date.toString());
      daySchedule.lessons.forEach((lesson) => print(lesson));
      print('');
    });
  }).catchError(handleError);
  final ApiSearchService searchService1 = TeacherSuggestionSearch('Коз');
  searchService1
      .fetchALl()
      .then((items) => items.forEach((item) => print(item)));
  final ApiSearchService searchService2 = GroupsSuggestionSearch('ІПЗ-');
  searchService2
      .fetchALl()
      .then((items) => items.forEach((item) => print(item)));
  final ApiSearchService searchService3 = GroupsSuggestionSearch('1');
  searchService3
      .fetchALl()
      .then((items) => items.forEach((item) => print(item)));
}

handleError(error) {
  if (error is http.ClientException) {
    print(error.message + ' url: ' + error.uri.toString());
  } else
    throw (error);
}
