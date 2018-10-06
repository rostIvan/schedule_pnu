import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:lessons_schedule_pnu/util/cp1251.dart';
import 'package:lessons_schedule_pnu/data/model/schedule.dart';

abstract class ScheduleService {
  Future<List<DaySchedule>> getSchedule();
}

class ScheduleScrapper implements ScheduleService {
  final String url = 'http://asu.pnu.edu.ua/cgi-bin/timetable.cgi?n=700';
  final String groupName;
  String startDate = '', endDate = '';
  ScheduleScrapper(this.groupName, {this.startDate, this.endDate});

  @override
  Future<List<DaySchedule>> getSchedule() => _extractData();

  Future<List<DaySchedule>> _extractData() async {
    final loader = PageLoader(url, groupName, startDate, endDate);
    final page = await loader.getPage();
    final document = parser.parse(page);
    return _scrapeData(document);
  }

  List<DaySchedule> _scrapeData(Document document) {
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
    var lessonInfo = tdTags[2].text.trim().replaceAll(new RegExp(r"\s{2,}"), " ");
    return Lesson(lessonNumber, LessonTime(timeStart, timeEnd), lessonInfo);
  }

  ScheduleDate _getLessonDate(Element table) {
    var tableHead = table.parent.getElementsByTagName('h4')[0];
    var smallTag = tableHead.getElementsByTagName('small')[0];
    var date = tableHead.firstChild.text.trim(); // Get date from header like a '10.11.2018'
    var day = smallTag.text.trim(); // Get day from header like a 'Понеділок'
    return ScheduleDate(date, day);
  }
}

class PageLoader {
  final String url;
  String groupName, startDate, endDate;
  PageLoader(this.url, String groupName, this.startDate, this.endDate) {
    this.groupName = encodeCp1251Url(groupName);
  }

  Future<String> getPage() async {
    http.Response response = await http.post(
        url,
        body: _body(groupName, startDate: startDate, endDate: endDate),
        headers: _headers()
    );
    if(response.statusCode != 200)
      throw http.ClientException('Status code = ${response.statusCode}', Uri.parse(url));
    final page = decodeCp1251(response.bodyBytes);
    return page;
  }


  String _body(String group, {String startDate = '', String endDate = ''}) => 'faculty=0&teacher=&group=$group&sdate=$startDate&edate=$endDate&n=700';
  Map<String, String> _headers() => {
    "accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
    "accept-encoding" : "gzip, deflate",
    "accept-language" : "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7",
    "cache-control" : "no-cache",
    "connection" : "keep-alive",
    "host" : "asu.pnu.edu.ua",
    "origin" : "http://asu.pnu.edu.ua",
    "referer" : "http://asu.pnu.edu.ua/cgi-bin/timetable.cgi",
    "upgrade-insecure-requests" : "1",
    "user-agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"
  };
}
