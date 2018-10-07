import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:lessons_schedule_pnu/util/cp1251.dart';

class PageLoader {
  final String url;
  String group, teacher, startDate, endDate;
  PageLoader(this.url, String groupName, String teacher, this.startDate, this.endDate) {
    this.group = encodeCp1251Url(groupName);
    this.teacher = encodeCp1251Url(teacher);
  }

  Future<Document> getPage() async {
    http.Response response = await http.post(
        url,
        body: _body(group: group, teacher: teacher, startDate: startDate, endDate: endDate),
        headers: _headers()
    );
    if(response.statusCode != 200)
      throw http.ClientException('Status code = ${response.statusCode}', Uri.parse(url));
    final page = decodeCp1251(response.bodyBytes);
    return parser.parse(page);
  }


  String _body({String group, String teacher, String startDate = '', String endDate = ''}) => 'faculty=0&teacher=$teacher&group=$group&sdate=$startDate&edate=$endDate&n=700';
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
