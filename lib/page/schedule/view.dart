import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/util/date.dart';

class SchedulePage extends StatefulWidget {
  final SelectedData data;
  final String scheduleTime;
  final DateTime dateTime;
  final SchedulePeriod period;
  const SchedulePage(this.data, {Key key, this.dateTime, this.period, this.scheduleTime}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage>  {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Розклад на ${widget.scheduleTime}')),
    body: Center(child: _info()),
  );

  Text _info() => Text('${widget.data.scheduleType} => ${widget.data.selected}\n\n' + (widget.dateTime != null ? formatDate(widget.dateTime) : widget.period.toString()));
}

class SchedulePeriod {
  final DateTime from;
  final DateTime to;
  SchedulePeriod(this.from, this.to);
  @override
  String toString() => '${formatRangeDates(from, to)}';
}