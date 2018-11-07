import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/model/schedule.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/data/service.dart';
import 'package:lessons_schedule_pnu/page/home/cards.dart';
import 'package:lessons_schedule_pnu/page/schedule/scrollable.dart';
import 'package:lessons_schedule_pnu/page/schedule/timeline.dart';
import 'package:lessons_schedule_pnu/util/date.dart';
import 'package:lessons_schedule_pnu/util/support.dart';

class SchedulePage extends StatelessWidget  {
  final SelectedData data;
  final HeroText heroText;
  final DateTime dateTime;
  final SchedulePeriod period;
  const SchedulePage(this.data, {Key key, this.dateTime, this.period, this.heroText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dateTime != null) {
      return SingleDateSchedule(data, dateTime, heroText);
    }
    else if(period != null) {
      return RangeDateSchedule(data, period, heroText);
    }
    return null;
  }
}

class SingleDateSchedule extends AbstractSchedule {
  final SelectedData data;
  final DateTime dateTime;
  final HeroText heroText;

  SingleDateSchedule(this.data, this.dateTime, this.heroText, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ScrollableApp(
        heroText,
        [dateTime],
        body: ScheduleTimeline(scheduleFuture: _buildFuture(dateTime)),
    ),
  );

  @override
  ScheduleScrapper _scrapper() => _selectGroup() ?
    ScheduleScrapper(group: data.selected, startDate: formatDate(dateTime), endDate: formatDate(dateTime)) :
    ScheduleScrapper(teacher: data.selected, startDate: formatDate(dateTime), endDate: formatDate(dateTime));

  bool _selectGroup() => data.scheduleType == ScheduleType.GROUP;
}

class RangeDateSchedule extends AbstractSchedule {
  final SelectedData data;
  final SchedulePeriod period;
  final HeroText heroText;
  RangeDateSchedule (this.data, this.period, this.heroText, {Key key});

  @override
  Widget build(BuildContext context) {
    final dates = _dates();
    final tabs = _tabs(dates);
    final pages = _pages(dates);
    return DefaultTabController(length: tabs.length, child: Scaffold(
            body: ScrollableApp(
                heroText,
                _dates(),
                tabs: tabs,
                body: TabBarView(children: pages)
            ),
      ),
    );
  }

  List<Widget> _pages(List<DateTime> dates) => dates.map((date) => ScheduleTimeline(scheduleFuture: _buildFuture(date))).toList();

  List<Widget> _tabs(List<DateTime> dates) => dates
      .map((date) => Tab(child: Text(formatSingleDate(date))))
      .toList();

  List<DateTime> _dates() {
    final utcPeriod = period.toUtc();
    final dates = dateRange(utcPeriod.from, utcPeriod.to);
    return dates;
  }

  @override
  ScheduleScrapper _scrapper() => _selectGroup() ?
    ScheduleScrapper(group: data.selected, startDate: formatDate(period.from), endDate: formatDate(period.to)) :
    ScheduleScrapper(teacher: data.selected, startDate: formatDate(period.from), endDate: formatDate(period.to));

  bool _selectGroup() => data.scheduleType == ScheduleType.GROUP;
}

abstract class AbstractSchedule extends StatelessWidget {
  AbstractSchedule({Key key}) : super(key: key);

  ScheduleScrapper _scrapper();
  DaySchedule _emptyDay() => DaySchedule(ScheduleDate('', ''));

  Future<List<Lesson>> _buildFuture(DateTime dateTime) async {
    var scheduleScrapper = _scrapper();
    final schedule = await scheduleScrapper.getSchedule();
    return schedule.firstWhere((day) {
      var date1 = day.date.fullDate;
      var date2 = formatDate(dateTime);
      return date1 == date2;
    }, orElse: () => _emptyDay()).lessons;
  }
}

class SchedulePeriod {
  DateTime from;
  DateTime to;
  SchedulePeriod(this.from, this.to);

  @override
  String toString() => formatRangeDates(from, to);

  SchedulePeriod toUtc() => SchedulePeriod(DateTime.utc(from.year, from.month, from.day), DateTime.utc(to.year, to.month, to.day));
}