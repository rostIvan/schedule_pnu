import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/model/schedule.dart';
import 'package:lessons_schedule_pnu/util/date.dart';

enum TimelineCircle {
  FILLED,
  UNFILLED,
  SELECTED_INDICATOR
}

class ScheduleTimeline extends StatelessWidget {
  final Future<List<Lesson>> scheduleFuture;

  const ScheduleTimeline({Key key, this.scheduleFuture}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: scheduleFuture,
        builder: (context, AsyncSnapshot<List<Lesson>> snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snap.hasError) {
                if(snap.error is SocketException)
                  return Center(child: Text('Немає інтернет з\'єднання'));
                return SizedBox();
              }
              else
                return snap.hasData && snap.data.isNotEmpty ?
                ListView(padding: EdgeInsets.zero, children: _buildItems(snap.data)) :
                Center(child: Text('Вихідний'));
          }
        }
    );
  }

  List<Widget> _buildItems(List<Lesson> lessons) {
    var items = lessons
      .map((lesson) => _lessonOrEmpty(lesson))
      .map((lesson) => _mapTimelineItem(lesson))
        .toList();
    setTimelineRanges(items);
    return items;
  }

  void setTimelineRanges(List<TimelineItem> items) {
    items.first = items.first.makeFirst();
    items.last = items.last.makeLast();
  }

  TimelineItem _mapTimelineItem(Lesson lesson) {
    DateTime current = DateTime.now();
    var timelineData = TimelineData(
            '${lesson.number} пара',
            lesson.time.timeStart,
            lesson.time.timeEnd,
            audience: lesson.audience,
            lessonInfo: lesson.info
        );
    final itemStartTime = parseTime(lesson.date.fullDate, lesson.time.timeStart);
    final itemEndTime = parseTime(lesson.date.fullDate, lesson.time.timeEnd);
    if(current.isAfter(itemStartTime) && current.isBefore(itemEndTime) || current.isAtSameMomentAs(itemStartTime) || current.isAtSameMomentAs(itemEndTime))
      return TimelineItem(timelineData, circle: TimelineCircle.SELECTED_INDICATOR, filledBackground: true);
    if(current.isBefore(itemStartTime))
      return TimelineItem(timelineData, circle: TimelineCircle.UNFILLED);
    else if(current.isAfter(itemEndTime))
      return TimelineItem(timelineData, circle: TimelineCircle.FILLED);
    return TimelineItem(timelineData);
  }

  Lesson _lessonOrEmpty(Lesson lesson) => Lesson(
      lesson.number,
      lesson.time,
      lesson.audience == null ? '' : lesson.audience,
      lesson.info == null ? '---' : lesson.info,
      lesson.date
  );
}

class TimelineItem extends StatelessWidget {
  final TimelineData timelineData;
  final bool isLast;
  final bool isFirst;
  final TimelineCircle circle;
  final bool filledBackground;

  const TimelineItem(this.timelineData, {
    Key key,
    this.isLast = false,
    this.isFirst = false,
    this.circle = TimelineCircle.UNFILLED,
    this.filledBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    decoration: filledBackground ? BoxDecoration(color: Colors.blue) : BoxDecoration(),
    padding: EdgeInsets.all(0.0),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _widgets()
    ),
  );

  List<Widget> _widgets() => <Widget>[
      _leftSide(),
      _lineArea(),
      _timeArea(),
      _rightSide()
    ];

  Widget _leftSide() => Container(
    width: 60.0,
    child: Column(
      children: <Widget>[
        Text('${timelineData.lessonNumber}',
          style: TextStyle(color: filledBackground ? Colors.white.withAlpha(215) : Colors.black),
        ),
        _infoSide()
      ],
    ),
  );

  Widget _infoSide() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: timelineData.audience.isEmpty ? SizedBox() : Text('${timelineData.audience}',
      style: TextStyle(color: filledBackground ? Colors.white : Colors.blue),
    ),
  );

  Widget _lineArea() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          isFirst ? SizedBox(height: 34.0) : Container(height: 34.0, width: 2.0,
              decoration: BoxDecoration(color: filledBackground ? Colors.white : Colors.blue)),
          circle == TimelineCircle.FILLED ? _filledCircle() : circle == TimelineCircle.UNFILLED ? _unfilledCircle() : _selectedCircle(),
          isLast ? SizedBox(height: 34.0) : Container(height: 34.0, width: 2.0,
              decoration: BoxDecoration(color: filledBackground ? Colors.white : Colors.blue)),
        ]);

  Widget _timeArea() => Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center ,
        children: <Widget>[ Text('${timelineData.timeStart}',
          style: TextStyle(color: filledBackground ? Colors.white : Colors.blue),
        ), Text('${timelineData.timeEnd}',
          style: TextStyle(color: filledBackground ? Colors.white : Colors.blue),
        ) ]
    ),
  );

  Widget _rightSide() => Flexible(
    child: Text('${timelineData.lessonInfo}',
        style: TextStyle(color: filledBackground ? Colors.white : Colors.black),
        softWrap: true,
        overflow: TextOverflow.fade
    ),
  );

  Widget _selectedCircle() => _circle(Colors.blue.shade200, Colors.blue, Colors.white);
  Widget _filledCircle() => _circle(Colors.transparent, Colors.blue, Colors.transparent);
  Widget _unfilledCircle() => _circle(Colors.transparent, Colors.blue, Colors.white);

  Widget _circle(Color outerColor, Color middleColor, Color innerColor) => Container(
      height: 22.0,
      width: 22.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: outerColor),
      child: Container(
          margin: EdgeInsets.all(4.0),
          decoration:  BoxDecoration(shape: BoxShape.circle, color: middleColor),
          child: Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(shape: BoxShape.circle, color: innerColor),
          )
      )
  );

  TimelineItem makeFirst() => TimelineItem(timelineData, isFirst: true, filledBackground: filledBackground, circle: circle, isLast: isLast);
  TimelineItem makeLast() => TimelineItem(timelineData, isLast: true, filledBackground: filledBackground, circle: circle, isFirst: isFirst);

  TimelineItem makeSelectedCircle() => TimelineItem(timelineData, isLast: isLast, isFirst: isFirst, filledBackground: filledBackground, circle: TimelineCircle.SELECTED_INDICATOR);
  TimelineItem makeFilledCircle() => TimelineItem(timelineData, isLast: isLast, isFirst: isFirst, filledBackground: filledBackground, circle: TimelineCircle.FILLED);
  TimelineItem makeUnfilledCircle() => TimelineItem(timelineData, isLast: isLast, isFirst: isFirst, filledBackground: filledBackground, circle: TimelineCircle.UNFILLED);
}

class TimelineData {
  final String lessonNumber;
  final String audience;
  final String timeStart;
  final String timeEnd;
  final String lessonInfo;

  TimelineData(this.lessonNumber, this.timeStart, this.timeEnd, {this.audience = '', this.lessonInfo = ''});
}