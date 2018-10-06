import 'package:lessons_schedule_pnu/data/network.dart';
import 'package:http/http.dart' as http;
import 'package:lessons_schedule_pnu/util/time.dart';

void main() {
  final ScheduleService service = ScheduleScrapper('ІПЗ-3', startDate: formattedDate(DateTime.now()), endDate: '10.10.18');
  service.getSchedule()
      .then((items) {
        items.forEach((daySchedule) => print(daySchedule));
  }).catchError(handleError);
}

handleError(error) {
  if (error is http.ClientException) {
    print(error.message + ' url: ' + error.uri.toString());
  }
  else throw(error);
}