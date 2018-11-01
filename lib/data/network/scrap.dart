import 'package:html/dom.dart';
import 'package:lessons_schedule_pnu/data/model/schedule.dart';

class DataExtractor {
  final Document document;
  DataExtractor(this.document);

  List<DaySchedule> scrapeData() {
    final List<DaySchedule> items = [];
    document.getElementsByTagName('table').forEach((table) {
      final DaySchedule scheduleItem = DaySchedule(_getLessonDate(table));
      table.getElementsByTagName('tr').forEach((tr) {
        final tdTags = tr.getElementsByTagName('td');
        final lessonItem = _getLessonItem(tdTags);
        scheduleItem.lessons.add(lessonItem);
      });
      items.add(scheduleItem);
    });
    return items;
  }

  Lesson _getLessonItem(List<Element> tdTags) {
    var lessonNumber = int.parse(tdTags[0].text);
    var time = tdTags[1].innerHtml.split('<br>');
    var timeStart = time[0].trim();
    var timeEnd = time[1].trim();
    var info = tdTags[2].text.trim().replaceAll(RegExp(r'\s{2,}'), ' ');
    if (info.isEmpty)
      return Lesson(lessonNumber, LessonTime(timeStart, timeEnd), null, null);
    var audience = RegExp(r'(\d+.?)').firstMatch(info).group(0).trim();
    var lessonInfo = info.replaceAll(audience.toString() + ' ', '');
    return Lesson(lessonNumber, LessonTime(timeStart, timeEnd), audience, lessonInfo);
  }

  ScheduleDate _getLessonDate(Element table) {
    var tableHead = table.parent.getElementsByTagName('h4')[0];
    var smallTag = tableHead.getElementsByTagName('small')[0];
    var date = tableHead.firstChild.text.trim(); // Get date from header like a '10.11.2018'
    var day = smallTag.text.trim(); // Get day from header like a 'Понеділок'
    return ScheduleDate(date, day);
  }
}
