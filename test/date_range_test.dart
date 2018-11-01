
import 'package:lessons_schedule_pnu/util/date.dart';

void main() {
//  DateTime startDate = DateTime(2018, 10, 1).toUtc();
//  DateTime endDate = DateTime(2018, 11, 1).toUtc();
  DateTime startDate = DateTime.utc(2018, 10, 1);
  DateTime endDate = DateTime.utc(2018, 12, 31);
  var list = List.generate(endDate.difference(startDate).inDays + 1, (i) => startDate.add(Duration(days: i)).toUtc()).toList();
  list.forEach((date) => print(formatDate(date)));
  print('size :${list.toSet().toList().length}');
  print('${formatDate(list.first)} => ${formatDate(list.last)}');
}