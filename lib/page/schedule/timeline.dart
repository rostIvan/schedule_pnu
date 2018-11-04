import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';


enum TimelineCircle {
  FILLED,
  UNFILLED,
  SELECTED_INDICATOR
}

class ScheduleTimeline extends StatelessWidget {
  final SelectedData data;

  const ScheduleTimeline(this.data, {Key key}) : super(key: key);

  // TODO add timeline data
  @override
  Widget build(BuildContext context) {
    var items = _items();
    return ListView(padding: EdgeInsets.zero, children: items);
  }

  List<Widget> _items() => <Widget>[
      TimelineItem(
          TimelineData('1 пара', '9:00', '10:20', audience: '320a', lessonInfo: 'dasdsaljdlkdlkasjdklsajdlksjakajskjasldkjlskdjalkdjaslkdasjldkjaklsasdj'),
          circle: TimelineCircle.FILLED,
          isFirst: true
      ),
      TimelineItem(
          TimelineData('2 пара', '10:20', '11:00', audience: '320', lessonInfo: 'dasdsaljdlkdlkasjdklsajdlksja'),
          circle: TimelineCircle.FILLED
      ),
      TimelineItem(
        TimelineData('3 пара', '12:15', '13:10', audience: '309b', lessonInfo: 'dklasdlkasjdlkasjdlkajsdkasjdskdjalksjsalkdjsalkdaj'),
        circle: TimelineCircle.SELECTED_INDICATOR,
        filledBackground: false,
      ),
      TimelineItem(
          TimelineData('4 пара', '13:20', '14:30', audience: '310', lessonInfo: 'No lessons'),
          circle: TimelineCircle.UNFILLED
      ),
      TimelineItem(
          TimelineData('5 пара', '14:50', '15:50', audience: '318', lessonInfo: 'sjdklsajdlksajdlkajdljdlkasjdklsajdlksajdlkajdljdlkasjjdlksajdlkajdlj'),
          circle: TimelineCircle.UNFILLED,
          isLast: true
      ),
    ];

  Center _info() => Center(child: Text('${data.scheduleType} => ${data.selected}'));
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
    this.circle = TimelineCircle.FILLED,
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
    child: Text('${timelineData.audience}',
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
}

class TimelineData {
  final String lessonNumber;
  final String audience;
  final String timeStart;
  final String timeEnd;
  final String lessonInfo;

  TimelineData(this.lessonNumber, this.timeStart, this.timeEnd, {this.audience = '', this.lessonInfo = ''});
}