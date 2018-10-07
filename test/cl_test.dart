import 'package:lessons_schedule_pnu/data/service.dart';
import 'package:lessons_schedule_pnu/util/date.dart';
import 'package:http/http.dart' as http;

void main() {
//  final ScheduleService service = ScheduleScrapper(
//      teacher: 'Іщеряков* Сергій Михайлович',
//      group: 'ІПЗ-3',
//      startDate: formattedDate(DateTime.now().add(Duration(days: 1))),
//      endDate: formattedDate(DateTime.now().add(Duration(days: 8))));
//  service.getSchedule()
//      .then((items) {
//        items.forEach((daySchedule) {
//          print('Date: ' + daySchedule.date.toString());
//          daySchedule.lessons.forEach((lesson) => print(lesson));
//          print('');
//        });
//  }).catchError(handleError);
//  final ApiSearchService searchService = TeacherSuggestionSearch('Коз');
//  searchService.fetchALl().then((items) => items.forEach((item) => print(item)));
  final ApiSearchService searchService = GroupsSuggestionSearch('ІПЗ-');
  searchService.fetchALl().then((items) => items.forEach((item) => print(item)));
}

handleError(error) {
  if (error is http.ClientException) {
    print(error.message + ' url: ' + error.uri.toString());
  }
  else throw(error);
}