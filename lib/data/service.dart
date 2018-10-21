import 'dart:async';
import 'dart:convert';

import 'package:lessons_schedule_pnu/data/model/schedule.dart';
import 'package:lessons_schedule_pnu/data/network/pageload.dart';
import 'package:lessons_schedule_pnu/data/network/scrap.dart';
import 'package:lessons_schedule_pnu/util/cp1251.dart';
import 'package:http/http.dart' as http;


abstract class ScheduleService {
  Future<List<DaySchedule>> getSchedule();
}

abstract class ApiSearchService {
  Future<List<String>> fetchALl();
}

abstract class ApiSearch implements ApiSearchService {
//  Example of api GETs:
//  http://asu.pnu.edu.ua/cgi-bin/timetable.cgi?n=701&lev=142&faculty=0&query=%D0%86
//  http://asu.pnu.edu.ua/cgi-bin/timetable.cgi?n=701&lev=141&faculty=0&query=%D0%86%D1%89%D0%B5%D1%80%D1%8F%D0%BA%D0%BE%D0%B2
  final String baseUrl = 'http://asu.pnu.edu.ua/cgi-bin/timetable.cgi?n=701';
  final String query;
  final levelCode;
  ApiSearch(this.query, this.levelCode);

  @override
  Future<List<String>> fetchALl() async {
    final fullUrl = '$baseUrl&lev=$levelCode&faculty=0&query=$query';
    final response = await http.get(fullUrl);
    if (response.statusCode != 200)
      throw http.ClientException('Status code = ${response.statusCode}', Uri.parse(fullUrl));
    final covertCp12512 = decodeCp1251(response.bodyBytes).replaceAll(r'\', r'\\');
    final jsonResponse = json.decode(covertCp12512);
    final suggestions = jsonResponse['suggestions'];
    return  List<String>.from(suggestions);
  }
}

class TeacherSuggestionSearch extends ApiSearch {
  TeacherSuggestionSearch(String query) : super(query, 141);
}

class GroupsSuggestionSearch extends ApiSearch {
  GroupsSuggestionSearch(String query) : super(query, 142);
}

class ScheduleScrapper implements ScheduleService {
// Example of POST args faculty=0&teacher=&group=%B2%CF%C7-3&sdate=&edate=28.10.2018&n=700
  final String url = 'http://asu.pnu.edu.ua/cgi-bin/timetable.cgi?n=700';
  final String group;
  final String teacher;
  String startDate = '', endDate = '';
  ScheduleScrapper({this.teacher, this.group, this.startDate, this.endDate});

  @override
  Future<List<DaySchedule>> getSchedule() => _extractData();

  Future<List<DaySchedule>> _extractData() async {
    final loader = PageLoader(url, group, teacher, startDate, endDate);
    final page = await loader.getPage();
    return DataExtractor(page).scrapeData();
  }
}