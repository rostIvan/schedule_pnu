import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/page/home/cards.dart';
import 'package:lessons_schedule_pnu/page/schedule/scrollable.dart';
import 'package:lessons_schedule_pnu/page/schedule/timeline.dart';
import 'package:lessons_schedule_pnu/util/date.dart';

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

class SingleDateSchedule extends StatelessWidget {
  final SelectedData data;
  final DateTime dateTime;
  final HeroText heroText;
  const SingleDateSchedule(this.data, this.dateTime, this.heroText, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ScrollableApp(
        heroText,
        [dateTime],
        body: ScheduleTimeline(data),
    ),
  );
}

class RangeDateSchedule extends StatelessWidget {
  final SelectedData data;
  final SchedulePeriod period;
  final HeroText heroText;
  RangeDateSchedule (this.data, this.period, this.heroText, {Key key});

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs();
    final pages = _pages(tabs);
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

  List<Widget> _pages(List<Widget> tabs) => List.generate(tabs.length, (i) => ScheduleTimeline(data));

  List<Widget> _tabs() => _dates()
      .map((date) => Tab(child: Text(formatSingleDate(date))))
      .toList();

  List<DateTime> _dates() {
    final utcPeriod = period.toUtc();
    final dates = dateRange(utcPeriod.from, utcPeriod.to);
    return dates;
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